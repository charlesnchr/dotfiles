package main

import (
	"bufio"
	"database/sql"
	"encoding/json"
	"math"
	"os"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
	"time"

	_ "modernc.org/sqlite"
)

// Usage tracks token counts and cost for a single model.
type Usage struct {
	Input      int64
	Output     int64
	CacheRead  int64
	CacheWrite int64
	Total      int64
	Cost       float64
}

func (u *Usage) Add(other Usage) {
	u.Input += other.Input
	u.Output += other.Output
	u.CacheRead += other.CacheRead
	u.CacheWrite += other.CacheWrite
	u.Total += other.Total
	u.Cost += other.Cost
}

// AgentData holds per-model breakdown and an aggregate total for one agent.
type AgentData struct {
	Models map[string]Usage // model name -> usage
	Total  Usage
}

func newAgentData() AgentData {
	return AgentData{Models: make(map[string]Usage)}
}

func (a *AgentData) add(model string, u Usage) {
	existing := a.Models[model]
	existing.Add(u)
	a.Models[model] = existing
	a.Total.Add(u)
}

// homeDir returns the user's home directory.
func homeDir() string {
	h, _ := os.UserHomeDir()
	return h
}

func isToday(t time.Time) bool {
	now := time.Now()
	y1, m1, d1 := now.Date()
	y2, m2, d2 := t.Date()
	return y1 == y2 && m1 == m2 && d1 == d2
}

func isModifiedToday(path string) bool {
	info, err := os.Stat(path)
	if err != nil {
		return false
	}
	return isToday(info.ModTime()) || info.ModTime().After(time.Now().Truncate(24*time.Hour))
}

func parseTS(s string) (time.Time, bool) {
	s = strings.Replace(s, "Z", "+00:00", 1)
	t, err := time.Parse(time.RFC3339, s)
	if err != nil {
		t, err = time.Parse("2006-01-02T15:04:05.999999999-07:00", s)
		if err != nil {
			return time.Time{}, false
		}
	}
	return t, true
}

func intVal(v interface{}) int64 {
	switch n := v.(type) {
	case float64:
		return int64(n)
	case json.Number:
		i, _ := n.Int64()
		return i
	}
	return 0
}

func floatVal(v interface{}) float64 {
	switch n := v.(type) {
	case float64:
		return n
	case json.Number:
		f, _ := n.Float64()
		return f
	}
	return 0
}

func strVal(v interface{}) string {
	s, _ := v.(string)
	return s
}

// scanJSONL reads a file line by line, calling fn for each parsed JSON object.
func scanJSONL(path string, fn func(map[string]interface{})) {
	f, err := os.Open(path)
	if err != nil {
		return
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)
	buf := make([]byte, 1024*1024)
	scanner.Buffer(buf, 1024*1024)

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}
		var obj map[string]interface{}
		if err := json.Unmarshal([]byte(line), &obj); err != nil {
			continue
		}
		fn(obj)
	}
}

// findCodexFiles walks the sessions directory to find all rollout JSONL files.
// Go's filepath.Glob doesn't support ** recursion, so we walk manually.
func findCodexFiles(root string) []string {
	var files []string
	filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return nil
		}
		if !info.IsDir() && strings.HasPrefix(filepath.Base(path), "rollout-") && strings.HasSuffix(path, ".jsonl") {
			files = append(files, path)
		}
		return nil
	})
	return files
}

func mapGet(m map[string]interface{}, key string) map[string]interface{} {
	v, ok := m[key]
	if !ok {
		return nil
	}
	sub, ok := v.(map[string]interface{})
	if !ok {
		return nil
	}
	return sub
}

// --- Claude ---

