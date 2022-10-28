require("nvim-lsp-installer").setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})

-- Setup nvim-cmp.
local cmp = require'cmp'

local source_mapping = {
        nvim_lsp = "(LSP)",
        nvim_lua = "(Lua)",
        emoji = "(Emoji)",
        path = "(Path)",
        calc = "(Calc)",
        -- cmp_tabnine = "(Tabnine)",
        ultisnips = "(Snippet)",
        buffer = "(Buffer)",
}


 -- vim_item.kind = kind_icons[vim_item.kind]
-- -- vim_item.menu = source_names[entry.source.name]
-- vim_item.dup = duplicates[entry.source.name]
 --  -- or cmp.formatting.duplicates_default
-- return vim_item
-- local duplicates = {
 --    buffer = 1,
 --    path = 1,
 --    nvim_lsp = 0,
 --    luasnip = 1,
 --    ultisnips = 1,
-- };

local lspkind = require'lspkind'

cmp.setup({
    snippet = {
        expand = function(args)
            -- For `ultisnips` user.
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = {
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-t>'] = cmp.mapping.complete(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
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
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "luasnip" },
        { name = 'ultisnips' }, -- For ultisnips user.
        -- { name = "cmp_tabnine" },
        { name = "nvim_lua" },
        { name = "buffer" },
        { name = "calc" },
        { name = "emoji" },
        { name = "treesitter" },
        { name = "crates" },
    },
    completion = {
        keyword_length = 1,
        completeopt = "menu,noselect"
    },
    experimental = {
        ghost_text = true,
        native_menu = false,
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        source_names = {
            nvim_lsp = "(LSP)",
            emoji = "(Emoji)",
            path = "(Path)",
            calc = "(Calc)",
            -- cmp_tabnine = "(Tabnine)",
            ultisnips = "(Snippet)",
            buffer = "(Buffer)",
        },
        duplicates = {
            buffer = 1,
            path = 1,
            nvim_lsp = 0,
            luasnip = 1,
        },
        duplicates_default = 0,
        format = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind]
            local menu = source_mapping[entry.source.name]
            -- if entry.source.name == "cmp_tabnine" then
            --     if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
            --         menu = entry.completion_item.data.detail .. " " .. menu
            --     end
            --     vim_item.kind = ""
            -- end
            vim_item.menu = menu
            return vim_item
        end,
    }
})


--require("trouble").setup {
-- your configuration comes here
-- or leave it empty to use the default settings
-- refer to the configuration section below
--}

require'config.lsp'

require("bufferline").setup{
    options = {
        middle_mouse_command = "vertical sbuffer %d"
    }
}


-- empty setup using defaults: add your own options
require'nvim-tree'.setup {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = true,
    ignore_buffer_on_setup = false,
    ignore_ft_on_setup = {
        "startify",
        "dashboard",
        "alpha",
    },
    auto_reload_on_write = true,
    hijack_unnamed_buffer_when_opening = false,
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = true,
    diagnostics = {
        enable = false,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
    },
    system_open = {
        cmd = nil,
        args = {},
    },
    git = {
        enable = false,
        ignore = false,
        timeout = 200,
    },
    view = {
        width = 40,
        hide_root_folder = false,
        side = "left",
        mappings = {
            list = {
                { key = { "l", "<CR>", "o" }, action = "edit", mode = "n" },
                { key = "h", action = "close_node" },
                { key = "v", action = "vsplit" },
                { key = "C", action = "cd" },
                { key = "gtf", action = "telescope_find_files", action_cb = telescope_find_files },
                { key = "gtg", action = "telescope_live_grep", action_cb = telescope_live_grep },
            },
        },
        number = false,
        relativenumber = true,
        signcolumn = "yes",
    },
    filters = {
        dotfiles = false,
        custom = { "node_modules", ".cache" },
    },
    trash = {
        cmd = "trash",
        require_confirm = true,
    },
    actions = {
        change_dir = {
          enable = false,
          global = false,
          restrict_above_cwd = false,
        },
        open_file = {
            resize_window = true,
            quit_on_open = true,
        },
    }
}


