require("config.lsp")

local auto_dark_mode = require("auto-dark-mode")
auto_dark_mode.setup({
	update_interval = 2000,
	set_dark_mode = function()
		vim.api.nvim_set_option("background", "dark")
		vim.cmd("colorscheme tokyonight")
		-- vim.cmd("AirlineTheme catppuccin")
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
	end,
	set_light_mode = function()
		vim.api.nvim_set_option("background", "light")
		vim.cmd("colorscheme tokyonight-day")
		-- vim.cmd("AirlineTheme atomic")
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
	end,
})
auto_dark_mode.init()

-- require("bufferline").setup({
-- 	options = {
-- 		middle_mouse_command = "vertical sbuffer %d",
-- 	},
-- })

require("nvim-tree").setup({

    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
	-- git = {
	-- 	enable = false,
	-- 	ignore = false,
	-- 	timeout = 200,
	-- },
	view = {
		width = 40,
		side = "left",
		number = false,
		relativenumber = true,
		signcolumn = "yes",
	},
    on_attach = function(bufnr)
      local api = require('nvim-tree.api')

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Default mappings. Feel free to modify or remove as you wish.
      --
      -- BEGIN_DEFAULT_ON_ATTACH
      vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
      vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
      vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
      vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
      vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
      vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
      vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
      vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
      vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
      vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
      vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
      vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
      vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
      vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
      vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
      vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
      vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
      vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
      vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
      vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
      vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
      vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
      vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
      vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
      vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
      vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
      vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
      vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
      vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
      vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
      vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
      vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
      vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
      vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
      vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
      vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
      vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
      vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
      vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
      vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
      vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
      vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
      vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
      vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
      vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
      vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
      vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
      vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
      vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
      vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
      vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
      vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
      -- END_DEFAULT_ON_ATTACH

      -- Mappings migrated from view.mappings.list
      --
      -- You will need to insert "your code goes here" for any mappings with a custom action_cb
      vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
      vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
      vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
      vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
      vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
      vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
      vim.keymap.set("n", "<C-h>", api.tree.collapse_all, opts("Collapse All"))

    end
})

local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
        layout_strategy = "vertical",
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '-g', '!*.pdf',   -- Ignore .pdf files
          '-g', '!wandb',   -- Ignore wandb files
        },
		mappings = {
			i = {
				-- ["<esc>"] = actions.close,
				["<C-f>"] = actions.send_to_qflist + actions.open_qflist,
                ['<C-b>'] = require('telescope.actions').delete_buffer,
                ["<C-h>"] = "which_key",
			},
			n = {
                ['<C-b>'] = require('telescope.actions').delete_buffer,
				["<C-f>"] = actions.send_to_qflist + actions.open_qflist,
			},
		},
		file_ignore_patterns = { "node_modules", "tags", "%.pdf" },
	},
})

M = {}
M.tags = function()
	-- get pane width from tmux and use half the width for the fname_width
	local fname_width = math.floor(vim.fn.system("tmux display -p '#{pane_width}'") / 4)
	-- Maybe running outside of tmux
	if fname_width == 0 then
		fname_width = 30
	end
    -- echo
	require('telescope.builtin').tags({fname_width = fname_width })
end

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

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

require("auto-save").setup({
	enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
	execution_message = {
		message = function() -- message to print on save
			return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
		end,
		dim = 0.18, -- dim the color of `message`
		cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
	},
	trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
	-- function that determines whether to save the current buffer or not
	-- return true: if buffer is ok to be saved
	-- return false: if it's not ok to be saved
	condition = function(buf)
		local fn = vim.fn
		local utils = require("auto-save.utils.data")

		if
			fn.getbufvar(buf, "&modifiable") == 1 and not utils.not_in(fn.getbufvar(buf, "&filetype"), { "vimwiki" })
		then
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
		after_saving = nil, -- ran after doing the actual save
	},
})

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
	ensure_installed = { "c", "lua", "rust", "python" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	auto_install = true,

	-- List of parsers to ignore installing (for "all")
	ignore_install = {},

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
})

require("live-command").setup({
	commands = {
		Norm = { cmd = "norm" },
	},
})