func collectClaude(pricing *PricingResolver) AgentData {
	data := newAgentData()
	seen := make(map[string]bool)
	pattern := filepath.Join(homeDir(), ".claude", "projects", "*", "*.jsonl")
	files, _ := filepath.Glob(pattern)

	for _, fp := range files {
		if !isModifiedToday(fp) {
			continue
		}
		scanJSONL(fp, func(obj map[string]interface{}) {
			if strVal(obj["type"]) != "assistant" {
				return
			}
			ts, ok := parseTS(strVal(obj["timestamp"]))
			if !ok || !isToday(ts) {
				return
			}

			msg := mapGet(obj, "message")
			if msg == nil {
				return
			}
			usage := mapGet(msg, "usage")
			if usage == nil {
				return
			}

			input := intVal(usage["input_tokens"])
			output := intVal(usage["output_tokens"])
			cacheWrite := intVal(usage["cache_creation_input_tokens"])
			cacheRead := intVal(usage["cache_read_input_tokens"])
			if input+output+cacheWrite+cacheRead <= 0 {
				return
			}

			msgID := strVal(msg["id"])
			reqID := strVal(obj["requestId"])
			if msgID != "" && reqID != "" {
				key := msgID + ":" + reqID
				if seen[key] {
					return
				}
				seen[key] = true
			}

			model := strVal(msg["model"])
			if model == "" {
				model = "unknown"
			}
			provider := "anthropic"
			total := intVal(usage["total_tokens"])
			if total == 0 {
				total = input + output + cacheWrite + cacheRead
			}

			cost, ok := pricing.EstimateCost(model, provider, input, output, cacheRead, cacheWrite)
			if !ok {
				cost = 0
			}

			data.add(model, Usage{
				Input: input, Output: output,
				CacheRead: cacheRead, CacheWrite: cacheWrite,
				Total: total, Cost: cost,
			})
		})
	}
	return data
}

// --- OpenClaw ---

func collectOpenClaw(pricing *PricingResolver) AgentData {
	data := newAgentData()
	pattern := filepath.Join(homeDir(), ".openclaw", "agents", "*", "sessions", "*.jsonl")
	files, _ := filepath.Glob(pattern)

	for _, fp := range files {
		if !isModifiedToday(fp) {
			continue
		}
		scanJSONL(fp, func(obj map[string]interface{}) {
			if strVal(obj["type"]) != "message" {
				return
			}
			msg := mapGet(obj, "message")
			if msg == nil || strVal(msg["role"]) != "assistant" {
				return
			}
			ts, ok := parseTS(strVal(obj["timestamp"]))
			if !ok || !isToday(ts) {
				return
			}

			usage := mapGet(msg, "usage")
			if usage == nil {
				return
			}

			input := intVal(usage["input"])
			output := intVal(usage["output"])
			cacheRead := intVal(usage["cacheRead"])
			cacheWrite := intVal(usage["cacheWrite"])
			total := intVal(usage["totalTokens"])
			if total <= 0 {
				return
			}

			model := strVal(msg["model"])
			if model == "" {
				model = "unknown"
			}
			provider := strVal(msg["provider"])

			var observedCost float64
			if costObj := mapGet(usage, "cost"); costObj != nil {
				observedCost = floatVal(costObj["total"])
			} else {
				observedCost = floatVal(usage["cost"])
			}

			cost, ok := pricing.EstimateCost(model, provider, input, output, cacheRead, cacheWrite)
			if !ok {
				cost = observedCost
			}

			data.add(model, Usage{
				Input: input, Output: output,
				CacheRead: cacheRead, CacheWrite: cacheWrite,
				Total: total, Cost: cost,
			})
		})
	}
	return data
}

// --- OpenCode ---

func collectOpenCode(pricing *PricingResolver) AgentData {
	data := newAgentData()
	dbPath := filepath.Join(homeDir(), ".local", "share", "opencode", "opencode.db")
	if _, err := os.Stat(dbPath); err != nil {
		return data
	}

	db, err := sql.Open("sqlite", dbPath)
	if err != nil {
		return data
	}
	defer db.Close()

	todayStart := time.Date(time.Now().Year(), time.Now().Month(), time.Now().Day(), 0, 0, 0, 0, time.Local)
	startMs := todayStart.UnixMilli()

	rows, err := db.Query(`
		SELECT
			json_extract(data, '$.modelID'),
			json_extract(data, '$.providerID'),
			json_extract(data, '$.tokens.input'),
			json_extract(data, '$.tokens.output'),
			json_extract(data, '$.tokens.cache.read'),
			json_extract(data, '$.tokens.cache.write'),
			json_extract(data, '$.tokens.total'),
			json_extract(data, '$.cost')
		FROM message
		WHERE json_extract(data, '$.role') = 'assistant'
		  AND json_extract(data, '$.tokens.total') > 0
		  AND time_created >= ?
	`, startMs)
	if err != nil {
		return data
	}
	defer rows.Close()

	for rows.Next() {
		var model, provider sql.NullString
		var input, output, cacheRead, cacheWrite, total sql.NullInt64
		var observedCost sql.NullFloat64

		if err := rows.Scan(&model, &provider, &input, &output, &cacheRead, &cacheWrite, &total, &observedCost); err != nil {
			continue
		}

		m := "unknown"
		if model.Valid {
			m = model.String
		}
		prov := ""
		if provider.Valid {
			prov = provider.String
		}

		cost, ok := pricing.EstimateCost(m, prov, input.Int64, output.Int64, cacheRead.Int64, cacheWrite.Int64)
		if !ok {
			cost = observedCost.Float64
		}

		data.add(m, Usage{
			Input: input.Int64, Output: output.Int64,
			CacheRead: cacheRead.Int64, CacheWrite: cacheWrite.Int64,
			Total: total.Int64, Cost: cost,
		})
	}
	return data
}

