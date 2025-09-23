-- LSP and completion plugins
return {
  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-omni",
    },
    event = "InsertEnter",
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  -- CMP sources
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  { "hrsh7th/cmp-buffer", lazy = true },
  { "hrsh7th/cmp-path", lazy = true },
  { "hrsh7th/cmp-cmdline", lazy = true },
  { "hrsh7th/cmp-omni", lazy = true },

  -- Trouble for diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Trouble toggle" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix" },
      { "<leader>xr", "<cmd>TroubleRefresh<cr>", desc = "Trouble refresh" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location list" },
      { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "LSP references" },
    },
  },

  -- LSPSaga for better LSP UI
  {
    "glepnir/lspsaga.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "LspAttach",
    keys = {
      { "<localleader>]", "<cmd>Lspsaga goto_definition<CR>", desc = "Go to definition" },
      { "<leader>]", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek definition" },
    },
    config = function()
      -- Configuration commented out in original config
    end,
  },

  -- Fidget for LSP progress
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    config = function()
      -- Configuration commented out in original config
    end,
  },

  -- Snippets (removed - not used)
  -- UltiSnips, vim-snippets, and friendly-snippets removed

  -- Formatting
  {
    "sbdchd/neoformat",
    cmd = "Neoformat",
    keys = {
      { "<localleader>n", "<cmd>Neoformat<CR>", desc = "Neoformat" },
    },
    config = function()
      vim.g.neoformat_enabled_javascriptreact = { "prettier" }
      vim.g.neoformat_enabled_typescriptreact = { "prettier" }
      vim.g.neoformat_enabled_typescript = { "prettier" }
      vim.g.neoformat_enabled_javascript = { "prettier" }
      vim.g.neoformat_enabled_python = { "ruff" }
    end,
  },
}