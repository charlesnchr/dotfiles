-- Core editor enhancement plugins
return {
  -- Git integration
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiff", "Gvdiff", "Gblame", "Glog", "Gstatus", "Gpush", "Gpull" },
    keys = {
      { "<localleader>vg", "<cmd>G<cr>", desc = "Git status" },
      { "<localleader>gj", "<cmd>G<cr>", desc = "Git status" },
      { "<localleader>gc", "<cmd>G commit --verbose -m \"Small update\"<cr>", desc = "Git commit" },
      { "<localleader>gn", "<cmd>G log --name-status<cr>", desc = "Git log with names" },
      { "<localleader>gl", "<cmd>G pull<cr>", desc = "Git pull" },
      { "<localleader>gp", "<cmd>G push<cr>", desc = "Git push" },
      { "<localleader>gB", "<cmd>G branch --sort=-committerdate<cr>", desc = "Git branches (local)" },
      { "<localleader>gr", "<cmd>G branch -r --sort=-committerdate<cr>", desc = "Git branches (remote)" },
    },
  },

  -- Sensible defaults
  "tpope/vim-sensible",

  -- Surround operations
  {
    "tpope/vim-surround",
    keys = { "cs", "ds", "ys", { "S", mode = "v" } },
    config = function()
      -- Triple backtick for code blocks using vim-surround
      vim.cmd('let b:surround_{char2nr("e")} = "```\\r```"')
    end,
  },

  -- Comment operations
  {
    "tpope/vim-commentary",
    keys = { "gc", { "gc", mode = "v" } },
  },

  -- Unimpaired mappings
  {
    "tpope/vim-unimpaired",
    keys = { "]", "[" },
  },

  -- Visual multi-cursor
  {
    "mg979/vim-visual-multi",
    keys = { "<C-n>", "<C-Down>", "<C-Up>" },
  },

  -- Better whitespace handling
  {
    "ntpeters/vim-better-whitespace",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_whitespace_on_save = 0
    end,
    keys = {
      { "<leader><Space>", "<cmd>StripWhitespace<CR>", desc = "Strip whitespace" },
    },
  },

  -- Splitjoin - split and join code blocks
  {
    "AndrewRadev/splitjoin.vim",
    keys = { "gS", "gJ" },
  },


  -- Cool search highlighting
  "romainl/vim-cool",

  -- OSC yank for remote sessions
  {
    "ojroques/vim-oscyank",
    keys = {
      { "<leader>y", "<cmd>OSCYank<CR>", mode = "v", desc = "OSC Yank" },
    },
    config = function()
      -- Auto yank when copying to system clipboard
      if vim.fn.has("mac") == 1 then
        vim.api.nvim_create_autocmd("TextYankPost", {
          callback = function()
            if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
              vim.cmd("OSCYankRegister +")
            end
          end,
        })
      elseif vim.fn.has("unix") == 1 then
        vim.api.nvim_create_autocmd("TextYankPost", {
          callback = function()
            if vim.v.event.operator == "y" and vim.v.event.regname == "" then
              vim.cmd('OSCYankRegister "')
            end
          end,
        })
      end
    end,
  },

  -- Peek at registers
  {
    "junegunn/vim-peekaboo",
    event = "VeryLazy",
    config = function()
      vim.g.peekaboo_prefix = "<localleader>"
    end,
  },

  -- Undo tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<localleader>ut", "<cmd>UndotreeToggle<CR>", desc = "Toggle undotree" },
    },
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },

  -- Mundo (another undo tree)
  {
    "simnalamburt/vim-mundo",
    cmd = "MundoShow",
    keys = {
      { "<localleader>um", "<cmd>MundoShow<CR>", desc = "Show mundo" },
    },
  },

  -- Leap motion
  {
    "ggandor/leap.nvim",
    keys = { "s", "S" },
    config = function()
      require("leap").add_default_mappings()
      -- Highlight setup for colorschemes
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          require("leap").init_highlight(true)
        end,
      })
    end,
  },

  -- Live command preview
  {
    "smjonas/live-command.nvim",
    event = "CmdlineEnter",
    config = function()
      require("live-command").setup({
        commands = {
          Norm = { cmd = "norm" },
        },
      })
    end,
  },

  -- Auto-save
  {
    "Pocco81/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      execution_message = {
        message = function()
          return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
        end,
        dim = 0.18,
        cleaning_interval = 1250,
      },
      trigger_events = { "InsertLeave", "TextChanged" },
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")
        if fn.getbufvar(buf, "&modifiable") == 1 and not utils.not_in(fn.getbufvar(buf, "&filetype"), { "vimwiki" }) then
          return true
        end
        return false
      end,
      write_all_buffers = false,
      debounce_delay = 135,
    },
  },

  -- Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    keys = {
      { "<localleader>=", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
      { "<localleader>-", function() require("harpoon.mark").add_file() end, desc = "Harpoon add" },
      { "<A-1>", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon 1" },
      { "<A-2>", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon 2" },
      { "<A-3>", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon 3" },
      { "<A-4>", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon 4" },
      { "<A-5>", function() require("harpoon.ui").nav_file(5) end, desc = "Harpoon 5" },
      { "<A-6>", function() require("harpoon.ui").nav_file(6) end, desc = "Harpoon 6" },
      { "<A-7>", function() require("harpoon.ui").nav_file(7) end, desc = "Harpoon 7" },
      { "<A-8>", function() require("harpoon.ui").nav_file(8) end, desc = "Harpoon 8" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Cellular automaton for fun
  {
    "Eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    keys = {
      { "<localleader>mr", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "Make it rain" },
    },
  },

  -- Recover.vim for crash recovery
  {
    "chrisbra/recover.vim",
    event = "VeryLazy",
  },

  -- Vim startup time profiler
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },
}