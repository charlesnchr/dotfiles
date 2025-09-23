-- Set up runtime paths
vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
vim.opt.runtimepath:append("~/.local/share/nvim/lsp_servers/latex")
vim.opt.packpath = vim.opt.runtimepath:get()

-- Set leader key before loading plugins
vim.g.mapleader = ","
vim.g.maplocalleader = " "

-- Source existing .vimrc for non-plugin settings
vim.cmd("source ~/.vimrc")

-- Bootstrap and configure lazy.nvim
require("config.lazy")

-- Load existing Lua configuration
require("lua-init")