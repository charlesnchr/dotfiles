-- Writing and documentation plugins
return {
  -- VimWiki for personal wiki
  {
    "vimwiki/vimwiki",
    ft = "vimwiki",
    keys = {
      { "<leader>tl", "<cmd>VimwikiToggleListItem<cr>", desc = "Toggle list item" },
      { "<C-h>", "<Plug>VimwikiDiaryPrevDay<CR>", ft = "vimwiki", desc = "Previous day" },
      { "<C-l>", "<Plug>VimwikiDiaryNextDay<CR>", ft = "vimwiki", desc = "Next day" },
    },
    config = function()
      vim.g.vimwiki_list = {
        {
          path = "$HOME/0main/vimwiki",
          syntax = "markdown",
          template_path = "$HOME/0main/vimwiki/templates",
          template_default = "default",
          template_ext = ".html",
        },
      }
      vim.g.vimwiki_ext2syntax = {
        [".wiki"] = "markdown",
      }
      vim.g.vimwiki_global_ext = 0
      
      -- Auto header for wiki diary entries
      vim.api.nvim_create_augroup("AutoWikiHeader", { clear = true })
      vim.api.nvim_create_autocmd("BufNewFile", {
        group = "AutoWikiHeader",
        pattern = "*/diary/*.wiki",
        command = "execute \"so ~/dotfiles/headers/wiki_header.txt\" | execute \"silent! %s/%DATE%/\".escape(fnamemodify(bufname('%'), ':t:r'), '/')",
      })
    end,
  },

  -- Pencil for writing
  {
    "reedes/vim-pencil",
    ft = { "markdown", "text", "tex", "vimwiki" },
    config = function()
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.wiki",
        command = "SoftPencil",
      })
    end,
  },

  -- Advanced Git search for documentation
  {
    "aaronhallaert/advanced-git-search.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-fugitive",
      "tpope/vim-rhubarb",
    },
    cmd = "AdvancedGitSearch",
    config = function()
      -- Configuration will be loaded via telescope extension in lua-init.lua
    end,
  },

  -- Git log viewer
  {
    "junegunn/gv.vim",
    dependencies = { "tpope/vim-fugitive" },
    cmd = "GV",
  },

  -- GitHub integration
  {
    "tpope/vim-rhubarb",
    dependencies = { "tpope/vim-fugitive" },
    keys = {
      { "<localleader>gb", "<cmd>GBrowse!<CR>:echo @+<CR>", desc = "GitHub browse" },
    },
  },

  -- GitHub link generation
  {
    "knsh14/vim-github-link",
    keys = {
      { "<localleader>gh", "<cmd>GetCurrentBranchLink<CR><Bar> :OSCYankReg +<CR>:echo @+<CR>", mode = { "n", "v" }, desc = "GitHub link" },
    },
  },

  -- Gitsigns for Git integration in buffers
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    keys = {
      { "]h", function() require('gitsigns').nav_hunk('next') end, desc = "Next hunk" },
      { "[h", function() require('gitsigns').nav_hunk('prev') end, desc = "Prev hunk" },
      { "<leader>hs", function() require('gitsigns').stage_hunk() end, desc = "Stage hunk" },
      { "<leader>hr", function() require('gitsigns').reset_hunk() end, desc = "Reset hunk" },
      { "<leader>hp", function() require('gitsigns').preview_hunk() end, desc = "Preview hunk" },
      { "<leader>hb", function() require('gitsigns').blame_line({full = true}) end, desc = "Blame line" },
      { "<leader>tb", function() require('gitsigns').toggle_current_line_blame() end, desc = "Toggle blame" },
    },
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
        },
      }
    end,
  },

  -- Neogit for better Git interface
  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Neogit",
  },

  -- Merginal for Git branch management
  {
    "idanarye/vim-merginal",
    dependencies = { "tpope/vim-fugitive" },
    cmd = { "Merginal", "MerginalToggle" },
  },
}