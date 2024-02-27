set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

" plugin on GitHub repo
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
" Plug 'Raimondi/delimitMate'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'vim-syntastic/syntastic'

" got to be annoying with underline
" Plug 'dense-analysis/ale'
Plug 'ryanoasis/vim-devicons'
Plug 'rafi/awesome-vim-colorschemes'
" Plug 'preservim/nerdtree'

Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
"Plug 'ervandew/supertab'
" Plug 'kien/ctrlp.vim'
" markdown syntax
Plug 'godlygeek/tabular'
" Plug 'Konfekt/FastFold'
" writing
Plug 'reedes/vim-pencil'
Plug 'lervag/vimtex'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'xolox/vim-misc'
" styling
Plug 'joshdick/onedark.vim'
Plug 'drewtempelmeyer/palenight.vim'
" misc
Plug 'ludovicchabant/vim-gutentags'
Plug 'junegunn/goyo.vim'
Plug 'enricobacis/vim-airline-clock'

Plug 'SirVer/ultisnips'
" Plug 'ycm-core/YouCompleteMe'
Plug 'honza/vim-snippets'
Plug 'vimwiki/vimwiki'

" not very good imo
" Plug 'preservim/vim-markdown'

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

Plug 'kana/vim-textobj-user'
Plug 'rbonvall/vim-textobj-latex'
Plug 'jeetsukumaran/vim-pythonsense'

Plug 'mhinz/vim-startify'
" Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/gv.vim'
Plug 'voldikss/vim-floaterm'
Plug 'mg979/vim-visual-multi'
Plug 'mattn/calendar-vim'
Plug 'python-mode/python-mode', { 'for': 'python' }
Plug 'tpope/vim-unimpaired'
Plug 'sillybun/vim-repl'
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' } " slows down start-up
" Plug 'jupyter-vim/jupyter-vim'
" Plug 'klafyvel/vim-slime-cells'

" highlighting occurrences, toggling hlsearch
" Plug 'kevinhwang91/nvim-hlslens'
Plug 'romainl/vim-cool'

" Plug 'kassio/neoterm'
Plug 'preservim/tagbar'

Plug 'francoiscabrol/ranger.vim'

Plug 'rupa/v'
Plug 'ojroques/vim-oscyank'
Plug 'junegunn/vim-peekaboo'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Plug 'kevinhwang91/nvim-bqf'

Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }

" " Have not added any parsers yet
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'sbdchd/neoformat'
Plug 'simnalamburt/vim-mundo'
Plug 'liuchengxu/vista.vim'
Plug 'tpope/vim-commentary'
Plug 'folke/which-key.nvim'

Plug 'hrsh7th/cmp-omni'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
" Plug 'hrsh7th/cmp-calc'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
" Plug 'L3MON4D3/LuaSnip'
" Plug 'saadparwaiz2/cmp_luasnip'
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'neovim/nvim-lspconfig'
" Plug 'rafamadriz/friendly-snippets'


Plug 'folke/trouble.nvim'

"Plug 'liuchengxu/vim-which-key'
"Plug 'glepnir/spaceline.vim'
" Plug 'itchyny/lightline.vim'

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'trotter/autojump.vim', { 'on': 'J' }
Plug 'arcticicestudio/nord-vim'
" Plug 'christoomey/vim-tmux-navigator'
" provides keybinding, strip
Plug 'ntpeters/vim-better-whitespace'

" not completely sure why the below module is needed, but I get an error by
" Ctrl+G in .zsh files if not, possibly from nvim-treesitter
Plug 'kosayoda/nvim-lightbulb'
" Plug 'puremourning/vimspector'
Plug 'ThePrimeagen/harpoon'

" for C-h, C-l to repeat after t,f,T,F
Plug 'vim-scripts/repeatable-motions.vim'

Plug 'rcarriga/nvim-notify'

" Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }

" tested both for latex and they work with chktex, null-ls is buggy, both are
" not ideal
" Plug 'mfussenegger/nvim-lint'
" Plug 'jose-elias-alvarez/null-ls.nvim'
" Plug 'justinmk/vim-sneak' " easier than easymotion

" Java grammar checker -- used for thesis
" Plug 'rhysd/vim-grammarous'
Plug 'kana/vim-operator-user'


" Plug 'itchyny/calendar.vim'
Plug 'jesseleite/vim-agriculture'
Plug 'charlesnchr/auto-dark-mode.nvim'
" Plug 'f-person/auto-dark-mode.nvim'
Plug 'chrisbra/recover.vim'
Plug 'ziontee113/color-picker.nvim'

if has("win32")
    Plug 'ptzz/lf.vim'
else
    Plug 'charlesnchr/ranger-floaterm.vim'
endif

Plug 'will133/vim-dirdiff'
Plug 'Pocco81/auto-save.nvim'
Plug 'liuchengxu/vista.vim'
Plug 'smjonas/live-command.nvim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'TimUntersberger/neogit'
Plug 'github/copilot.vim'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'folke/tokyonight.nvim'
Plug 'rose-pine/neovim'
Plug 'knsh14/vim-github-link'
Plug 'tpope/vim-rhubarb'
Plug 'stevearc/aerial.nvim'
" Plug 'nikvdp/neomux'
Plug 'akinsho/toggleterm.nvim'
" Plug 'jackMort/ChatGPT.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'glepnir/lspsaga.nvim'
Plug 'ggandor/leap.nvim'
Plug 'dstein64/vim-startuptime'

