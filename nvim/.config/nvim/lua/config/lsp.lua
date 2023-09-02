local api = vim.api
local lsp = vim.lsp

vim.notify = require("notify")

local M = {}


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
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })


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
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	underline = false,
	border = "rounded",
})


lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
	underline = false,
	virtual_text = false,
	signs = true,
	update_in_insert = false,
	signs = {
		severity_limit = "Hint",
	},
})


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = false,
    signs = {
      severity_limit = "Hint",
    },
    virtual_text = {
      severity_limit = "Error",
    },
  }
)

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
            vim.keymap.set('n', '<space>li', ":lua toggle_lsp_document_highlight()<CR>", opts)
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
			},
		},
	},
	flags = {
		debounce_text_changes = 200,
	},
	capabilities = capabilities,
}))

require("lspconfig").zls.setup(config())

require("lspconfig").tsserver.setup(config())

local lspconfig = require("lspconfig")
-- lspconfig.ccls.setup({
-- 	init_options = {
-- 		compilationDatabaseDirectory = "build",
-- 		index = {
-- 			threads = 0,
-- 		},
-- 		clang = {
-- 			excludeArgs = { "-frounding-math" },
-- 		},
-- 	},
-- })

-- require("lspconfig").jedi_language_server.setup(config())

require("lspconfig").svelte.setup(config())

require("lspconfig").solang.setup(config())

require("lspconfig").cssls.setup(config())

require("lspconfig").gopls.setup(config({
	cmd = { "gopls", "serve" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}))

-- who even uses this?
require("lspconfig").rust_analyzer.setup(config({
	cmd = { "rustup", "run", "nightly", "rust-analyzer" },
	--[[
    settings = {
        rust = {
            unstable_features = true,
            build_on_save = false,
            all_features = true,
        },
    }
    --]]
}))

-- local opts = {
-- 	-- whether to highlight the currently hovered symbol
-- 	-- disable if your cpu usage is higher than you want it
-- 	-- or you just hate the highlight
-- 	-- default: true
-- 	highlight_hovered_item = true,

-- 	-- whether to show outline guides
-- 	-- default: true
-- 	show_guides = true,
-- }

-- require("symbols-outline").setup(opts)

return M