-- no use for this currently, spell is annoying, chktex buggy
-- require("null-ls").setup({
--     sources = {
--         require("null-ls").builtins.formatting.stylua,
--         require("null-ls").builtins.diagnostics.eslint,
--         require("null-ls").builtins.completion.spell,
--         -- require("null-ls").builtins.diagnostics.chktex,
--         -- require("null-ls").builtins.formatting.latexindent,
--     },
-- })



-- vim.g.neoformat_lua_stylua = {
--     exe = "stylua",
--     args = { "--stdin-filepath", '"%:p"', "--config-path", '"C:\\Users\\Neel\\.stylua.toml"', "--", "-" },
--     stdin = 1,
-- }
-- vim.g.neoformat_tex_latexindent = {
--     exe = "latexindent",
--     args = { "-g /dev/stderr", "2>/dev/null", "-d" },
--     stdin = 1,
-- }

-- vim.g.neoformat_run_all_formatters = 1
-- vim.g.neoformat_enabled_python = { "isort", "black" }
-- vim.g.neoformat_enabled_lua = { "stylua" }
-- vim.g.neoformat_enabled_tex = { "latexindent" }

-- require('lint').linters_by_ft = {
--   tex = {'chktex','lacheck'}
-- }

local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
})

local auto_dark_mode = require('auto-dark-mode')

-- auto_dark_mode.setup({
-- 	update_interval = 2000,
-- 	set_dark_mode = function()
-- 		vim.api.nvim_set_option('background', 'dark')
-- 		vim.cmd('colorscheme palenight')
-- 		vim.cmd('AirlineTheme palenight')

-- 	end,
-- 	set_light_mode = function()
-- 		vim.api.nvim_set_option('background', 'light')
-- 		vim.cmd('colorscheme PaperColor')
-- 		vim.cmd('AirlineTheme atomic')
-- 	end,
-- })
-- auto_dark_mode.init()



-- For color-picker.nvim
local opts = { noremap = true, silent = true }

-- vim.keymap.set("n", "<C-c>", "<cmd>PickColor<cr>", opts)
vim.keymap.set("i", "<C-c>", "<cmd>PickColorInsert<cr>", opts)

-- only need setup() if you want to change progress bar icons
require("color-picker").setup({
	-- ["icons"] = { "ﱢ", "" },
	-- ["icons"] = { "ﮊ", "" },
	-- ["icons"] = { "", "ﰕ" },
	["icons"] = { "ﱢ", "" },
	-- ["icons"] = { "", "" },
	-- ["icons"] = { "", "" },
})

vim.cmd([[hi FloatBorder guibg=NONE]]) -- if you don't want wierd border background colors around the popup.

require("auto-save").setup {
    enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
    execution_message = {
		message = function() -- message to print on save
			return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
		end,
		dim = 0.18, -- dim the color of `message`
		cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
	},
    trigger_events = {"InsertLeave", "TextChanged"}, -- vim events that trigger auto-save. See :h events
	-- function that determines whether to save the current buffer or not
	-- return true: if buffer is ok to be saved
	-- return false: if it's not ok to be saved
	condition = function(buf)
		local fn = vim.fn
		local utils = require("auto-save.utils.data")

		if
			fn.getbufvar(buf, "&modifiable") == 1 and
			not utils.not_in(fn.getbufvar(buf, "&filetype"), {'vimwiki'}) then
			return true -- met condition(s), can save
		end
		return false -- can't save
	end,
    write_all_buffers = false, -- write all buffers when the current one meets `condition`
    debounce_delay = 135, -- saves the file at most every `debounce_delay` milliseconds
	callbacks = { -- functions to be executed at different intervals
		enabling = nil, -- ran when enabling auto-save
		disabling = nil, -- ran when disabling auto-save
		before_asserting_save = nil, -- ran before checking `condition`
		before_saving = nil, -- ran before doing the actual save
		after_saving = nil -- ran after doing the actual save
	}
}




require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust", "python" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- 20221011: TS for help has a whitespace bug: "Text :cmd" shows as "Text:cmd"
    disable = { "help" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require("live-command").setup {
  commands = {
    Norm = { cmd = "norm" },
  },
}
