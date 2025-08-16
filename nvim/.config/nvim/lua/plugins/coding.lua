-- Coding and language-specific plugins
return {
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },

  -- Python support
  {
    "python-mode/python-mode",
    ft = "python",
    config = function()
      vim.g.pymode_lint_on_write = 0
    end,
  },

  -- Python text objects
  {
    "jeetsukumaran/vim-pythonsense",
    ft = "python",
  },

  -- REPL support
  {
    "sillybun/vim-repl",
    ft = { "python", "lua", "javascript" },
    config = function()
      vim.g.repl_program = {
        python = { "ipython" },
        default = { "bash" },
      }
    end,
  },

  -- Slime for REPL integration
  {
    "jpalardy/vim-slime",
    ft = "python",
    keys = {
      { "<leader>s", "<Plug>SlimeSendCell", desc = "Send cell" },
      { "<c-c>v", "<Plug>SlimeConfig", desc = "Slime config" },
      { "<localleader>r", "<cmd>SlimeSend1 %run test.py<CR>", desc = "Run test.py" },
    },
    config = function()
      vim.g.slime_target = "tmux"
      vim.g.slime_bracketed_paste = 1
      vim.g.slime_cell_delimiter = "# %%"
      vim.g.slime_default_config = {
        socket_name = vim.split(vim.env.TMUX or "", ",")[1],
        target_pane = ":.1",
      }
      vim.g.slime_dont_ask_default = 1
    end,
  },

  -- IPython cell support
  {
    "hanschen/vim-ipython-cell",
    ft = "python",
    keys = {
      { "<F6>", "<cmd>IPythonCellExecuteCellVerboseJump<CR>", desc = "Execute cell", mode = { "n", "i" } },
      { "[g", "<cmd>IPythonCellPrevCell<CR>", desc = "Previous cell" },
      { "]g", "<cmd>IPythonCellNextCell<CR>", desc = "Next cell" },
      { "<F9>", "<cmd>IPythonCellInsertAbove<CR>a", desc = "Insert above" },
      { "<F10>", "<cmd>IPythonCellInsertBelow<CR>a", desc = "Insert below" },
      { "<F9>", "<cmd>IPythonCellInsertAbove<CR>", mode = "i", desc = "Insert above" },
      { "<F10>", "<cmd>IPythonCellInsertBelow<CR>", mode = "i", desc = "Insert below" },
    },
  },

  -- LaTeX support
  {
    "lervag/vimtex",
    ft = { "tex", "latex" },
    config = function()
      if vim.fn.has("mac") == 1 then
        vim.g.vimtex_view_method = "skim"
      elseif vim.fn.has("unix") == 1 then
        vim.g.latex_view_general_viewer = "zathura"
        vim.g.vimtex_view_method = "zathura"
      end
      vim.g.vimtex_syntax_conceal_disable = 1
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_quickfix_mode = 0
    end,
    keys = {
      { "<localleader>l1", "<cmd>VimtexCountWords<cr>", desc = "Count words" },
      { "<localleader>l2", "<cmd>call WC()<cr>", desc = "Word count" },
    },
  },

  -- LaTeX text objects
  {
    "kana/vim-textobj-user",
    dependencies = { "rbonvall/vim-textobj-latex" },
    ft = { "tex", "latex" },
  },

  {
    "rbonvall/vim-textobj-latex",
    ft = { "tex", "latex" },
  },

  -- Markdown support
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = { "markdown" },
  },

  -- Pandoc support
  {
    "vim-pandoc/vim-pandoc",
    ft = { "markdown", "pandoc" },
  },

  {
    "vim-pandoc/vim-pandoc-syntax",
    ft = { "markdown", "pandoc" },
  },

  -- Tabular for alignment
  {
    "godlygeek/tabular",
    cmd = "Tabularize",
  },

  -- Tags and navigation
  {
    "ludovicchabant/vim-gutentags",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- vim.g.gutentags_trace = 1  -- Enable debugging (disabled)
      vim.g.gutentags_define_advanced_commands = 1
      vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/vim/ctags/")
      vim.g.gutentags_generate_on_new = 1
      vim.g.gutentags_generate_on_missing = 1
      vim.g.gutentags_generate_on_write = 1
      vim.g.gutentags_generate_on_empty_buffer = 0
      
      -- Extensive exclude list from original config
      vim.g.gutentags_ctags_exclude = {
        "*.git", "*.svg", "*.hg", ".next", "*/tests/*", "build", "dist",
        "*sites/*/files/*", "bin", "node_modules", ".venv", "bower_components",
        "cache", "compiled", "docs", "example", "bundle", "vendor", "wandb",
        "*.md", "*-lock.json", "*.lock", "*bundle*.js", "*build*.js", ".*rc*",
        "*.json", "*.min.*", "*.map", "*.bak", "*.zip", "*.pyc", "*.class",
        "*.sln", "*.Master", "*.csproj", "*.tmp", "*.csproj.user", "*.cache",
        "*.pdb", "tags*", "cscope.*", "*.css", "*.less", "*.scss", "*.exe",
        "*.dll", "*.mp3", "*.ogg", "*.flac", "*.swp", "*.swo", "*.bmp",
        "*.gif", "*.ico", "*.jpg", "*.png", "*.rar", "*.zip", "*.tar",
        "*.tar.gz", "*.tar.xz", "*.tar.bz2", "*.pdf", "*.doc", "*.docx",
        "*.ppt", "*.pptx",
      }
      
      vim.g.gutentags_ctags_extra_args = {
        "--tag-relative=yes",
        "--fields=+ailmnS",
        "--langmap=TypeScript:+.tsx -R",
      }
    end,
  },

  -- Operator framework
  {
    "kana/vim-operator-user",
    lazy = true,
  },

  -- Distant.nvim for remote editing
  {
    "chipsenkbeil/distant.nvim",
    branch = "v0.3",
    cmd = { "Distant", "DistantOpen", "DistantConnect" },
  },

  -- GitHub Copilot (disabled in favor of Supermaven)
  {
    "github/copilot.vim",
    event = "InsertEnter",
    enabled = false,
  },

  -- Supermaven AI completion
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-l>",
        },
        ignore_filetypes = { "cpp", "c" }, -- Adjust as needed
        color = {
          suggestion_color = "#ffffff",
          cterm = 244,
        },
        log_level = "info", -- set to "off" to disable logging completely
        disable_inline_completion = false, -- disables inline completion for use with cmp
        disable_keymaps = false, -- disables built in keymaps for more manual control
      })
      
      -- Add additional C-f mapping for accept suggestion
      vim.keymap.set("i", "<C-f>", function()
        require("supermaven-nvim.completion_preview").on_accept_suggestion()
      end, { desc = "Accept Supermaven suggestion" })
    end,
  },

  -- Claude Code integration
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-,>", desc = "Claude Code" },
      { "<leader>cC", desc = "Claude Code continue" },
      { "<leader>cV", desc = "Claude Code verbose" },
    },
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  -- ALE for additional linting (disabled in config)
  {
    "dense-analysis/ale",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.g.ale_fixers = {
        javascript = { "prettier" },
        css = { "prettier" },
        tex = { "prettier" },
      }
      vim.g.ale_linters = {
        python = { "" },
      }
    end,
    enabled = false, -- Disabled in original config
  },
}
