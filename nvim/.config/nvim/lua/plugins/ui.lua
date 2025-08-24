-- UI and visual enhancement plugins
return {
  -- Colorschemes
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      -- Will be configured by auto-dark-mode plugin in lua-init
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
  },

  {
    "joshdick/onedark.vim",
    priority = 1000,
  },

  {
    "drewtempelmeyer/palenight.vim",
    priority = 1000,
  },

  {
    "arcticicestudio/nord-vim",
    priority = 1000,
  },

  {
    "rafi/awesome-vim-colorschemes",
    priority = 1000,
  },

  -- Colorscheme switcher
  {
    "xolox/vim-colorscheme-switcher",
    dependencies = { "xolox/vim-misc" },
    keys = {
      { "<leader><F8>", "<cmd>PrevColorScheme<CR>", desc = "Previous colorscheme" },
    },
  },

  -- Auto dark mode for macOS
  {
    "charlesnchr/auto-dark-mode.nvim",
    priority = 1000,
    cond = vim.fn.has("mac") == 1,
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>n", "<cmd>NvimTreeFindFile<CR>", desc = "Find file in tree" },
    },
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  -- Web devicons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Vim devicons (for compatibility)
  {
    "ryanoasis/vim-devicons",
    event = "VeryLazy",
  },

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    cmd = "Telescope",
    keys = {
      -- File pickers
      { "<localleader>ff", "<cmd>Files<cr>", desc = "Files" },
      { "<localleader>fg", "<cmd>GitFiles<cr>", desc = "Git files" },
      { "<localleader>ft", "<cmd>Tags<cr>", desc = "Tags" },
      { "<localleader>fv", "<cmd>Buffers<cr>", desc = "Buffers" },
      { "<localleader>fc", "<cmd>Commands<cr>", desc = "Commands" },
      { "<localleader>fb", "<cmd>Buffers<cr>", desc = "Buffers" },
      { "<localleader>fm", "<cmd>Marks<cr>", desc = "Marks" },
      { "<localleader>fh", "<cmd>History<cr>", desc = "History" },
      { "<localleader>fw", "<cmd>Windows<cr>", desc = "Windows" },
      
      -- Telescope specific
      { "<localleader>js", function() require('telescope.builtin').git_files({
        previewer = false,
        layout_strategy = "center",
        layout_config = { 
          height = 20,
          width = 80,
          prompt_position = "bottom",
          anchor = "SW"
        }
      }) end, desc = "Git files" },
      { "<localleader>s", function() require('telescope.builtin').git_files() end, desc = "Git files" },
      { "<localleader>jf", function() require('telescope.builtin').find_files() end, desc = "Find files" },
      { "<localleader>jg", function() require('telescope.builtin').live_grep() end, desc = "Live grep" },
      { "<localleader>jr", function() require('telescope.builtin').grep_string{ search = '' } end, desc = "Grep string" },
      { "<localleader>jc", function() require('telescope.builtin').grep_string{ shorten_path = true, word_match = "-w", only_sort_text = true, search = '' } end, desc = "Grep string clean" },
      { "<localleader>j.", function() require('telescope.builtin').grep_string{ vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '-.' }, shorten_path = true, word_match = "-w", only_sort_text = true, search = '' } end, desc = "Grep with hidden" },
      { "<localleader>jb", function() require('telescope.builtin').buffers({sort_mru = true}) end, desc = "Buffers" },
      { "<localleader>e", function() require('telescope.builtin').buffers({
        sort_mru = true,
        previewer = false,
        layout_strategy = "center",
        layout_config = { 
          height = 20,
          width = 80,
          prompt_position = "bottom",
          anchor = "SW"
        }
      }) end, desc = "Buffers" },
      { "<localleader><tab>", function() require('telescope.builtin').buffers({sort_mru = true}) end, desc = "Buffers" },
      { "<localleader>jh", function() require('telescope.builtin').help_tags() end, desc = "Help tags" },
      { "<localleader>jk", function() require('telescope.builtin').keymaps() end, desc = "Keymaps" },
      { "<localleader>jo", function() require('telescope.builtin').oldfiles({include_current_session=true}) end, desc = "Old files" },
      { "<localleader>jd", function() require('telescope.builtin').oldfiles({include_current_session=true,cwd_only=true}) end, desc = "Old files (cwd)" },
      { "<localleader>ja", function() require('telescope.builtin').current_buffer_tags() end, desc = "Buffer tags" },
      { "<localleader>jz", function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = "Buffer fuzzy find" },
      { "<localleader>jt", function() M.tags() end, desc = "Tags" },
      { "<localleader>t", function() M.tags() end, desc = "Tags" },
      { "<localleader>jx", function() require('telescope.builtin').treesitter() end, desc = "Treesitter" },
      { "<localleader>jl", function() require('telescope.builtin').lsp_document_symbols() end, desc = "LSP symbols" },
      { "<localleader>je", function() require("telescope").extensions.aerial.aerial() end, desc = "Aerial" },
      { "<localleader>ji", function() require('telescope.builtin').commands() end, desc = "Commands" },
      { "<localleader>jn", function() require('telescope.builtin').command_history() end, desc = "Command history" },
      { "<localleader>jv", function() require('telescope.builtin').git_branches() end, desc = "Git branches" },
      { "<localleader>p", function() require("telescope").extensions.aerial.aerial() end, desc = "Aerial" },
      { "<C-p>", function() require('telescope.builtin').buffers({
        sort_mru = true, 
        default_selection_index = 2,
        previewer = false,
        layout_strategy = "center",
        layout_config = { 
          height = 20,
          width = 80,
          prompt_position = "bottom",
          anchor = "SW"
        }
      }) end, desc = "Buffers" },
    },
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  -- FZF for Vim compatibility
  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
  },

  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    keys = {
      { "<localleader>/", "<cmd>Rg<cr>", desc = "Rg search" },
      { "<localleader>fa", "<cmd>RgWiki<Cr>", desc = "Search wiki" },
      { "<localleader>fs", "<cmd>RgThesis<Cr>", desc = "Search thesis" },
    },
    config = function()
      -- Custom RgWiki command
      vim.cmd([[
        command! -bang -nargs=* RgWiki
                    \ call fzf#vim#grep("rg -g '*.{wiki,md}' --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir':'~/0main/Syncthing/wiki'}), <bang>0)
      ]])
      
      -- Custom RgThesis command
      vim.cmd([[
        command! -bang -nargs=* RgThesis
                    \ call fzf#vim#grep("rg -g '*.{tex}' --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir':'~/1private/Github/phd-thesis'}), <bang>0)
      ]])
    end,
  },

  -- Vim agriculture for better rg
  {
    "jesseleite/vim-agriculture",
    dependencies = { "junegunn/fzf.vim" },
    keys = {
      { "<localleader>.", "<cmd>RgRaw -. ''<cr>", desc = "Rg raw with hidden" },
    },
  },

  -- Startify start screen
  {
    "mhinz/vim-startify",
    event = "VimEnter",
    config = function()
      vim.g.startify_files_number = 10
      vim.g.startify_bookmarks = {
        { p = "~/0main/0phd" },
        { c = "~/0main/0phd/ccRestore" },
        { g = "~/GitHub" },
        "~/0main",
      }
      vim.g.startify_change_to_dir = 0
      
      -- Custom lists function will be defined in .vimrc
    end,
    keys = {
      { "<localleader>0", "<cmd>Startify<cr>", desc = "Startify" },
    },
  },

  -- Tagbar for code structure
  {
    "preservim/tagbar",
    cmd = { "TagbarToggle", "TagbarOpenAutoClose" },
    keys = {
      { "<F2>", "<cmd>TagbarOpenAutoClose<CR>", desc = "Tagbar" },
      { "<leader>ga", "<cmd>TagbarToggle<CR>", desc = "Tagbar toggle" },
      { "<leader>a", "<cmd>TagbarOpenAutoClose<CR>", desc = "Tagbar" },
    },
    config = function()
      vim.g.tagbar_sort = 0
      vim.g.tagbar_width = 60
      
      -- TypeScript and React tagbar configs will be set in .vimrc
    end,
  },

  -- Vista for LSP symbols
  {
    "liuchengxu/vista.vim",
    cmd = "Vista",
  },

  -- Aerial for LSP symbols
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>AerialToggle<CR>", desc = "Aerial toggle" },
    },
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  -- Symbols outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
  },

  -- Floating terminal
  {
    "voldikss/vim-floaterm",
    keys = {
      { "<leader><F12>", "<cmd>FloatermNew<CR>", desc = "New floaterm" },
      { "<leader><F12>", "<cmd>FloatermNew<CR>", mode = "t", desc = "New floaterm" },
      { "<F10>", "<cmd>FloatermPrev<CR>", desc = "Previous floaterm" },
      { "<F10>", "<cmd>FloatermPrev<CR>", mode = "t", desc = "Previous floaterm" },
      { "<F11>", "<cmd>FloatermNext<CR>", desc = "Next floaterm" },
      { "<F11>", "<cmd>FloatermNext<CR>", mode = "t", desc = "Next floaterm" },
      { "<F12>", "<cmd>FloatermToggle<CR>", desc = "Toggle floaterm" },
      { "<F12>", "<cmd>FloatermToggle<CR>", mode = "t", desc = "Toggle floaterm" },
    },
    config = function()
      vim.g.floaterm_width = 0.8
      vim.g.floaterm_height = 0.8
    end,
  },

  -- Toggle terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<F4>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
      { "<F4>", "<cmd>ToggleTerm<CR>", mode = "t", desc = "Toggle terminal" },
      { "<F4>", "<cmd>ToggleTerm<CR>", mode = "i", desc = "Toggle terminal" },
      { "<F4>", "<cmd>ToggleTerm<CR>", mode = "v", desc = "Toggle terminal" },
    },
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  -- Wilder for better command line
  {
    "gelguy/wilder.nvim",
    build = ":UpdateRemotePlugins",
    event = "CmdlineEnter",
  },

  -- Which-key for keybinding help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      { "<localleader>h", "<cmd>WhichKey<CR>", desc = "Which Key" },
    },
  },

  -- Notification manager
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  -- NUI for better UI components
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },

  -- Color picker
  {
    "ziontee113/color-picker.nvim",
    keys = {
      { "<C-c>", "<cmd>PickColorInsert<cr>", mode = "i", desc = "Pick color" },
    },
    config = function()
      -- Configuration will be loaded from lua-init.lua
    end,
  },

  -- Goyo for distraction-free writing
  {
    "junegunn/goyo.vim",
    cmd = "Goyo",
    config = function()
      vim.g.goyo_width = 85
    end,
  },

  -- Calendar
  {
    "mattn/calendar-vim",
    cmd = "Calendar",
  },
}