// --- Codex ---

func collectCodexByDay(pricing *PricingResolver) map[string]AgentData {
	byDay := make(map[string]AgentData)
	sessionsRoot := filepath.Join(homeDir(), ".codex", "sessions")
	if _, err := os.Stat(sessionsRoot); err != nil {
		return byDay
	}

	for _, fp := range findCodexFiles(sessionsRoot) {
		currentModel := "unknown"
		currentProvider := "openai"
		currentTurnID := ""
		sessionID := strings.TrimSuffix(filepath.Base(fp), filepath.Ext(fp))
		seenTurns := make(map[string]bool)

		scanJSONL(fp, func(obj map[string]interface{}) {
			objType := strVal(obj["type"])
			payload := mapGet(obj, "payload")
			if payload == nil {
				payload = make(map[string]interface{})
			}

			switch objType {
			case "session_meta":
				if sid := strVal(payload["id"]); sid != "" {
					sessionID = sid
				}
				if mp := strVal(payload["model_provider"]); mp != "" {
					currentProvider = mp
				}
				return
			case "turn_context":
				if m := strVal(payload["model"]); m != "" {
					currentModel = m
				}
				currentTurnID = strVal(payload["turn_id"])
				return
			}

			if objType != "event_msg" || strVal(payload["type"]) != "token_count" {
				return
			}

			info := mapGet(payload, "info")
			if info == nil {
				return
			}
			usage := mapGet(info, "last_token_usage")
			if usage == nil {
				return
			}

			turnKey := currentTurnID
			if turnKey == "" {
				turnKey = strVal(payload["turn_id"])
			}
			if turnKey != "" {
				dedupeKey := sessionID + ":" + turnKey
				if seenTurns[dedupeKey] {
					return
				}
				seenTurns[dedupeKey] = true
			}

			input := intVal(usage["input_tokens"])
			output := intVal(usage["output_tokens"])
			cacheRead := intVal(usage["cached_input_tokens"])
			total := intVal(usage["total_tokens"])
			if total <= 0 {
				total = input + output + cacheRead
			}
			if total <= 0 {
				return
			}

			ts, ok := parseTS(strVal(obj["timestamp"]))
			if !ok {
				return
			}
			day := ts.Format("2006-01-02")

			cost, ok := pricing.EstimateCost(currentModel, currentProvider, input, output, cacheRead, 0)
			if !ok {
				cost = 0
			}

			dayData, exists := byDay[day]
			if !exists {
				dayData = newAgentData()
			}
			dayData.add(currentModel, Usage{
				Input: input, Output: output,
				CacheRead: cacheRead, CacheWrite: 0,
				Total: total, Cost: cost,
			})
			byDay[day] = dayData
		})
	}

	return byDay
}

func collectCodex(pricing *PricingResolver) AgentData {
	byDay := collectCodexByDay(pricing)
	today := time.Now().Format("2006-01-02")
	if data, ok := byDay[today]; ok {
		return data
	}
	return newAgentData()
}

// --- OpenWhispr ---

