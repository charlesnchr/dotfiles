local api = vim.api
local lsp = vim.lsp

local M = {}

function M.show_line_diagnostics()
  local opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = 'none',
    source = 'always',  -- show source in diagnostic popup window
    prefix = ' '
  }
  vim.diagnostic.open_float(nil, opts)
end

local custom_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Mappings.
  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "<C-]>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "<leader>sh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>d", "<cmd>lua require('config.lsp').show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setqflist({open = true})<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "<space>d", "<cmd>lua vim.diagnostic.open_float(0, { scope = 'line', border = 'none' })<CR>", opts)

  vim.cmd([[
    autocmd CursorHold <buffer> lua require('config.lsp').show_line_diagnostics()
  ]])

  -- Set some key bindings conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("x", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR><ESC>", opts)
  end

  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.resolved_capabilities.document_highlight then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end

  if vim.g.logging_level == 'debug' then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, 'info', {title = 'Nvim-config'})
  end
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")

lspconfig.pylsp.setup({
  on_attach = custom_attach,
  settings = {
    pylsp = {
      plugins = {
        pylint = { enabled = true, executable = "pylint" },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = true },
        jedi_completion = { fuzzy = true },
        pyls_isort = { enabled = true },
        pylsp_mypy = { enabled = false },
      },
    },
  },
  flags = {
    debounce_text_changes = 200,
  },
  capabilities = capabilities,
})

-- lspconfig.pyright.setup{
--   on_attach = custom_attach,
--   capabilities = capabilities
-- }
--

local tabnine = require("cmp_tabnine.config")
tabnine:setup({
	max_lines = 1000,
	max_num_results = 20,
	sort = true,
	run_on_every_keystroke = true,
	snippet_placeholder = "..",
})

--lspconfig.ltex.setup{}

lspconfig.clangd.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  filetypes = { "c", "cpp", "cc" },
  flags = {
    debounce_text_changes = 500,
  },
})

-- set up vim-language-server
lspconfig.vimls.setup({
  on_attach = custom_attach,
  flags = {
    debounce_text_changes = 500,
  },
  capabilities = capabilities,
})

local sumneko_binary_path = vim.fn.exepath("lua-language-server")
if vim.g.is_mac or vim.g.is_linux and sumneko_binary_path ~= "" then
  local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ":h:h:h")

  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  require("lspconfig").sumneko_lua.setup({
    on_attach = custom_attach,
    cmd = { sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua" },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
    capabilities = capabilities,
  })
end

-- Change diagnostic signs.
vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- global config for diagnostic
vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  signs = true,
  severity_sort = true,
})

-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--   underline = false,
--   virtual_text = false,
--   signs = true,
--   update_in_insert = false,
-- })

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})





-- Combine base config for each server and merge user-defined settings.
local function make_config(server_name)
	-- Setup base config for each server.
	local c = {}
	c.on_attach = on_attach
	c.capabilities = vim.lsp.protocol.make_client_capabilities()
	c.capabilities = require('cmp_nvim_lsp').update_capabilities(c.capabilities)
	c.flags = {
		debounce_text_changes = 150,
	}

	-- cmp_nvim_lsp enables following options:
	--   completionItem = {
	--     commitCharactersSupport = true,
	--     deprecatedSupport = true,
	--     documentationFormat = { "markdown", "plaintext" },

	--     insertReplaceSupport = true,
	--     labelDetailsSupport = true,
	--     preselectSupport = true,
	--     resolveSupport = {
	--       properties = { "documentation", "detail", "additionalTextEdits" }
	--     },
	--     snippetSupport = true,
	--     tagSupport = {
	--       valueSet = { 1 }
	--     }
	--   }

	-- Merge user-defined lsp settings.
	-- These can be overridden locally by lua/lsp-local/<server_name>.lua
	local exists, module = pcall(require, 'lsp-local.'..server_name)
	if not exists then
		exists, module = pcall(require, 'lsp.'..server_name)

	end
	if exists then
		local user_config = module.config(c)
		for k, v in pairs(user_config) do c[k] = v end
	end

	return c
end





if vim.fn.has('vim_starting') then
	-- Setup language servers using nvim-lsp-installer
	-- See https://github.com/williamboman/nvim-lsp-installer
	local lsp_installer = require('nvim-lsp-installer')

	lsp_installer.on_server_ready(function(server)
		local opts = make_config(server.name)
		server:setup(opts)
		vim.cmd [[ do User LspAttachBuffers ]]
	end)

	-- global custom location-list diagnostics window toggle.
	local args = { noremap = true, silent = true }
	vim.api.nvim_set_keymap(
		'n',
		'<Leader>a',
		'<cmd>lua require("user").diagnostic.publish_loclist(true)<CR>',
		args
	)

	vim.api.nvim_exec([[
		augroup user_lspconfig

			autocmd!
			" See https://github.com/kosayoda/nvim-lightbulb

			autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
			" Automatic diagnostic hover
			" autocmd CursorHold * lua require("user").diagnostic.show_line_diagnostics({ focusable=false })
		augroup END
	]], false)

end

return M

