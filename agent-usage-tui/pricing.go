package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"
)

const litellmURL = "https://raw.githubusercontent.com/BerriAI/litellm/main/model_prices_and_context_window.json"

type modelRates struct {
	Input      float64
	Output     float64
	CacheRead  *float64
	CacheWrite *float64
}

type PricingResolver struct {
	prices       map[string]json.RawMessage
	fetchError   string
	lookupCache  map[string]*modelRates
	modelAliases map[string]string
}

func NewPricingResolver() *PricingResolver {
	p := &PricingResolver{
		lookupCache: make(map[string]*modelRates),
		modelAliases: map[string]string{
			"gpt-5.3-codex":                        "gpt-5.2-codex",
			"antigravity-gemini-3.1-pro":           "gemini-2.5-pro",
			"gemini-3.1-pro-preview":               "gemini-2.5-pro",
			"gemini-3.1-pro-preview-customtools":   "gemini-2.5-pro",
			"antigravity-claude-opus-4-6-thinking": "claude-opus-4-1",
		},
	}
	p.prices, p.fetchError = fetchLiteLLMPrices()
	return p
}

func (p *PricingResolver) EstimateCost(model, provider string, input, output, cacheRead, cacheWrite int64) (float64, bool) {
	rates := p.findRates(model, provider)
	if rates == nil {
		return 0, false
	}

	inputRate := rates.Input
	outputRate := rates.Output

	cacheReadRate := inputRate
	if rates.CacheRead != nil {
		cacheReadRate = *rates.CacheRead
	}
	cacheWriteRate := inputRate
	if rates.CacheWrite != nil {
		cacheWriteRate = *rates.CacheWrite
	}

	cost := float64(input)*inputRate +
		float64(output)*outputRate +
		float64(cacheRead)*cacheReadRate +
		float64(cacheWrite)*cacheWriteRate

	return cost, true
}

func (p *PricingResolver) findRates(model, provider string) *modelRates {
	key := provider + "|" + model
	if cached, ok := p.lookupCache[key]; ok {
		return cached
	}

	candidates := p.candidateKeys(model, provider)

	// Direct lookup
	for _, c := range candidates {
		if raw, ok := p.prices[c]; ok {
			if rates := extractRates(raw); rates != nil {
				p.lookupCache[key] = rates
				return rates
			}
		}
	}

	// Fuzzy match
	lowered := make([]string, len(candidates))
	for i, c := range candidates {
		lowered[i] = strings.ToLower(c)
	}
	for priceKey, raw := range p.prices {
		pkLower := strings.ToLower(priceKey)
		for _, c := range lowered {
			if pkLower == c || strings.HasSuffix(pkLower, "/"+c) || strings.Contains(pkLower, c) {
				if rates := extractRates(raw); rates != nil {
					p.lookupCache[key] = rates
					return rates
				}
			}
		}
	}

	p.lookupCache[key] = nil
	return nil
}

func (p *PricingResolver) candidateKeys(model, provider string) []string {
	model = strings.TrimSpace(model)
	provider = strings.TrimSpace(provider)

	raw := []string{model}

	if alias, ok := p.modelAliases[model]; ok {
		raw = append(raw, alias)
	}

	stripped := model
	for _, prefix := range []string{"antigravity-", "openai/", "azure/", "google/"} {
		if strings.HasPrefix(stripped, prefix) {
			stripped = strings.TrimPrefix(stripped, prefix)
			raw = append(raw, stripped)
		}
	}
	if strings.Contains(stripped, "-preview-customtools") {
		raw = append(raw, strings.ReplaceAll(stripped, "-preview-customtools", ""))
	}
	if strings.Contains(stripped, "-preview") {
		raw = append(raw, strings.ReplaceAll(stripped, "-preview", ""))
	}

	seen := make(map[string]bool)
	var out []string
	for _, item := range raw {
		if item == "" {
			continue
		}
		variants := []string{item, strings.ToLower(item)}
		if provider != "" {
			variants = append(variants,
				fmt.Sprintf("%s/%s", provider, item),
				fmt.Sprintf("%s/%s", provider, strings.ToLower(item)),
				fmt.Sprintf("openrouter/%s/%s", provider, item),
			)
		}
		for _, v := range variants {
			if v != "" && !seen[v] {
				seen[v] = true
				out = append(out, v)
			}
		}
	}
	return out
}

type litellmEntry struct {
	InputCostPerToken  *float64 `json:"input_cost_per_token"`
	OutputCostPerToken *float64 `json:"output_cost_per_token"`
	CacheCreation      *float64 `json:"cache_creation_input_token_cost"`
	CacheRead          *float64 `json:"cache_read_input_token_cost"`
}

func extractRates(raw json.RawMessage) *modelRates {
	var entry litellmEntry
	if err := json.Unmarshal(raw, &entry); err != nil {
		return nil
	}
	if entry.InputCostPerToken == nil || entry.OutputCostPerToken == nil {
		return nil
	}
	return &modelRates{
		Input:      *entry.InputCostPerToken,
		Output:     *entry.OutputCostPerToken,
		CacheRead:  entry.CacheRead,
		CacheWrite: entry.CacheCreation,
	}
}

func fetchLiteLLMPrices() (map[string]json.RawMessage, string) {
	client := &http.Client{Timeout: 15 * time.Second}
	resp, err := client.Get(litellmURL)
	if err != nil {
		return nil, err.Error()
	}
	defer resp.Body.Close()

	var data map[string]json.RawMessage
	if err := json.NewDecoder(resp.Body).Decode(&data); err != nil {
		return nil, err.Error()
	}
	return data, ""
}
