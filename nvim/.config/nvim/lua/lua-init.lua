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
    documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    mapping = {
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
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