" modern gui popups
" Plug 'stevearc/dressing.nvim'
" Plug 'folke/noice.nvim'

" Plug 'mfussenegger/nvim-dap'
" Plug 'mfussenegger/nvim-dap-python'
Plug 'mbbill/undotree'
Plug 'Eandrju/cellular-automaton.nvim'
Plug 'VonHeikemen/lsp-zero.nvim'
Plug 'rafamadriz/friendly-snippets'
Plug 'j-hui/fidget.nvim', { 'tag': 'legacy' }
Plug 'chipsenkbeil/distant.nvim', { 'branch': 'v0.3'}

call plug#end()

set updatetime=100

" for performance on start-up https://www.reddit.com/r/neovim/comments/r9acxp/neovim_is_slow_because_of_python_provider/
if has('mac')
    let g:python3_host_prog = expand($PYTHON_LSP_HOME .. '/python')
elseif has('unix')
    let g:python3_host_prog = expand($PYTHON_LSP_HOME .. '/python')
else
    " On Windows, replace the path with your actual PYTHON_LSP_HOME path in Windows format
    let g:python3_host_prog = expand('C:/Users/charl/scoop/shims/python.exe')
endif


lua require('lua-init')

let mapleader = ","
let maplocalleader = " " " used to be \\

set splitbelow
set splitright

" Enable folding
set foldmethod=indent
set foldlevel=99
"Enable folding with the spacebar
"let g:vim_markdown_folding_disabled = 1
"let g:vim_markdown_folding_style_pythonic = 1


" open files with ctrl-p
nnoremap <localleader>ff :Files<cr>
nnoremap <localleader>fg :GitFiles<cr>
nnoremap <localleader>ft :Tags<cr>
nnoremap <localleader>fv :Buffers<cr>
nnoremap <localleader>fc :Commands<cr>
nnoremap <localleader>fb :Buffers<cr>
nnoremap <localleader>fm :Marks<cr>
nnoremap <localleader>fh :History<cr>
nnoremap <localleader>fw :Windows<cr>


" " " wrapper for bufferline goto
" nnoremap <silent>gb :<C-u>call BufferGoto()<CR>
" function! BufferGoto()
"     exec ':BufferLineGoToBuffer' v:count1
" endfunction

" " Bufferline bar
" nnoremap <silent><localleader>bp :BufferLinePick<cr>
" nnoremap <silent><localleader>bc :BufferLinePickClose<cr>
" nnoremap <silent><localleader>d :bd<cr>
" nnoremap <silent><localleader>bg :BufferLineGoToBuffer<space>
" nnoremap <silent><localleader>bl :BufferLineMoveNext<CR>
" nnoremap <silent><localleader>bh :BufferLineMovePrev<CR>
" nnoremap <silent> [b :BufferLineCyclePrev<CR>
" nnoremap <silent> ]b :BufferLineCycleNext<CR>
" nnoremap <silent>    <A-x> :BufferLineCyclePrev<CR>
" nnoremap <silent>    <A-c> :BufferLineCycleNext<CR>
" nnoremap <silent>    <A-X> :BufferLineMovePrev<CR>
" nnoremap <silent>    <A-C> :BufferLineMoveNext<CR>
" nnoremap <silent>    <localleader>1 :BufferLineGoToBuffer 1<CR>
" nnoremap <silent>    <localleader>2 :BufferLineGoToBuffer 2<CR>
" nnoremap <silent>    <localleader>3 :BufferLineGoToBuffer 3<CR>
" nnoremap <silent>    <localleader>4 :BufferLineGoToBuffer 4<CR>
" nnoremap <silent>    <localleader>5 :BufferLineGoToBuffer 5<CR>
" nnoremap <silent>    <localleader>6 :BufferLineGoToBuffer 6<CR>
" nnoremap <silent>    <localleader>7 :BufferLineGoToBuffer 7<CR>
" nnoremap <silent>    <localleader>8 :BufferLineGoToBuffer 8<CR>



" nnoremap <localleader>aj :CtrlPTag<cr>
" nnoremap <localleader>aa :CtrlPBufTag<cr>
" nnoremap <localleader>as :CtrlPBuffer<cr>
" nnoremap <localleader>s :CtrlPBuffer<cr>
" nnoremap <localleader>ad :CtrlPMRUFiles<cr>
" nnoremap <localleader>e :CtrlPMRUFiles<cr>
" let g:ctrlp_cmd = 'CtrlPMRUFiles'
" nnoremap <localleader>af :CtrlPLine<cr>

  " let g:ctrlp_prompt_mappings = {
  "   \ 'PrtSelectMove("j")':   ['<c-n>', '<down>'],
  "   \ 'PrtSelectMove("k")':   ['<c-p>', '<up>'],
  "   \ 'PrtHistory(-1)':       ['<c-j>'],
  "   \ 'PrtHistory(1)':        ['<c-k>'] }

" let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:10'

" " don't show the help in normal mode
" let g:Lf_HideHelp = 1
" let g:Lf_UseCache = 0
" let g:Lf_UseVersionControlTool = 0
" let g:Lf_IgnoreCurrentBufferName = 1
" " popup mode
" let g:Lf_WindowPosition = 'popup'
" let g:Lf_PreviewInPopup = 1
" let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
" let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
" let g:Lf_ShortcutF = "<localleader>ff"
" noremap <localleader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
" noremap <localleader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
" noremap <localleader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
" noremap <localleader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