require("aerial").setup({
	-- optionally use on_attach to set keymaps when aerial has attached to a buffer
	on_attach = function(bufnr)
		-- Jump forwards/backwards with '{' and '}'
		vim.keymap.set("n", "<c-k>", "<cmd>AerialPrev<CR>", { buffer = bufnr })
		vim.keymap.set("n", "<c-j>", "<cmd>AerialNext<CR>", { buffer = bufnr })
	end,
    keymaps = {
        ["<Esc>"] = "actions.close",
    },
    close_on_select = true,
})

require("telescope").load_extension("aerial")

-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

require("toggleterm").setup{
  open_mapping = [[<F4>]],
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
}

-- require("chatgpt").setup({
-- 	welcome_message = WELCOME_MESSAGE,
-- 	loading_text = "loading",
-- 	question_sign = "", -- you can use emoji if you want e.g. 🙂
-- 	answer_sign = "ﮧ", -- 🤖
-- 	max_line_length = 120,
-- 	yank_register = "+",
-- 	chat_layout = {
-- 		relative = "editor",
-- 		position = "50%",
-- 		size = {
-- 			height = "80%",
-- 			width = "80%",
-- 		},
-- 	},
-- 	settings_window = {
-- 		border = {
-- 			style = "rounded",
-- 			text = {
-- 				top = " Settings ",
-- 			},
-- 		},
-- 	},
-- 	chat_window = {
-- 		filetype = "chatgpt",
-- 		border = {
-- 			highlight = "FloatBorder",
-- 			style = "rounded",
-- 			text = {
-- 				top = " ChatGPT ",
-- 			},
-- 		},
-- 	},
-- 	chat_input = {
-- 		prompt = "  ",
-- 		border = {
-- 			highlight = "FloatBorder",
-- 			style = "rounded",
-- 			text = {
-- 				top_align = "center",
-- 				top = " Prompt ",
-- 			},
-- 		},
-- 	},
-- 	openai_params = {
-- 		model = "gpt-3.5-turbo",
-- 		frequency_penalty = 0,
-- 		presence_penalty = 0,
-- 		max_tokens = 300,
-- 		temperature = 0,
-- 		top_p = 1,
-- 		n = 1,
-- 	},
-- 	openai_edit_params = {
-- 		model = "gpt-3.5-turbo",
-- 		frequency_penalty = 0,
-- 		presence_penalty = 0,
-- 		max_tokens = 300,
-- 		temperature = 0,
-- 		top_p = 1,
-- 		n = 1,
-- 	},
-- 	keymaps = {
-- 		close = { "<C-c>" },
-- 		submit = "<C-p>",
-- 		yank_last = "<C-y>",
-- 		yank_last_code = "<C-k>",
-- 		scroll_up = "<C-u>",
-- 		scroll_down = "<C-d>",
-- 		toggle_settings = "<C-o>",
-- 		new_session = "<C-n>",
-- 		cycle_windows = "<Tab>",
-- 		-- in the Sessions pane
-- 		select_session = "<Space>",
-- 		rename_session = "r",
-- 		delete_session = "d",
-- 	},
-- })

require('leap').add_default_mappings()


local python_lsp_home = vim.env.PYTHON_LSP_HOME
if python_lsp_home == nil then
  -- Use a default value or abort with a meaningful error message
  -- Here we will use an empty string as a default, but adjust as needed.
  python_lsp_home = ""
end

-- require('dap-python').setup(python_lsp_home .. "python")
-- vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
-- vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
-- vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
-- vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
-- vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
-- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
-- vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
-- vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
-- vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
-- vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
--   require('dap.ui.widgets').hover()
-- end)
-- vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
--   require('dap.ui.widgets').preview()
-- end)
-- vim.keymap.set('n', '<Leader>df', function()
--   local widgets = require('dap.ui.widgets')
--   widgets.centered_float(widgets.frames)
-- end)
-- vim.keymap.set('n', '<Leader>ds', function()
--   local widgets = require('dap.ui.widgets')
--   widgets.centered_float(widgets.scopes)
-- end)


-- require("fidget").setup {
--   -- options
-- }


