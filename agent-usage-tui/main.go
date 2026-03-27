package main

import (
	"fmt"
	"os"
	"sort"
	"strings"
	"time"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/charmbracelet/lipgloss/table"
)

// agentOrder defines display order.
var agentOrder = []string{"ClaudeCode", "OpenCode", "Codex", "OpenClaw", "OpenWhispr"}

// --- Messages ---

type dataMsg map[string]AgentData
type dailyDataMsg []DailyRow
type tickMsg time.Time

// --- Model ---

type viewMode int

const (
	viewToday viewMode = iota
	viewDaily
)

type model struct {
	pricing   *PricingResolver
	data      map[string]AgentData
	dailyData []DailyRow
	view      viewMode
	width     int
	height    int
	loading   bool
	lastUpd   time.Time
}

func initialModel(pricing *PricingResolver) model {
	return model{
		pricing: pricing,
		loading: true,
		view:    viewToday,
	}
}

func (m model) Init() tea.Cmd {
	return tea.Batch(fetchData(m.pricing), doTick())
}

func doTick() tea.Cmd {
	return tea.Every(60*time.Second, func(t time.Time) tea.Msg {
		return tickMsg(t)
	})
}

func fetchData(pricing *PricingResolver) tea.Cmd {
	return func() tea.Msg {
		return dataMsg(CollectAll(pricing))
	}
}

func fetchDailyData(pricing *PricingResolver) tea.Cmd {
	return func() tea.Msg {
		return dailyDataMsg(CollectDaily(pricing))
	}
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "q", "ctrl+c":
			return m, tea.Quit
		case "r":
			m.loading = true
			if m.view == viewDaily {
				return m, fetchDailyData(m.pricing)
			}
			return m, fetchData(m.pricing)
		case "d":
			if m.view == viewToday {
				m.view = viewDaily
				if m.dailyData == nil {
					m.loading = true
					return m, fetchDailyData(m.pricing)
				}
			} else {
				m.view = viewToday
			}
		}
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
	case tickMsg:
		m.loading = true
		return m, tea.Batch(fetchData(m.pricing), doTick())
	case dataMsg:
		m.data = msg
		m.loading = false
		m.lastUpd = time.Now()
	case dailyDataMsg:
		m.dailyData = msg
		m.loading = false
		m.lastUpd = time.Now()
	}
	return m, nil
}

// --- Formatting ---

func fmtInt(v int64) string {
	if v == 0 {
		return "0"
	}
	s := fmt.Sprintf("%d", v)
	if v < 0 {
		return s
	}
	// Add thousand separators
	n := len(s)
	if n <= 3 {
		return s
	}
	var b strings.Builder
	pre := n % 3
	if pre > 0 {
		b.WriteString(s[:pre])
		if pre < n {
			b.WriteByte(',')
		}
	}
	for i := pre; i < n; i += 3 {
		if i > pre {
			b.WriteByte(',')
		}
		b.WriteString(s[i : i+3])
	}
	return b.String()
}

func fmtCost(v float64) string {
	return fmt.Sprintf("$%.2f", v)
}

func fmtValue(cost float64, output int64) string {
	if output <= 0 || cost <= 0 {
		return "—"
	}
	perMil := cost / (float64(output) / 1_000_000.0)
	return fmt.Sprintf("$%.2f", perMil)
}

// --- View ---

var (
	titleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#FAFAFA")).
			Background(lipgloss.Color("#7D56F4")).
			Padding(0, 1)

	subtitleStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#999999")).
			Italic(true)

	agentStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#7D56F4"))

	modelStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#888888"))

	totalStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#04B575"))

	helpStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#626262"))
)

func (m model) View() string {
	switch m.view {
	case viewDaily:
		return m.viewDaily()
	default:
		return m.viewToday()
	}
}