au BufNewFile,BufRead *.py,*.java,*.cpp,*.c,*.cs,*.rkt,*.h,*.html
            \ set tabstop=4 |
            \ set softtabstop=4 |
            \ set shiftwidth=4 |
            \ set textwidth=120 |
            \ set expandtab |
            \ set autoindent |
            \ set fileformat=unix


au BufNewFile,BufRead *.tex
            \ set textwidth=80

au BufNewFile,BufRead *.wiki
            \ SoftPencil

" trialing these options for all types
set tabstop=4
set expandtab
set autoindent
set softtabstop=4
set shiftwidth=4

" Reopen the last edited position in files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set encoding=utf-8

syntax on
filetype plugin on

" platform dependent
"let g:ycm_path_to_python_interpreter='/usr/local/bin/python3'

" for vimwiki
let g:vimwiki_list = [{
            \ 'path': '$HOME/0main/Syncthing/wiki',
            \ 'syntax': 'markdown',
            \ 'template_path': '$HOME/0main/Syncthing/wiki/templates',
            \ 'template_default': 'default',
            \ 'template_ext': '.html'}]
let g:vimwiki_ext2syntax = {
            \'.wiki': 'markdown',
            \}
" if I don't like markdown
" let g:vimwiki_ext2syntax = {
"             \}
let g:vimwiki_global_ext = 0

let g:startify_files_number = 10
let g:startify_bookmarks = [
            \ { 'p': '~/0main/0phd' },
            \ { 'c': '~/0main/0phd/ccRestore' },
            \ { 'g': '~/GitHub' },
            \ '~/0main',
            \ ]
let g:startify_change_to_dir = 0

function! s:list_commits()
  let git = 'git '
  let commits = systemlist(git .' log --oneline | head -n10')
  let git = 'G'. git[1:]
  return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
endfunction

let g:startify_lists = [
      \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
      \ { 'header': ['   MRU'],            'type': 'files' },
      \ { 'header': ['   Sessions'],       'type': 'sessions' },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'header': ['   Commits'],        'type': function('s:list_commits') },
      \ ]

" air-line
" alternative statusline with clock and cwd
" set statusline=%F
" set statusline+=%=
" set statusline+=%{getcwd()}\ TIME:\ %{strftime('%c')}
" let g:airline_theme = 'tomorrow'
" let g:airline#extensions#tabline#enabled = 0           " enable airline tabline
" let g:airline#extensions#branch#enabled = 0           " disable branch
" set statusline+=%{gutentags#statusline()}

" if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
" endif

" " unicode symbols
" let g:airline_left_sep = '»'
" let g:airline_left_sep = '▶'
" let g:airline_right_sep = '«'
" let g:airline_right_sep = '◀'
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '␤'
" let g:airline_symbols.linenr = '¶'
" let g:airline_symbols.branch = '⎇'
" let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
" let g:airline_symbols.paste = '∥'
" let g:airline_symbols.whitespace = 'Ξ'

" " airline symbols
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
" let g:airline_symbols.branch = ''
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = '㏑'
" let g:airline_section_x = '%{PencilMode()}'

set laststatus=2
" set showtabline=0
set signcolumn=yes


" true colours
" You might have to force true color when using regular vim inside tmux as the
" colorscheme can appear to be grayscale with "termguicolors" option enabled.
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
nnoremap <leader><F8> :PrevColorScheme<CR>
" nnoremap <leader>nn :NextColorScheme<CR>
" colorscheme challenger_deep

" for mac: theme applied via auto theme plugin
set termguicolors

if has('mac')
    " for mac: theme applied on startup, then synced via lua theme
    let output =  system("defaults read -g AppleInterfaceStyle")
    if v:shell_error != 0
        let g:airline_theme = 'atomic'
        set background=light
        colorscheme tokyonight-day
    else
        let g:airline_theme = 'catppuccin'
        set background=dark
        colorscheme tokyonight
    endif
elseif has('unix')

    let output =  system("cat ~/dotfiles/is_dark_mode")
    if output == 0
        let g:airline_theme = 'atomic'
        set background=light
        colorscheme tokyonight-day
    else
        let g:airline_theme = 'catppuccin'
        set background=dark
        colorscheme tokyonight
    endif
endif


if has("win32")
    set shell=powershell
    set shellcmdflag=-command
    set shellquote=\"
    set shellxquote=
endif


" fix for :Rg and Ranger preview
augroup update_bat_theme
    autocmd!
    autocmd colorscheme * call ToggleBatEnvVar()
augroup end
function ToggleBatEnvVar()
    if (&background == "light")
        let $BAT_THEME='Solarized (dark)'
    else
        let $BAT_THEME='Solarized (dark)'
    endif
endfunction

" colorscheme palenight
" colorscheme space-vim-dark
" colorscheme solarized8_high


set nu rnu " relative line numbering
if has('mac')
    set clipboard=unnamed " public copy/paste register
elseif has('unix') " for server, not sure if necessary
    set clipboard=unnamedplus
endif

set ignorecase
set wildignorecase " affects :e
set smartcase

set mouse=a

" nerdtree
" nnoremap <leader>nn :NERDTreeFocus<CR>
" nnoremap <leader>nc :NERDTree<CR>
" nnoremap <leader>nt :NERDTreeToggle<CR>
" nnoremap <leader>nf :NERDTreeFind<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>


nmap <F2> :TagbarOpenAutoClose<CR>
nmap <leader>ga :TagbarToggle<CR>
nmap <leader>a :TagbarOpenAutoClose<CR>
let g:tagbar_sort = 0
let g:tagbar_width = 60