func collectOpenWhispr() AgentData {
	data := newAgentData()

	var dbPath string
	if runtime.GOOS == "darwin" {
		dbPath = filepath.Join(homeDir(), "Library", "Application Support", "open-whispr", "transcriptions.db")
	} else {
		dbPath = filepath.Join(homeDir(), ".local", "share", "open-whispr", "transcriptions.db")
	}

	if _, err := os.Stat(dbPath); err != nil {
		return data
	}

	db, err := sql.Open("sqlite", dbPath)
	if err != nil {
		return data
	}
	defer db.Close()

	// Check table exists
	var tableName string
	err = db.QueryRow("SELECT name FROM sqlite_master WHERE type='table' AND name='transcription_usage'").Scan(&tableName)
	if err != nil {
		return data
	}

	// Check columns
	colRows, err := db.Query("PRAGMA table_info(transcription_usage)")
	if err != nil {
		return data
	}
	hasDuration := false
	for colRows.Next() {
		var cid int
		var name, ctype string
		var notnull int
		var dflt sql.NullString
		var pk int
		if err := colRows.Scan(&cid, &name, &ctype, &notnull, &dflt, &pk); err != nil {
			continue
		}
		if name == "duration_seconds" {
			hasDuration = true
		}
	}
	colRows.Close()

	durationCol := "0"
	if hasDuration {
		durationCol = "duration_seconds"
	}

	query := `SELECT created_at, model, provider, input_tokens, output_tokens, audio_tokens, total_tokens, ` +
		durationCol + ` as dur FROM transcription_usage WHERE created_at >= date('now')`

	rows, err := db.Query(query)
	if err != nil {
		return data
	}
	defer rows.Close()

	tokenPricing := map[string][2]float64{
		"gpt-4o-transcribe":      {6.0, 10.0},
		"gpt-4o-mini-transcribe": {3.0, 5.0},
		"whisper-1":              {6.0, 0.0},
	}
	hourlyPricing := map[string]float64{
		"whisper-large-v3":       0.111,
		"whisper-large-v3-turbo": 0.04,
	}

	for rows.Next() {
		var tsStr, model sql.NullString
		var provider sql.NullString
		var inputTok, outputTok, audioTok, totalTok sql.NullInt64
		var durSec sql.NullFloat64

		if err := rows.Scan(&tsStr, &model, &provider, &inputTok, &outputTok, &audioTok, &totalTok, &durSec); err != nil {
			continue
		}

		m := "unknown"
		if model.Valid {
			m = model.String
		}

		ts := strings.Replace(tsStr.String, "Z", "+00:00", 1)
		t, err := time.Parse(time.RFC3339, ts)
		if err != nil {
			t, err = time.Parse("2006-01-02 15:04:05", tsStr.String)
			if err != nil {
				continue
			}
		}
		if !isToday(t) {
			continue
		}

		var cost float64
		var inputVal int64

		if hourly, ok := hourlyPricing[m]; ok && durSec.Float64 > 0 {
			billed := math.Max(durSec.Float64, 10.0)
			cost = (billed / 3600.0) * hourly
			inputVal = int64(math.Round(durSec.Float64))
		} else {
			rates, ok := tokenPricing[m]
			if !ok {
				rates = [2]float64{6.0, 10.0}
			}
			cost = (float64(audioTok.Int64)*rates[0] + float64(outputTok.Int64)*rates[1]) / 1_000_000.0
			inputVal = audioTok.Int64
		}

		data.add(m, Usage{
			Input: inputVal, Output: outputTok.Int64,
			CacheRead: 0, CacheWrite: 0,
			Total: totalTok.Int64, Cost: cost,
		})
	}
	return data
}

// CollectAll gathers today's usage from all agents.
func CollectAll(pricing *PricingResolver) map[string]AgentData {
	return map[string]AgentData{
		"ClaudeCode": collectClaude(pricing),
		"OpenCode":   collectOpenCode(pricing),
		"Codex":      collectCodex(pricing),
		"OpenClaw":   collectOpenClaw(pricing),
		"OpenWhispr": collectOpenWhispr(),
	}
}

// --- Daily (all-time) collectors ---

// DailyRow holds per-agent cost for a single day.
type DailyRow struct {
	Date   string
	Agents map[string]float64 // agent name -> cost
	Total  float64
}

func collectClaudeDaily(pricing *PricingResolver) map[string]float64 {
	costs := make(map[string]float64)
	seen := make(map[string]bool)
	pattern := filepath.Join(homeDir(), ".claude", "projects", "*", "*.jsonl")
	files, _ := filepath.Glob(pattern)

	for _, fp := range files {
		scanJSONL(fp, func(obj map[string]interface{}) {
			if strVal(obj["type"]) != "assistant" {
				return
			}
			ts, ok := parseTS(strVal(obj["timestamp"]))
			if !ok {
				return
			}

			msg := mapGet(obj, "message")
			if msg == nil {
				return
			}
			usage := mapGet(msg, "usage")
			if usage == nil {
				return
			}

			input := intVal(usage["input_tokens"])
			output := intVal(usage["output_tokens"])
			cacheWrite := intVal(usage["cache_creation_input_tokens"])
			cacheRead := intVal(usage["cache_read_input_tokens"])
			if input+output+cacheWrite+cacheRead <= 0 {
				return
			}

			msgID := strVal(msg["id"])
			reqID := strVal(obj["requestId"])
			if msgID != "" && reqID != "" {
				key := msgID + ":" + reqID
				if seen[key] {
					return
				}
				seen[key] = true
			}

			model := strVal(msg["model"])
			if model == "" {
				model = "unknown"
			}
			provider := "anthropic"

			cost, ok := pricing.EstimateCost(model, provider, input, output, cacheRead, cacheWrite)
			if !ok {
				cost = 0
			}

			day := ts.Format("2006-01-02")
			costs[day] += cost
		})
	}
	return costs
}

