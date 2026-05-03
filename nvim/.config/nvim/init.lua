-- Set up runtime paths
vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
vim.opt.runtimepath:append("~/.local/share/nvim/lsp_servers/latex")
vim.opt.packpath = vim.opt.runtimepath:get()

-- Set leader key before loading plugins
vim.g.mapleader = ","
vim.g.maplocalleader = " "

local python3_host_prog = vim.env.NVIM_PYTHON3_HOST_PROG
if not python3_host_prog or python3_host_prog == "" then
  python3_host_prog = vim.fn.stdpath("data") .. "/python3-host/bin/python"
end

if vim.fn.executable(python3_host_prog) == 1 then
  vim.g.python3_host_prog = python3_host_prog
end

-- Source existing .vimrc for non-plugin settings
vim.cmd("source ~/.vimrc")

-- Bootstrap and configure lazy.nvim
require("config.lazy")

-- Load existing Lua configuration
require("lua-init")