if !exists('g:lasttab')
    let g:lasttab = 1
endif
nmap <leader><Tab> :exe "tabn ".g:lasttab<CR>
nmap <localleader><Tab> <C-^>
au TabLeave * let g:lasttab = tabpagenr()

nnoremap <ScrollWheelUp> <C-Y>
nnoremap <ScrollWheelDown> <C-E>


" latex
if has('mac')
    let g:vimtex_view_method = 'skim'
elseif has('unix')
    let g:latex_view_general_viewer = 'zathura'
    let g:vimtex_view_method = "zathura"
endif
let g:vimtex_syntax_conceal_disable = 1
" let g:vimtex_compiler_latexmk = {
"             \ 'executable' : 'latexmk',
"             \ 'options' : [
"                 \   '-xelatex',
"                 \   '-interaction=nonstopmode',
"                 \ ],
"                 \}
let g:vimtex_fold_enabled = 1


function! WC()
    let filename = expand("%")
    let cmd = "./texcount.pl -inc " . filename
    let result = system(cmd)
    echo result
endfunction

command WC call WC()
nnoremap <localleader>l1 <cmd>VimtexCountWords<cr>
nnoremap <localleader>l2 <cmd>call WC()<cr>

" writing
"let g:pencil#conceallevel = 3     " 0=disable, 1=one char, 2=hide char, 3=hide all (def)
"let g:pencil#concealcursor = 'c'  " n=normal, v=visual, i=insert, c=command (def)
"let g:pencil#autoformat = 0      " 0=disable, 1=enable (def)
let g:goyo_width = 85
"let g:goyo_linenr = 1


" autocomplete
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" let g:ycm_autoclose_preview_window_after_completion=0
" map <localleader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
" for latex
" if !exists('g:ycm_semantic_triggers')
" let g:ycm_semantic_triggers = {}
" endif
" au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme

" let g:ycm_filetype_blacklist={'markdown':1,'notes': 1, 'unite': 1, 'tagbar': 1, 'pandoc':1, 'qf': 1 ,'text': 1, 'infolog': 1, 'mail': 1}



" programming, terminal
nnoremap <silent> <leader><F12> :FloatermNew<CR>
tnoremap <silent> <leader><F12> <C-\><C-n>:FloatermNew<CR>
nnoremap <silent> <F10> :FloatermPrev<CR>
tnoremap <silent> <F10> <C-\><C-n>:FloatermPrev<CR>
nnoremap <silent> <F11> :FloatermNext<CR>
tnoremap <silent> <F11> <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <F12> :FloatermToggle<CR>
tnoremap <silent> <F12> <C-\><C-n>:FloatermToggle<CR>

" annoying when it is esc, messes with popup windows
tnoremap <C-b> <C-\><C-n>
let g:neoterm_autoscroll = 1

" -------------------
" NAVIGATION
" -------------------

" bufmer cycle
" :nnoremap <localleader><tab> :b#<CR>
" :nnoremap <localleader><tab> :CtrlPBuffer<cr>
" :nnoremap <localleader><S-tab> :bprevious<CR>

" -------------------
" CONVENIENCE
" -------------------
" quick save
nnoremap <C-S-s> :w<cr>
inoremap <C-S-s> <Esc>:w<cr>

" quick edit
nnoremap <localleader>ve :e ~/.vimrc<cr>
nnoremap <localleader>vt :tabe ~/.vimrc<cr>
nnoremap <localleader>vs :source ~/.vimrc<cr>
nnoremap <localleader>vp :w<cr>:source ~/.vimrc<cr>:PlugInstall<cr>

nnoremap <localleader>vg :G<cr>
nnoremap <localleader>gj :G<cr>
nnoremap <localleader>gc :G commit --verbose -m "Small update"<cr>
nnoremap <localleader>gn :G log --name-status<cr>
nnoremap <localleader>gl :G pull<cr>
nnoremap <localleader>gp :G push<cr>

nnoremap <localleader>w :w<cr>
nnoremap <localleader>q :quit<cr>
nnoremap <C-p> :wq<CR>
imap <C-k> <Esc>:wq<CR>
nnoremap <D-v> "+p
inoremap <D-v> <C-r>+

nnoremap <localleader>0 :Startify<cr>
" nicer to have pwd
" nnoremap <localleader>cd :cd %:h<cr>
" pointless symlink follow
" nnoremap <localleader>cs :cd %:p:h<CR>:cd `dirname $(readlink %)`<CR>:pwd<CR>
nnoremap <localleader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <leader>qf :copen<cr>

" Insert timestamp
"imap <F3> <C-R>=strftime("%Y-%m-%d %H:%M %p")<CR>
nmap <F3> i<C-R>=strftime("%Y-%m-%d")<CR><Esc>
imap <F3> <C-R>=strftime("%Y-%m-%d")<CR>

" let g:floaterm_wintype = 'split'
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8


"let g:taskwiki_sort_orders={"T": "end-"}
" nmap <C-k> <Plug>VimwikiPrevLink
" nmap <C-j> <Plug>VimwikiNextLink
autocmd FileType vimwiki map <buffer> <C-k> <Plug>VimwikiGoToPrevHeader<CR>
autocmd FileType vimwiki map <buffer> <C-j> <Plug>VimwikiGoToNextHeader<CR>
autocmd FileType vimwiki map <buffer> <C-h> <Plug>VimwikiDiaryPrevDay<CR>
autocmd FileType vimwiki map <buffer> <C-l> <Plug>VimwikiDiaryNextDay<CR>
nnoremap <leader>tl <cmd>VimwikiToggleListItem<cr>