func collectOpenClawDaily(pricing *PricingResolver) map[string]float64 {
	costs := make(map[string]float64)
	pattern := filepath.Join(homeDir(), ".openclaw", "agents", "*", "sessions", "*.jsonl")
	files, _ := filepath.Glob(pattern)

	for _, fp := range files {
		scanJSONL(fp, func(obj map[string]interface{}) {
			if strVal(obj["type"]) != "message" {
				return
			}
			msg := mapGet(obj, "message")
			if msg == nil || strVal(msg["role"]) != "assistant" {
				return
			}
			ts, ok := parseTS(strVal(obj["timestamp"]))
			if !ok {
				return
			}

			usage := mapGet(msg, "usage")
			if usage == nil {
				return
			}

			input := intVal(usage["input"])
			output := intVal(usage["output"])
			cacheRead := intVal(usage["cacheRead"])
			cacheWrite := intVal(usage["cacheWrite"])
			total := intVal(usage["totalTokens"])
			if total <= 0 {
				return
			}

			model := strVal(msg["model"])
			if model == "" {
				model = "unknown"
			}
			provider := strVal(msg["provider"])

			var observedCost float64
			if costObj := mapGet(usage, "cost"); costObj != nil {
				observedCost = floatVal(costObj["total"])
			} else {
				observedCost = floatVal(usage["cost"])
			}

			cost, ok := pricing.EstimateCost(model, provider, input, output, cacheRead, cacheWrite)
			if !ok {
				cost = observedCost
			}

			day := ts.Format("2006-01-02")
			costs[day] += cost
		})
	}
	return costs
}

func collectOpenCodeDaily(pricing *PricingResolver) map[string]float64 {
	costs := make(map[string]float64)
	dbPath := filepath.Join(homeDir(), ".local", "share", "opencode", "opencode.db")
	if _, err := os.Stat(dbPath); err != nil {
		return costs
	}

	db, err := sql.Open("sqlite", dbPath)
	if err != nil {
		return costs
	}
	defer db.Close()

	rows, err := db.Query(`
		SELECT
			time_created,
			json_extract(data, '$.modelID'),
			json_extract(data, '$.providerID'),
			json_extract(data, '$.tokens.input'),
			json_extract(data, '$.tokens.output'),
			json_extract(data, '$.tokens.cache.read'),
			json_extract(data, '$.tokens.cache.write'),
			json_extract(data, '$.cost')
		FROM message
		WHERE json_extract(data, '$.role') = 'assistant'
		  AND json_extract(data, '$.tokens.total') > 0
	`)
	if err != nil {
		return costs
	}
	defer rows.Close()

	for rows.Next() {
		var tsMs sql.NullFloat64
		var model, provider sql.NullString
		var input, output, cacheRead, cacheWrite sql.NullInt64
		var observedCost sql.NullFloat64

		if err := rows.Scan(&tsMs, &model, &provider, &input, &output, &cacheRead, &cacheWrite, &observedCost); err != nil {
			continue
		}

		m := "unknown"
		if model.Valid {
			m = model.String
		}
		prov := ""
		if provider.Valid {
			prov = provider.String
		}

		cost, ok := pricing.EstimateCost(m, prov, input.Int64, output.Int64, cacheRead.Int64, cacheWrite.Int64)
		if !ok {
			cost = observedCost.Float64
		}

		dt := time.UnixMilli(int64(tsMs.Float64))
		day := dt.Format("2006-01-02")
		costs[day] += cost
	}
	return costs
}

func collectCodexDaily(pricing *PricingResolver) map[string]float64 {
	costs := make(map[string]float64)
	for day, data := range collectCodexByDay(pricing) {
		costs[day] = data.Total.Cost
	}
	return costs
}

