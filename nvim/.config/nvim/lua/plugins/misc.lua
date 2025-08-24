-- Miscellaneous utility plugins
return {
  -- File managers
  {
  },

  -- Ranger in floaterm
  {
    "charlesnchr/ranger-floaterm.vim",
    dependencies = { "voldikss/vim-floaterm" },
    keys = {
      { "<leader>f", "<cmd>RangerFloaterm<CR>", desc = "Ranger in floaterm" },
    },
  },

  {
    "ptzz/lf.vim",
    cond = vim.fn.has("win32") == 1,
    cmd = "Lf",
  },

  -- V for Vim file manager integration
  {
    "rupa/v",
    cmd = "V",
  },

  -- Directory diff
  {
    "will133/vim-dirdiff",
    cmd = "DirDiff",
  },

  -- Autojump integration
  {
    "trotter/autojump.vim",
    cmd = "J",
  },

  -- Plenary (required by many plugins)
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- File navigation and opening
  {
    "knsh14/vim-github-link",
    keys = {
      { "<localleader>go", ":execute ':silent !cursor --goto ' . expand('%') . ':' . line('.')<CR>", desc = "Open in Cursor" },
    },
  },

  -- Color commands
  {
    "chrisbra/recover.vim",
    event = "VeryLazy",
  },

  -- Custom color command
  {
    name = "custom-commands",
    dir = vim.fn.stdpath("config"),
    config = function()
      vim.api.nvim_create_user_command("Colo", function()
        vim.fn.system("zsh -c 'source $HOME/.zshrc; colo'")
      end, { desc = "Change color scheme" })
    end,
  },
}