vnoremap <leader>y :OSCYank<CR>


"------------------------------------------------------------------------------
" slime configuration
"------------------------------------------------------------------------------
" always use tmux
let g:slime_target = 'tmux'

" fix paste issues in ipython
" let g:slime_python_ipython = 1
let g:slime_bracketed_paste = 1
" let g:slime_no_mappings = 1

let g:slime_cell_delimiter = "# %%"
nmap <leader>s <Plug>SlimeSendCell


" always send text to the top-right pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': ':.1' }
            " \ 'target_pane': '{right-of}' }
let g:slime_dont_ask_default = 1

nmap <c-c>v <Plug>SlimeConfig

" " vim-slime-cells
" nmap <c-c><c-c> <Plug>SlimeCellsSendAndGoToNext
" nmap <c-c><c-j> <Plug>SlimeCellsNext
" nmap <c-c><c-k> <Plug>SlimeCellsPrev
" autocmd FileType python map [c <Plug>SlimeCellsPrev
" autocmd FileType python map ]c <Plug>SlimeCellsNext

"------------------------------------------------------------------------------
" IPython  configuration
"------------------------------------------------------------------------------
" For Ipython plugin - Matlab bindings
" map <F5> to save and run script
" nnoremap <F5> :w<CR>:IPythonCellRun<CR>
" inoremap <F5> <C-o>:w<CR><C-o>:IPythonCellRun<CR>

" map <F6> to evaluate current cell without saving
nnoremap <F6> :IPythonCellExecuteCellVerboseJump<CR>
inoremap <F6> <C-o>:IPythonCellExecuteCellVerboseJump<CR>
"nnoremap <F6> :REPLSendSession<CR>
"inoremap <F6> <C-o>:REPLSendSession<CR>
let g:repl_program = {
            \'python': ['ipython'],
            \'default': ['bash']
            \}


" map <F7> to evaluate current cell and jump to next cell without saving
" nnoremap <F7> :IPythonCellExecuteCellVerboseJump<CR>
" inoremap <F7> <C-o>:IPythonCellExecuteCellVerboseJump<CR>

 " augroup ipython_cell_highlight
 "     autocmd!
 "     autocmd ColorScheme * highlight IPythonCell ctermbg=238 guifg=darkgrey guibg=#444d56
 " augroup END

" map [c and ]c to jump to the previous and next cell header
autocmd FileType python map <buffer> [g :IPythonCellPrevCell<CR>
autocmd FileType python map <buffer> ]g :IPythonCellNextCell<CR>
" au BufNewFile,BufRead *.py nmap [c :IPythonCellPrevCell<CR>
" au BufNewFile,BufRead *.py nmap ]c :IPythonCellNextCell<CR>


" map <F9> and <F10> to insert a cell header tag above/below and enter insert mode
nmap <F9> :IPythonCellInsertAbove<CR>a
nmap <F10> :IPythonCellInsertBelow<CR>a

" also make <F9> and <F10> work in insert mode
imap <F9> <C-o>:IPythonCellInsertAbove<CR>
imap <F10> <C-o>:IPythonCellInsertBelow<CR>

nmap <localleader>r :SlimeSend1 %run test.py<CR>

"------------------------------------------------------------------------------
" tab navigation
"------------------------------------------------------------------------------
" tab navigation: Alt or Ctrl+Shift may not work in terminal:
" http://vim.wikia.com/wiki/Alternative_tab_navigation
" Tab navigation like Firefox: only 'open new tab' works in terminal
" nnoremap <C-t>     :tabnew<CR>
" inoremap <C-t>     <Esc>:tabnew<CR>

" N.B.: below bindings conflict with tmux window bindings
" move to the previous/next tabpage.
" nnoremap <C-k> gT
" nnoremap <C-j> gt
" Go to last active tab
" au TabLeave * let g:lasttab = tabpagenr()
" nnoremap <silent> <c-j> :exe "tabn ".g:lasttab<cr>
" vnoremap <silent> <c-j> :exe "tabn ".g:lasttab<cr>

let g:UltiSnipsSnippetDirectories = ['~/.local/share/nvim/plugged/ultisnips']

let g:markdown_folding = 1
let g:tex_fold_enabled = 1
let g:vimsyn_folding = 'af'
let g:xml_syntax_folding = 1
let g:javaScript_fold = 1
let g:sh_fold_enabled= 7
let g:ruby_fold = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:r_syntax_folding = 1
let g:rust_fold = 1
let g:php_folding = 1



set hidden
let g:vimtex_quickfix_mode = 0

" nnoremap <leader>ff <cmd>Telescope find_files<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" nnoremap <leader>p <cmd>lua require'telescope.builtin'.git_files(require('telescope.themes').get_ivy({}))<cr>
" nnoremap <localleader>p <cmd>lua require'telescope.builtin'.git_files(require('telescope.themes').get_ivy({}))<cr>
" nnoremap <leader>tf <cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_ivy({}))<cr>
" nnoremap <leader>tg <cmd>lua require'telescope.builtin'.live_grep(require('telescope.themes').get_ivy({}))<cr>
" nnoremap <leader>tb <cmd>lua require'telescope.builtin'.buffers({sort_lastused = true})<cr>
" nnoremap <leader>th <cmd>lua require'telescope.builtin'.help_tags(require('telescope.themes').get_ivy({}))<cr>
" nnoremap <leader>tk <cmd>lua require'telescope.builtin'.keymaps(require('telescope.themes').get_ivy({}))<cr>
" nnoremap <leader>tr <cmd>lua require'telescope.builtin'.oldfiles({include_current_session=true,cwd_only=true})<cr>
" nnoremap <leader>ta <cmd>lua require'telescope.builtin'.current_buffer_tags(require('telescope.themes').get_ivy({}))<cr>

