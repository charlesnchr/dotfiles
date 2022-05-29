-- Setup nvim-cmp.
local cmp = require'cmp'

local source_mapping = {
        nvim_lsp = "(LSP)",
        nvim_lua = "(Lua)",
        emoji = "(Emoji)",
        path = "(Path)",
        calc = "(Calc)",
        cmp_tabnine = "(Tabnine)",
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
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
        { name = "cmp_tabnine" },
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
            cmp_tabnine = "(Tabnine)",
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
            if entry.source.name == "cmp_tabnine" then
                if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                    menu = entry.completion_item.data.detail .. " " .. menu
                end
                vim_item.kind = ""
            end
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
    open_on_setup = false,
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
    update_cwd = false,
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
        enable = true,
        ignore = false,
        timeout = 200,
    },
    view = {
        width = 30,
        height = 30,
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
        relativenumber = false,
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
            global = false,
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

auto_dark_mode.setup({
	update_interval = 1000,
	set_dark_mode = function()
		vim.api.nvim_set_option('background', 'dark')
		vim.cmd('colorscheme palenight')
	end,
	set_light_mode = function()
		vim.api.nvim_set_option('background', 'light')
		vim.cmd('colorscheme rakr')
	end,
})
auto_dark_mode.init()