func collectOpenWhisprDaily() map[string]float64 {
	costs := make(map[string]float64)

	var dbPath string
	if runtime.GOOS == "darwin" {
		dbPath = filepath.Join(homeDir(), "Library", "Application Support", "open-whispr", "transcriptions.db")
	} else {
		dbPath = filepath.Join(homeDir(), ".local", "share", "open-whispr", "transcriptions.db")
	}

	if _, err := os.Stat(dbPath); err != nil {
		return costs
	}

	db, err := sql.Open("sqlite", dbPath)
	if err != nil {
		return costs
	}
	defer db.Close()

	var tableName string
	err = db.QueryRow("SELECT name FROM sqlite_master WHERE type='table' AND name='transcription_usage'").Scan(&tableName)
	if err != nil {
		return costs
	}

	colRows, err := db.Query("PRAGMA table_info(transcription_usage)")
	if err != nil {
		return costs
	}
	hasDuration := false
	for colRows.Next() {
		var cid int
		var name, ctype string
		var notnull int
		var dflt sql.NullString
		var pk int
		if err := colRows.Scan(&cid, &name, &ctype, &notnull, &dflt, &pk); err != nil {
			continue
		}
		if name == "duration_seconds" {
			hasDuration = true
		}
	}
	colRows.Close()

	durationCol := "0"
	if hasDuration {
		durationCol = "duration_seconds"
	}

	query := `SELECT created_at, model, provider, input_tokens, output_tokens, audio_tokens, total_tokens, ` +
		durationCol + ` as dur FROM transcription_usage`

	rows, err := db.Query(query)
	if err != nil {
		return costs
	}
	defer rows.Close()

	tokenPricing := map[string][2]float64{
		"gpt-4o-transcribe":      {6.0, 10.0},
		"gpt-4o-mini-transcribe": {3.0, 5.0},
		"whisper-1":              {6.0, 0.0},
	}
	hourlyPricing := map[string]float64{
		"whisper-large-v3":       0.111,
		"whisper-large-v3-turbo": 0.04,
	}

	for rows.Next() {
		var tsStr, model sql.NullString
		var provider sql.NullString
		var inputTok, outputTok, audioTok, totalTok sql.NullInt64
		var durSec sql.NullFloat64

		if err := rows.Scan(&tsStr, &model, &provider, &inputTok, &outputTok, &audioTok, &totalTok, &durSec); err != nil {
			continue
		}

		m := "unknown"
		if model.Valid {
			m = model.String
		}

		ts := strings.Replace(tsStr.String, "Z", "+00:00", 1)
		t, err := time.Parse(time.RFC3339, ts)
		if err != nil {
			t, err = time.Parse("2006-01-02 15:04:05", tsStr.String)
			if err != nil {
				continue
			}
		}

		var cost float64
		if hourly, ok := hourlyPricing[m]; ok && durSec.Float64 > 0 {
			billed := math.Max(durSec.Float64, 10.0)
			cost = (billed / 3600.0) * hourly
		} else {
			rates, ok := tokenPricing[m]
			if !ok {
				rates = [2]float64{6.0, 10.0}
			}
			cost = (float64(audioTok.Int64)*rates[0] + float64(outputTok.Int64)*rates[1]) / 1_000_000.0
		}

		day := t.Format("2006-01-02")
		costs[day] += cost
	}
	return costs
}

// CollectDaily gathers all-time daily cost breakdown per agent.
func CollectDaily(pricing *PricingResolver) []DailyRow {
	agentCosts := map[string]map[string]float64{
		"ClaudeCode": collectClaudeDaily(pricing),
		"OpenCode":   collectOpenCodeDaily(pricing),
		"Codex":      collectCodexDaily(pricing),
		"OpenClaw":   collectOpenClawDaily(pricing),
		"OpenWhispr": collectOpenWhisprDaily(),
	}

	// Collect all unique dates
	dateSet := make(map[string]bool)
	for _, dateCosts := range agentCosts {
		for day := range dateCosts {
			dateSet[day] = true
		}
	}

	dates := make([]string, 0, len(dateSet))
	for d := range dateSet {
		dates = append(dates, d)
	}
	sort.Sort(sort.Reverse(sort.StringSlice(dates))) // newest first

	var rows []DailyRow
	for _, day := range dates {
		row := DailyRow{
			Date:   day,
			Agents: make(map[string]float64),
		}
		for _, agent := range agentOrder {
			c := agentCosts[agent][day]
			row.Agents[agent] = c
			row.Total += c
		}
		rows = append(rows, row)
	}
	return rows
}