nnoremap <localleader>js <cmd>lua require'telescope.builtin'.git_files()<cr>
nnoremap <localleader>s <cmd>lua require'telescope.builtin'.git_files()<cr>
nnoremap <localleader>jf <cmd>lua require'telescope.builtin'.find_files()<cr>
nnoremap <localleader>jg <cmd>lua require'telescope.builtin'.live_grep()<cr>

" like :Rg
nnoremap <localleader>jr <cmd>lua require'telescope.builtin'.grep_string{ search = '' }<cr>
" cleaned up Rg-like
nnoremap <localleader>jc <cmd>lua require'telescope.builtin'.grep_string{ shorten_path = true, word_match = "-w", only_sort_text = true, search = '' }<cr>
" with hidden files
nnoremap <localleader>j. <cmd>lua require'telescope.builtin'.grep_string{ vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '-.' }, shorten_path = true, word_match = "-w", only_sort_text = true, search = '' }<cr>

nnoremap <localleader>jb <cmd>lua require'telescope.builtin'.buffers({sort_mru = true})<cr>
nnoremap <localleader>e <cmd>lua require'telescope.builtin'.buffers({sort_mru = true})<cr>
nnoremap <localleader><tab> <cmd>lua require'telescope.builtin'.buffers({sort_mru = true})<cr>
nnoremap <localleader>jh <cmd>lua require'telescope.builtin'.help_tags()<cr>
nnoremap <localleader>jk <cmd>lua require'telescope.builtin'.keymaps()<cr>
nnoremap <localleader>jo <cmd>lua require'telescope.builtin'.oldfiles({include_current_session=true})<cr>
nnoremap <localleader>jd <cmd>lua require'telescope.builtin'.oldfiles({include_current_session=true,cwd_only=true})<cr>
nnoremap <localleader>ja <cmd>lua require'telescope.builtin'.current_buffer_tags()<cr>
nnoremap <localleader>jz <cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<cr>
nnoremap <localleader>jt <cmd>lua require'telescope.builtin'.tags()<cr>
nnoremap <localleader>jx <cmd>lua require'telescope.builtin'.treesitter()<cr>
nnoremap <localleader>jl <cmd>lua require'telescope.builtin'.lsp_document_symbols()<cr>
nnoremap <localleader>je <cmd>lua require("telescope").extensions.aerial.aerial()<cr>
nnoremap <localleader>ji <cmd>lua require'telescope.builtin'.commands()<cr>
nnoremap <localleader>jn <cmd>lua require'telescope.builtin'.command_history()<cr>
nnoremap <localleader>jv <cmd>lua require'telescope.builtin'.git_branches()<cr>
nnoremap <localleader>p <cmd>lua require("telescope").extensions.aerial.aerial()<cr>


set undofile
set undodir=~/.vim/undo

" noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR>
"             \<Cmd>lua require('hlslens').start()<CR>
" noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR>
"             \<Cmd>lua require('hlslens').start()<CR>
" noremap * *<Cmd>lua require('hlslens').start()<CR>
" noremap # #<Cmd>lua require('hlslens').start()<CR>
" noremap g* g*<Cmd>lua require('hlslens').start()<CR>
" noremap g# g#<Cmd>lua require('hlslens').start()<CR>
" use : instead of <Cmd>
nnoremap <silent> <leader>l :noh<CR>
" nnoremap <esc> :noh<return><esc>
" nnoremap <esc>^[ <esc>^[


nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xr <cmd>TroubleRefresh<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>

let g:pymode_lint_on_write = 0

" " Set the title of the Terminal to the currently open file
" function! SetTerminalTitle()
"     let titleString = expand('%:t')
"     if stridx(titleString, "neoterm") == -1
"         if len(titleString) > 0
"             let &titlestring = expand('%:t')
"             " this is the format iTerm2 expects when setting the window title
"             let args = "\033];".&titlestring."\007"
"             let cmd = 'silent !echo -e "'.args.'"'
"             execute cmd
"             redraw!
"         endif
"     endif
" endfunction
" autocmd BufEnter * call SetTerminalTitle()
" set title

" Quicker way to open command window
nnoremap ; :
xnoremap ; :
" nnoremap <C-/> ;
nnoremap q; q:

" autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%:t"))

" Write all buffers before navigating from Vim to tmux pane
" let g:tmux_navigator_save_on_switch = 2

nnoremap <silent> <leader><Space> :<C-U>StripWhitespace<CR>

" let g:vimspector_enable_mappings = 'HUMAN'
autocmd BufWinEnter *.py nmap <silent> <F5>:w<CR>:terminal python -m pdb '%:p'<CR>


