local api = vim.api

vim.notify = require("notify")

local M = {}

require("mason").setup({
	automatic_installation = { exclude = { "pylsp" } },
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗",
		},
	},
})


-- Setup nvim-cmp.
local cmp = require("cmp")
cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip" },
		{ name = "ultisnips" }, -- For ultisnips user.
		-- { name = "cmp_tabnine" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "calc" },
		{ name = "emoji" },
		{ name = "treesitter" },
		{ name = "crates" },
	},

	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),
		["<C-p>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			end
		end, { "i", "s" }),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-t>"] = cmp.mapping.complete(),
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil,
	}),
})


-- doesn't seem to work
-- local python_lsp_home = vim.env.PYTHON_LSP_HOME
-- require('lspconfig').pyright.setup({
--     venvPath="/home/cc/anaconda3/envs/torch/bin",
--     on_attach = function(client, bufnr)
--         print('hello eslint')
--       end
-- })

-- Define a global variable to keep track of the LSP document highlight state
lsp_document_highlight_enabled = false
-- Define a function to toggle the LSP document highlight
function toggle_lsp_document_highlight()
	if lsp_document_highlight_enabled then
		-- Check if the autogroup exists before trying to delete it
		vim.cmd([[
        hi! clear LspReferenceRead Visual
        hi! clear LspReferenceText Visual
        hi! clear LspReferenceWrite Visual
        augroup lsp_document_highlight
            autocmd!
        augroup END
        augroup! lsp_document_highlight
        ]])
		lsp_document_highlight_enabled = false
	else
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
		lsp_document_highlight_enabled = true
	end
end

-- Change diagnostic signs.
vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "~", texthl = "DiagnosticSignHint" })

-- global config for diagnostic
vim.diagnostic.config({
	underline = false,
	virtual_text = false,
	signs = true,
	severity_sort = true,
	float = { border = "rounded", scope = "line", source = "always" },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	underline = false,
	border = "rounded",
	float = { border = "rounded", scope = "line", source = "always" },
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	underline = false,
	border = "rounded",
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = false,
	signs = true,
	update_in_insert = false,
    signs = {
      severity = { min = vim.diagnostic.severity.HINT },
    },
    virtual_text = {
      severity = { min = vim.diagnostic.severity.ERROR },
    },
})

local function config(_config)
	return vim.tbl_deep_extend("force", {
		capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
		--
		on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
			vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
			vim.keymap.set("n", "<leader>vws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
			vim.keymap.set("n", "<space>d", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
			vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
			vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)

			vim.keymap.set("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
			vim.keymap.set("x", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR><ESC>", opts)

			vim.keymap.set("n", "<Leader>la", '<cmd>lua require("user").diagnostic.publish_loclist(true)<CR>', opts)
			vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
			vim.keymap.set("n", "<space>ld", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
			vim.keymap.set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
			vim.keymap.set("n", "<space>lh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
			vim.keymap.set("n", "<space>li", ":lua toggle_lsp_document_highlight()<CR>", opts)
			vim.keymap.set("n", "<space>lw", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
			vim.keymap.set("n", "<space>lq", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
			vim.keymap.set(
				"n",
				"<space>ll",
				"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
				opts
			)
			vim.keymap.set("n", "<space>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
			vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
			vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.setqflist({open = true})<CR>", opts)
			vim.keymap.set("n", "<space>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

			if vim.g.logging_level == "debug" then
				local msg = string.format("Language server %s started!", client.name)
				vim.notify(msg, "info", { title = "Nvim-config" })
			end
		end,
	}, _config or {})
end


local python_lsp_home = vim.env.PYTHON_LSP_HOME
if python_lsp_home == nil then
	-- Use a default value or abort with a meaningful error message
	-- Here we will use an empty string as a default, but adjust as needed.
	python_lsp_home = ""
end

require("lspconfig").pylsp.setup(config({
	cmd_env = {
		PATH = python_lsp_home .. ":" .. vim.env.PATH,
	},
	settings = {
		pylsp = {
			plugins = {
				pylint = { enabled = true },
				pyflakes = { enabled = true },
				flake8 = { enabled = true },
				pycodestyle = { enabled = false },
				jedi_completion = { fuzzy = true },
				pyls_isort = { enabled = true },
				pylsp_mypy = { enabled = true },
                pylsp_black = { enabled = true },
                pylsp_ruff = { enabled = true },
			},
		},
	},
	flags = {
		debounce_text_changes = 200,
	},
	capabilities = capabilities,
}))

-- require("lspsaga").setup({
-- 	symbol_in_winbar = {
-- 		enable = false,
-- 		separator = " ",
-- 		ignore_patterns = {},
-- 		hide_keyword = true,
-- 		show_file = true,
-- 		folder_level = 2,
-- 		respect_root = false,
-- 		color_mode = true,
-- 	},
-- })

require("lspconfig").clangd.setup({
	on_attach = on_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	cmd = {
		"clangd",
		"--offset-encoding=utf-16",
	},
})


require'lspconfig'.ts_ls.setup(config({
    on_attach = on_attach,
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
        "svelte",
        "astro"
    }
}))

require'lspconfig'.jsonls.setup(config({
    on_attach = on_attach,
    filetypes = {
        "json",
        "jsonc",
    },
}))

return M
