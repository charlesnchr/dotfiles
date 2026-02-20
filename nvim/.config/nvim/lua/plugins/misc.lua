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

  -- Zoxide integration (Custom plugin)
  {
    "nanotee/zoxide.vim",
    cmd = { "Z", "Lz", "Tz", "Zi", "Lzi", "Tzi" },
    keys = {
      { "<leader>z", "<cmd>Zi<CR>", desc = "Zoxide Interactive" }
    },
    init = function()
      -- Must be set in `init` to ensure variables exist before plugin loads
      vim.g.zoxide_use_select = 1 -- Use native neovim select for Zi
      
      local zo_dir = vim.fn.expand("~/.zoxide.vim/global")
      vim.env._ZO_DATA_DIR = zo_dir
      
      local wrapper_path = vim.fn.expand("~/.local/share/nvim/zoxide_wrapper.sh")
      if vim.fn.filereadable(wrapper_path) == 0 then
        local file = io.open(wrapper_path, "w")
        if file then
          file:write("#!/bin/sh\n")
          file:write("export _ZO_DATA_DIR='" .. zo_dir .. "'\n")
          file:write("exec zoxide \"$@\"\n")
          file:close()
          vim.fn.system({"chmod", "+x", wrapper_path})
        end
      end
      vim.g.zoxide_executable = wrapper_path
    end,
    config = function()
      local wrapper_path = vim.fn.expand("~/.local/share/nvim/zoxide_wrapper.sh")
      local zo_dir = vim.fn.expand("~/.zoxide.vim/global")
      
      -- Ensure isolated directory exists
      if vim.fn.isdirectory(zo_dir) == 0 then
        vim.fn.mkdir(zo_dir, "p")
      end

      -- Autocmd to feed isolated Zoxide database
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
        callback = function()
          local file = vim.fn.expand("%:p")
          if file ~= "" and vim.fn.filereadable(file) == 1 then
            local dir = vim.fn.fnamemodify(file, ":h")
            vim.fn.system({wrapper_path, "add", dir})
          end
        end,
      })
    end,
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