nnoremap <localleader>= <cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>
nnoremap <localleader>- <cmd>lua require("harpoon.mark").add_file()<cr>
nnoremap <A-1> <cmd>lua require("harpoon.ui").nav_file(1)<cr>
nnoremap <A-2> <cmd>lua require("harpoon.ui").nav_file(2)<cr>
nnoremap <A-3> <cmd>lua require("harpoon.ui").nav_file(3)<cr>
nnoremap <A-4> <cmd>lua require("harpoon.ui").nav_file(4)<cr>
nnoremap <A-5> <cmd>lua require("harpoon.ui").nav_file(5)<cr>
nnoremap <A-6> <cmd>lua require("harpoon.ui").nav_file(6)<cr>
nnoremap <A-7> <cmd>lua require("harpoon.ui").nav_file(7)<cr>
nnoremap <A-8> <cmd>lua require("harpoon.ui").nav_file(8)<cr>
nnoremap <localleader>t1 <cmd>lua require("harpoon.term").gotoTerminal(1)<cr>

let g:peekaboo_prefix = '<localleader>'

" nnoremap f <C-d>
" nnoremap t <C-u>
" nnoremap <C-d> f
" nnoremap <C-u> t



" let g:NERDTreeHijackNetrw = 0
" let g:ranger_replace_netrw = 1

command! -bang -nargs=* RgWiki
            \ call fzf#vim#grep("rg -g '*.{wiki,md}' --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir':'~/0main/Syncthing/wiki'}), <bang>0)
nnoremap <localleader>fa :RgWiki<Cr>

command! -bang -nargs=* RgThesis
            \ call fzf#vim#grep("rg -g '*.{tex}' --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir':'~/1private/Github/phd-thesis'}), <bang>0)
nnoremap <localleader>fs :RgThesis<Cr>

" using vim-agriculture this would be equivalent
" nnoremap <localleader>fs :RgRaw -g '*.tex' '' ~/Github/phd-thesis<Cr>

nmap <localleader>/ :Rg<cr>
" hidden files search with vim-agriculture
nmap <localleader>. :RgRaw -. ''<cr>
" vmap <localleader>/ <Plug>RgRawVisualSelection<cr>
" nmap <localleader>* <Plug>RgRawWordUnderCursor<cr>


" create file if does not exist
noremap <leader>gf :e <cfile><cr>

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gVzv:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gVzv:call setreg('"', old_reg, old_regtype)<CR>


" Was once used for maintaining folds in latex and markdown files
" augroup AutoSaveGroup
"   autocmd!
"   " view files are about 500 bytes
"   " bufleave but not bufwinleave captures closing 2nd tab
"   " nested is needed by bufwrite* (if triggered via other autocmd)
"   " BufHidden for compatibility with `set hidden`
"   autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
"   autocmd BufWinEnter ?* silent! loadview
" augroup end
" set viewoptions=folds,cursor
" set sessionoptions=folds


" for autocorrect
highlight AutocorrectGood ctermfg=Green guifg=Green gui=undercurl


" testing better resizing keys
noremap <silent> <A-.> :vertical resize +10<CR>
noremap <silent> <A-n> :vertical resize -10<CR>
noremap <silent> <A-m> :resize +10<CR>
noremap <silent> <A-,> :resize -10<CR>


" repeatable motions
map <A-h> <Plug>RepeatMotionLeft
map <A-k> <Plug>RepeatMotionUp
map <A-j> <Plug>RepeatMotionDown
map <A-l> <Plug>RepeatMotionRight

map <localleader>rh <Plug>RepeatMotionLeft
map <localleader>rk <Plug>RepeatMotionUp
map <localleader>rj <Plug>RepeatMotionDown
map <localleader>rl <Plug>RepeatMotionRight

let g:nvim_tree_show_icons = {
            \   'git': 1,
            \   'folders': 1,
            \   'files': 1,
            \   'folder_arrows': 1,
            \ }

let g:nvim_tree_icons = {
            \  'default': "",
            \  'symlink': "",
            \  'git': {
            \    'unstaged': "",
            \    'staged': "S",
            \    'unmerged': "",
            \    'renamed': "➜",
            \    'deleted': "",
            \    'untracked': "U",
            \    'ignored': "◌",
            \  },
            \  'folder': {
            \    'default': "",
            \    'open': "",
            \    'empty': "",
            \    'empty_open': "",
            \    'symlink': "",
            \  },
            \}

ca tn tabnew
ca th tabp
ca tl tabn
ca dn !dolphin --select


""""""""""""""""""""""""""""
" Ranger style marks command
"
""""""""""""""""""""""""""""
function! Marks()
    marks
    echo('Mark: ')

    " getchar() - prompts user for a single character and returns the chars
    " ascii representation
    " nr2char() - converts ASCII `NUMBER TO CHAR'

    let s:mark = nr2char(getchar())
    " remove the `press any key prompt'
    redraw

    " build a string which uses the `normal' command plus the var holding the
    " mark - then eval it.
    execute "normal! '" . s:mark
endfunction

nnoremap <localleader>' :call Marks()<CR>


" let g:ale_virtualtext_cursor = 1
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\   'tex': ['prettier'],
\}
let g:ale_linters = {
\   'python': [''],
\}

let g:sneak#label = 1
let g:sneak#s_next = 1


" nmap <localleader>gi <Plug>(grammarous-open-info-window)
" nmap <localleader>gn <Plug>(grammarous-move-to-next-error)
" nmap <localleader>gf <Plug>(grammarous-fixit)
" nmap <localleader>gp <Plug>(grammarous-move-to-previous-error)
" nmap <localleader>gw <Plug>(grammarous-close-info-window)
" map <localleader>gc :GrammarousCheck<cr>
" nmap <localleader>gg <Plug>(operator-grammarous)


