local api = vim.api
local lsp = vim.lsp

vim.notify = require("notify")

-- pylsp
--

local config = {
  settings = {
    pylsp = {
      plugins = {
        pylint = { enabled = true, executable = "/home/cc/anaconda3/bin/pylint" },
        pyflakes = { enabled = true },
        flake8 = { enabled = true },
        pycodestyle = { enabled = false },
        jedi_completion = { fuzzy = true },
        pyls_isort = { enabled = true },
        pylsp_mypy = { enabled = true },
        yapf = { enabled = true },
      },
    },
  },
}

return {
	config = function(_)

        return config end,
}
