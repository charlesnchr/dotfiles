-- Coding and language-specific plugins
return {
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "lua", "rust", "python", "javascript", "typescript", "vim", "vimdoc", "query" },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        highlight = { enable = true },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
  },

  -- Python support
  {
    "python-mode/python-mode",
    ft = "python",
    config = function()
      local pymode_ruff = vim.fn.stdpath("data") .. "/pylsp-venv/bin/ruff"
      if vim.fn.executable(pymode_ruff) == 1 then
        vim.g.pymode_ruff_executable = pymode_ruff
      end
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
      { "<leader>ss", "<Plug>SlimeSendCell", desc = "Send cell" },
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
        target_pane = ":.2",
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
    build = "cd app && ./install.sh", -- prebuilt binary, no node/yarn
    ft = { "markdown" },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "vimwiki" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
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
      vim.g.gutentags_trace = 0  -- Enable debugging
      vim.g.gutentags_define_advanced_commands = 1
      local gutentags_cache_dir = vim.fn.stdpath("cache") .. "/ctags"
      vim.fn.mkdir(gutentags_cache_dir, "p")
      vim.g.gutentags_cache_dir = gutentags_cache_dir .. "/"

      -- Project root markers - include package.json for JS/TS projects
      vim.g.gutentags_project_root = { '.git', '.root', '.svn', '.hg', '.project', 'package.json', 'Cargo.toml', 'go.mod' }

      -- Essential tag generation settings
      vim.g.gutentags_generate_on_new = 1      -- Generate on new files
      vim.g.gutentags_generate_on_missing = 1  -- Auto-generate missing tags
      vim.g.gutentags_generate_on_write = 1    -- Generate on every write
      vim.g.gutentags_generate_on_empty_buffer = 0

      -- Use git ls-files for better performance in git repos
      -- This automatically excludes untracked data files and respects .gitignore
      vim.g.gutentags_file_list_command = {
        ['.git'] = 'git ls-files',
      }

      -- Comprehensive exclude list based on best practices
      vim.g.gutentags_ctags_exclude = {
        -- Version control and git
        ".git/*", "*.git", "*.hg", "*.svn",

        -- Package managers and dependencies (CRITICAL) - handles nested too
        "node_modules", "*/node_modules", "*/*/node_modules", "*/*/*/node_modules",
        "bower_components", "*/bower_components",
        ".venv", "*/.venv", "venv", "*/venv",
        "__pycache__", "*/__pycache__", "*/*/__pycache__",
        "vendor", "*/vendor", "deps", "*/deps",
        "target", "*/target", ".cargo", "*/.cargo",

        -- Build outputs and dist
        "build/*", "dist/*", ".next/*", "out/*", ".output/*", "_site/*",
        ".nuxt/*", ".cache/*", "cache/*", ".parcel-cache/*", ".webpack/*",

        -- Temporary and cache files
        "*.tmp", "*.cache", "*.swp", "*.swo", "*~", ".DS_Store",

        -- Lock files and configs
        "*-lock.json", "*.lock", "yarn.lock", "package-lock.json",
        ".*rc*", ".env*", ".gitignore",

        -- Minified and built assets
        "*.min.*", "*.map", "*bundle*.js", "*build*.js", "*.min.js", "*.min.css",

        -- Data files (CSV, Excel, NumPy, etc.)
        "*.csv", "*.tsv", "*.xlsx", "*.xls", "*.ods",
        "*.npy", "*.npz", "*.pkl", "*.pickle", "*.h5", "*.hdf5",
        "*.parquet", "*.feather", "*.mat", "*.rds", "*.rdata",
        "*.db", "*.sqlite", "*.sqlite3", "*.mdb", "*.json", "*.plist", ".vim",

        -- Binary files
        "*.exe", "*.dll", "*.so", "*.dylib", "*.class", "*.pyc", "*.pyo",
        "*.zip", "*.tar", "*.tar.gz", "*.tar.xz", "*.tar.bz2", "*.rar", "*.7z",

        -- Media files
        "*.mp3", "*.mp4", "*.avi", "*.mov", "*.wav", "*.ogg", "*.flac",
        "*.jpg", "*.jpeg", "*.png", "*.gif", "*.bmp", "*.ico", "*.svg", "*.webp",

        -- Documents
        "*.pdf", "*.doc", "*.docx", "*.ppt", "*.pptx", "*.xls", "*.xlsx",

        -- IDE and editor files
        ".vscode/*", ".idea/*", "*.sln", "*.csproj", "*.Master", "*.csproj.user",
        "tags*", "cscope.*", ".tags",

        -- Test and documentation directories
        "*/tests/*", "*/test/*", "docs/*", "documentation/*", "example/*", "examples/*",

        -- Other common excludes
        "bin/*", "tmp/*", "log/*", "logs/*", "*sites/*/files/*", "wandb/*",
      }

      vim.g.gutentags_ctags_extra_args = {
        "--tag-relative=yes",
        "--fields=+ailmnS",
        "--extra=+q",

        -- Language mappings for modern web development
        "--langmap=JavaScript:+.jsx",         -- JSX support
        "--langmap=TypeScript:+.tsx",         -- TSX support
        "--langmap=HTML:+.html.htm",          -- HTML support
        "--langmap=CSS:+.css.scss.sass.less", -- CSS and preprocessors

        -- Additional language support
        "--langmap=Python:+.py.pyx",
        "--langmap=Vim:+.vim.vimrc",
        "--langmap=Markdown:+.md.markdown",

        -- Universal ctags specific options
        "--kinds-JavaScript=+f,c,m,p,v",      -- Functions, classes, methods, properties, variables
        "--kinds-TypeScript=+f,c,m,p,v,i,e",  -- Include interfaces and enums
        "--kinds-HTML=+f,i",                  -- HTML functions and IDs
        "--kinds-CSS=+c,s,i",                 -- CSS classes, selectors, IDs
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

  {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      }
    }
  },
  keys = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Other
    { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
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