" augroup autosave
"     autocmd!
"     autocmd BufRead * if &filetype == "" | setlocal ft=text | endif
"     autocmd FileType *.wiki autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | silent write | endif
" augroup END



if has('mac')
    autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankRegister +' | endif
elseif has('unix')
    autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister "' | endif
endif

" highlight occurrences
" Put <enter> to work too! Otherwise <enter> moves to the next line, which we can
" already do by pressing the <j> key, which is a waste of keys!
" Be useful <enter> key!:
nnoremap <silent> <localleader><return> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>

" 'edit alternate file' convenience mapping
nnoremap <BS> <C-^>

" black on save (catch error E790 which is when saved right after undo)
augroup prettier_on_save
  autocmd!
  au BufWritePre *.py,*.jsx,*.tsx,*.js,*.ts try | undojoin | Neoformat | catch /E790/ | Neoformat | endtry
augroup end

let g:neoformat_enabled_javascriptreact = ['prettier']
let g:neoformat_enabled_typescriptreact = ['prettier']
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_python = ['black']

let g:gutentags_define_advanced_commands=1

silent! iunmap <buffer> <Tab>

let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
        \ 'C:constant',
        \ 'G:generator',
        \ 'a:alias',
        \ 'c:class',
        \ 'e:enumerator',
        \ 'f:function',
        \ 'g:enum',
        \ 'i:interface',
        \ 'm:method',
        \ 'n:namespace',
        \ 'p:property',
        \ 'v:variable',
  \ ]
\ }


let g:tagbar_type_javascriptreact = {
 \ 'ctagstype': 'javascript',
 \ 'kinds': [
       \ 'A:array',
       \ 'P:property',
       \ 'T:tags',
       \ 'O:objects',
       \ 'I:imports',
       \ 'E:exports',
       \ 's:styled components',
       \ 'C:constant',
       \ 'G:getter',
       \ 'M:field',
       \ 'S:setter',
       \ 'c:class',
       \ 'f:function',
       \ 'g:generator',
       \ 'm:method',
       \ 'p:property',
       \ 'v:variable',
 \ ]}

let g:tagbar_type_typescriptreact = {
 \ 'ctagstype': 'typescript',
 \ 'kinds': [
        \ 'C:constant',
        \ 'G:generator',
        \ 'a:alias',
        \ 'c:class',
        \ 'e:enumerator',
        \ 'f:function',
        \ 'g:enum',
        \ 'i:interface',
        \ 'm:method',
        \ 'n:namespace',
        \ 'p:property',
        \ 'v:variable',
  \ ]}


" recommended gutentags options from https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '.next',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ 'wandb',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]

" below options seem to create unneccessary extra tags files
" let g:gutentags_add_default_project_roots = 1
" let g:gutentags_project_root = ['package.json', '.git']

let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')

let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ '--langmap=TypeScript:+.tsx -R',
      \ ]


" gh copy :GetCurrentBranchLink then: (a) :OscYankRegister + or (b) tty-copy <C-prefix ]> in tmux
map <localleader>gh :GetCurrentBranchLink<CR><Bar> :OSCYankRegister +<CR>:echo @+<CR>
" link to current file in github, or just branch link if not in a file like startify
map <localleader>gb :GBrowse!<CR>:echo @+<CR>

nmap <leader>e :AerialToggle<CR>

" free bindings
" localleader s/e
" localleader tab
"
nmap <localleader>n :Neoformat<CR>
" nmap <localleader>xc :ChatGPT<CR>

nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
nnoremap <silent> <F4> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><F4> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
tnoremap <silent> <F4> <C-\><C-n><Cmd>exe v:count1 . "ToggleTerm"<CR>

nnoremap <localleader>] :Lspsaga  goto_definition<CR>
nnoremap <leader>] :Lspsaga  peek_definition<CR>

cnoremap <A-b> <C-Left>
cnoremap <A-f> <C-Right>
cnoremap <A-e> <End>

autocmd ColorScheme * lua require('leap').init_highlight(true)

command! Colo silent !zsh -c 'source $HOME/.zshrc; colo'

" triple backtick for code blocks using vim-surround
let b:surround_{char2nr('e')} = "```\r```"

" copy buffer content
map <localleader>vx :1,$-1yank +<CR><Bar> :OSCYankRegister +<CR><Bar> :q!<CR>


" no whitespace in terminal
augroup vimrc
  autocmd TermOpen * :DisableWhitespace
augroup END

set shada=!,'1000,<500,s100,h

" keybinding for undo tree
let g:undotree_SetFocusWhenToggle = 1
nnoremap <localleader>ut :UndotreeToggle<CR>
nnoremap <localleader>um :MundoShow<CR>

" bindings from primagen
nnoremap <localleader>a/ :%s/<C-r><C-w>//gI<Left><Left><Left>
xnoremap <localleader>ap "_dP
xnoremap <localleader>ad "_d
nnoremap <localleader>ad "_d
nnoremap <localleader>mr :CellularAutomaton make_it_rain<CR>


nnoremap <localleader>h :WhichKey<CR>

augroup AutoWikiHeader
    autocmd!
    autocmd bufnewfile */diary/*.wiki execute "so ~/dotfiles/headers/wiki_header.txt" | execute "silent! %s/%DATE%/".escape(fnamemodify(bufname('%'), ':t:r'), '/')
augroup END