func (m model) viewToday() string {
	var b strings.Builder

	b.WriteString(titleStyle.Render("Agent Usage — Today"))
	b.WriteString("  ")
	if m.loading {
		b.WriteString(subtitleStyle.Render("⟳ loading..."))
	} else {
		b.WriteString(subtitleStyle.Render(fmt.Sprintf("Updated %s", m.lastUpd.Format("15:04:05"))))
	}
	b.WriteString("\n\n")

	if m.data == nil {
		b.WriteString("  Fetching data...\n")
		b.WriteString("\n" + helpStyle.Render("  q quit • r refresh • d daily view"))
		return b.String()
	}

	headers := []string{"Agent / Model", "Input", "Output", "Cache Rd", "Cache Wr", "Total Tok", "Cost", "$/1M out"}
	var rows [][]string

	var grandTotal Usage

	for _, agentName := range agentOrder {
		ad, ok := m.data[agentName]
		if !ok {
			ad = newAgentData()
		}

		rows = append(rows, []string{
			agentStyle.Render(agentName),
			agentStyle.Render(fmtInt(ad.Total.Input)),
			agentStyle.Render(fmtInt(ad.Total.Output)),
			agentStyle.Render(fmtInt(ad.Total.CacheRead)),
			agentStyle.Render(fmtInt(ad.Total.CacheWrite)),
			agentStyle.Render(fmtInt(ad.Total.Total)),
			agentStyle.Render(fmtCost(ad.Total.Cost)),
			agentStyle.Render(fmtValue(ad.Total.Cost, ad.Total.Output)),
		})

		modelNames := make([]string, 0, len(ad.Models))
		for mn := range ad.Models {
			modelNames = append(modelNames, mn)
		}
		sort.Strings(modelNames)

		for i, mn := range modelNames {
			prefix := "├─ "
			if i == len(modelNames)-1 {
				prefix = "└─ "
			}
			mu := ad.Models[mn]
			rows = append(rows, []string{
				modelStyle.Render(prefix + mn),
				modelStyle.Render(fmtInt(mu.Input)),
				modelStyle.Render(fmtInt(mu.Output)),
				modelStyle.Render(fmtInt(mu.CacheRead)),
				modelStyle.Render(fmtInt(mu.CacheWrite)),
				modelStyle.Render(fmtInt(mu.Total)),
				modelStyle.Render(fmtCost(mu.Cost)),
				modelStyle.Render(fmtValue(mu.Cost, mu.Output)),
			})
		}

		grandTotal.Add(ad.Total)
	}

	rows = append(rows, []string{
		totalStyle.Render("GRAND TOTAL"),
		totalStyle.Render(fmtInt(grandTotal.Input)),
		totalStyle.Render(fmtInt(grandTotal.Output)),
		totalStyle.Render(fmtInt(grandTotal.CacheRead)),
		totalStyle.Render(fmtInt(grandTotal.CacheWrite)),
		totalStyle.Render(fmtInt(grandTotal.Total)),
		totalStyle.Render(fmtCost(grandTotal.Cost)),
		totalStyle.Render(fmtValue(grandTotal.Cost, grandTotal.Output)),
	})

	t := table.New().
		Border(lipgloss.NormalBorder()).
		BorderStyle(lipgloss.NewStyle().Foreground(lipgloss.Color("#555555"))).
		Headers(headers...).
		Rows(rows...).
		StyleFunc(func(row, col int) lipgloss.Style {
			s := lipgloss.NewStyle().PaddingLeft(1).PaddingRight(1)
			if col == 0 {
				s = s.Width(30)
			}
			if col > 0 {
				s = s.Align(lipgloss.Right).Width(14)
			}
			return s
		})

	b.WriteString(t.Render())
	b.WriteString("\n\n")
	b.WriteString(helpStyle.Render("  q quit • r refresh • d daily view • auto-refreshes every 60s"))
	b.WriteString("\n")

	return b.String()
}

func (m model) viewDaily() string {
	var b strings.Builder

	b.WriteString(titleStyle.Render("Agent Usage — Daily"))
	b.WriteString("  ")
	if m.loading {
		b.WriteString(subtitleStyle.Render("⟳ loading..."))
	} else {
		b.WriteString(subtitleStyle.Render(fmt.Sprintf("Updated %s", m.lastUpd.Format("15:04:05"))))
	}
	b.WriteString("\n\n")

	if m.dailyData == nil {
		b.WriteString("  Fetching daily data...\n")
		b.WriteString("\n" + helpStyle.Render("  q quit • d today view"))
		return b.String()
	}

	headers := []string{"Date"}
	for _, a := range agentOrder {
		headers = append(headers, a)
	}
	headers = append(headers, "Total")

	var rows [][]string
	var cumTotal float64

	for _, dr := range m.dailyData {
		row := []string{dr.Date}
		for _, a := range agentOrder {
			c := dr.Agents[a]
			if c < 0.005 {
				row = append(row, modelStyle.Render("—"))
			} else {
				row = append(row, fmtCost(c))
			}
		}
		row = append(row, totalStyle.Render(fmtCost(dr.Total)))
		rows = append(rows, row)
		cumTotal += dr.Total
	}

	// Grand total row
	grandRow := []string{totalStyle.Render("TOTAL")}
	agentTotals := make(map[string]float64)
	for _, dr := range m.dailyData {
		for _, a := range agentOrder {
			agentTotals[a] += dr.Agents[a]
		}
	}
	for _, a := range agentOrder {
		grandRow = append(grandRow, totalStyle.Render(fmtCost(agentTotals[a])))
	}
	grandRow = append(grandRow, totalStyle.Render(fmtCost(cumTotal)))
	rows = append(rows, grandRow)

	t := table.New().
		Border(lipgloss.NormalBorder()).
		BorderStyle(lipgloss.NewStyle().Foreground(lipgloss.Color("#555555"))).
		Headers(headers...).
		Rows(rows...).
		StyleFunc(func(row, col int) lipgloss.Style {
			s := lipgloss.NewStyle().PaddingLeft(1).PaddingRight(1)
			if col == 0 {
				s = s.Width(12)
			}
			if col > 0 {
				s = s.Align(lipgloss.Right).Width(12)
			}
			return s
		})

	b.WriteString(t.Render())
	b.WriteString("\n\n")
	b.WriteString(helpStyle.Render("  q quit • r refresh • d today view"))
	b.WriteString("\n")

	return b.String()
}

// --- Main ---

func main() {
	if len(os.Args) > 1 && os.Args[1] == "--cost" {
		pricing := NewPricingResolver()
		data := CollectAll(pricing)
		var total float64
		for _, ad := range data {
			total += ad.Total.Cost
		}
		fmt.Printf("$%.2f\n", total)
		return
	}

	pricing := NewPricingResolver()

	p := tea.NewProgram(
		initialModel(pricing),
		tea.WithAltScreen(),
	)
	if _, err := p.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
