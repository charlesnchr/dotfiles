set nocompatible              " be iMproved, required
filetype off                  " required

"lua require('lua-init')

"nmap <Leader>wn <Plug>VimwikiNextLink

"set the runtime path to include Vundle and initialize
call plug#begin()

" plugin on GitHub repo
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
" Plug 'Raimondi/delimitMate'
Plug 'vim-airline/vim-airline'
Plug 'vim-syntastic/syntastic'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline-themes'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
"Plug 'ervandew/supertab'
Plug 'kien/ctrlp.vim'
"Plug 'aserebryakov/vim-todo-lists'
"Plug 'freitass/todo.txt-vim'
" markdown syntax
Plug 'godlygeek/tabular'
Plug 'Konfekt/FastFold'
" writing
"Plug 'reedes/vim-pencil'
Plug 'xuhdev/vim-latex-live-preview'
Plug 'lervag/vimtex'
Plug 'easymotion/vim-easymotion'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'xolox/vim-misc'
"Plug 'xolox/vim-notes'
" styling
Plug 'joshdick/onedark.vim'
Plug 'drewtempelmeyer/palenight.vim'
" misc 
Plug 'ludovicchabant/vim-gutentags'
Plug 'junegunn/goyo.vim'
Plug 'enricobacis/vim-airline-clock'
" Plug 'ycm-core/YouCompleteMe'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vimwiki/vimwiki'
"Plug 'unblevable/quick-scope'
Plug 'kana/vim-textobj-user'
Plug 'rbonvall/vim-textobj-latex'
Plug 'tools-life/taskwiki'
Plug 'mhinz/vim-startify'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/gv.vim'
Plug 'voldikss/vim-floaterm'
Plug 'mg979/vim-visual-multi'
Plug 'mattn/calendar-vim'
Plug 'python-mode/python-mode'
Plug 'tpope/vim-unimpaired'
Plug 'sillybun/vim-repl'
Plug 'jpalardy/vim-slime'
Plug 'hanschen/vim-ipython-cell'
Plug 'jupyter-vim/jupyter-vim'
Plug 'mikelue/vim-maven-plugin'
Plug 'kevinhwang91/nvim-hlslens'

if has('mac')
  Plug 'alok/notational-fzf-vim'
"elseif has('unix')
endif

Plug 'kassio/neoterm'
Plug 'preservim/tagbar'

Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

Plug 'rupa/v'
Plug 'ojroques/vim-oscyank'
Plug 'junegunn/vim-peekaboo'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kevinhwang91/nvim-bqf'

Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }

" Have not added any parsers yet
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'sbdchd/neoformat'
Plug 'simnalamburt/vim-mundo'
Plug 'liuchengxu/vista.vim' 
Plug 'tpope/vim-commentary'
Plug 'folke/which-key.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'williamboman/nvim-lsp-installer'


call plug#end()


let mapleader = ","
let maplocalleader = " " " used to be \\

set splitbelow
set splitright

" Enable folding
set foldmethod=indent
set foldlevel=99
"Enable folding with the spacebar
nnoremap <tab> za
"let g:vim_markdown_folding_disabled = 1
"let g:vim_markdown_folding_style_pythonic = 1


" open files with ctrl-p
nnoremap <localleader>f :Files<cr>
nnoremap <localleader>vv :Buffer<cr>
nnoremap <localleader>h :History<cr>
nnoremap <localleader>aa :CtrlPBufTag<cr>
nnoremap <localleader>as :CtrlPBuffer<cr>
nnoremap <localleader>ad :CtrlPMRUFiles<cr>
nnoremap <localleader>af :CtrlPLine<cr>


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

"au BufNewFile,BufRead */wiki/*
      "\ SoftPencil


" Reopen the last edited position in files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set encoding=utf-8

syntax on
filetype plugin on

" platform dependent
if has('mac')
  let g:ycm_path_to_python_interpreter='/Users/cc/anaconda3/bin/python'

  " for vimwiki
  let g:vimwiki_list = [{
    \ 'path': '$HOME/0main/wiki',
    \ 'template_path': '$HOME/0main/wiki/templates',
    \ 'template_default': 'default',
    \ 'template_ext': '.html'}]
  let g:nv_search_paths = ['~/0main/wiki']
  let g:startify_bookmarks = [
    \ { 'p': '~/0main/0phd' },
    \ { 'c': '~/0main/0phd/ccRestore' },
    \ { 'g': '~/GitHub' },
    \ '~/0main',
    \ ]
elseif has('unix')
  let g:ycm_path_to_python_interpreter='/home/cc/miniconda3/bin/python'
  let g:startify_bookmarks = [
    \ { 'g': '~/GitHub' }]


" air-line
let g:airline_theme = 'onedark'
let g:airline#extensions#tabline#enabled = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

set laststatus=2
set showtabline=2

" true colours
colorscheme palenight
set termguicolors

set nu rnu " relative line numbering
set clipboard=unnamed " public copy/paste register

set ignorecase
set smartcase

set mouse=a

" nerdtree
nnoremap <leader>nn :NERDTreeFocus<CR>
nnoremap <leader>nc :NERDTree<CR> 
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

nmap <F2> :TagbarOpenAutoClose<CR>
nmap <leader>tt :TagbarToggle<CR>
nmap <leader>to :TagbarOpenAutoClose<CR>


nnoremap <C-S-q> :tabprevious<CR>
nnoremap <C-q> :tabnext<CR>


if !exists('g:lasttab')
  let g:lasttab = 1
endif
nmap <leader><Tab> :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

nnoremap <ScrollWheelUp> <C-Y>
nnoremap <ScrollWheelDown> <C-E>

map <localleader>s <Plug>(easymotion-s)

" latex
let g:vimtex_view_method = 'skim'
let g:vimtex_compiler_latexmk = { 
        \ 'executable' : 'latexmk',
        \ 'options' : [ 
        \   '-xelatex',
        \   '-interaction=nonstopmode',
        \ ],
        \}

function! WC()
    let filename = expand("%")
    let cmd = "./texcount.pl " . filename
    let result = system(cmd)
    echo result 
endfunction

command WC call WC()


" writing
"let g:pencil#conceallevel = 3     " 0=disable, 1=one char, 2=hide char, 3=hide all (def)
"let g:pencil#concealcursor = 'c'  " n=normal, v=visual, i=insert, c=command (def)
"let g:pencil#autoformat = 0      " 0=disable, 1=enable (def)
let g:goyo_width = 85
"let g:goyo_linenr = 1


" autocomplete
"let g:UltiSnipsExpandTrigger="<c-j>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"let g:ycm_autoclose_preview_window_after_completion=0
" map <localleader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
" for latex
"'mac')
  "let g:ycm_path_to_python_interpreter='/Users/cc/anaconda3/bin/python'

  " for vimwikif !exists('g:ycm_semantic_triggers')
    "let g:ycm_semantic_triggers = {}
"endif
" au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme

" let g:ycm_filetype_blacklist={'markdown':1,'notes': 1, 'unite': 1, 'tagbar': 1, 'pandoc':1, 'qf': 1 ,'text': 1, 'infolog': 1, 'mail': 1}



" programming
nnoremap <silent> <leader><leader><F12> :FloatermNew<CR>
tnoremap <silent> <leader><leader><F12> <C-\><C-n>:FloatermNew<CR>
nnoremap <silent> <F10> :FloatermPrev<CR>
tnoremap <silent> <F10> <C-\><C-n>:FloatermPrev<CR>
nnoremap <silent> <F11> :FloatermNext<CR>
tnoremap <silent> <F11> <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <F12> :FloatermToggle<CR>
tnoremap <silent> <F12> <C-\><C-n>:FloatermToggle<CR>
nnoremap <silent> <leader><F7> :Ttoggle<CR>
tnoremap <silent> <leader><F7> <C-\><C-n>:Ttoggle<CR>

" -------------------
" NAVIGATION
" -------------------

" bufmer cycle
:nnoremap <localleader><tab> :bnext<CR>
:nnoremap <localleader><S-tab> :bprevious<CR>

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
nnoremap <localleader>vp :PlugInstall<cr>
nnoremap <localleader>w :w<cr>
nnoremap <localleader>q :quit<cr>
nnoremap <localleader>x :close<cr>
nnoremap <localleader>0 :Startify<cr>
nnoremap <localleader>go :Goyo<cr>
nnoremap <localleader>cd :cd %:h<cr>


hi VimwikiHeader1 guifg=#00FF03
hi VimwikiHeader2 guifg=#83ebd3
hi VimwikiHeader3 guifg=#83c8eb
let g:vimwiki_global_ext = 0

" Insert timestamp
"imap <F3> <C-R>=strftime("%Y-%m-%d %H:%M %p")<CR>
nmap <F3> i<C-R>=strftime("%Y-%m-%d")<CR><Esc>
imap <F3> <C-R>=strftime("%Y-%m-%d")<CR>
nmap <F4> :! save_screenshot.sh ~/0main/wiki/images<CR>
imap <F4> <C-R>=strftime("%Y-%m-%d")<CR>

"let g:floaterm_wintype = 'split'
let g:floaterm_width = 0.8 
let g:floaterm_height = 0.8 


"let g:taskwiki_sort_orders={"T": "end-"}
"nmap <C-k> <Plug>VimwikiPrevLink
"nmap <C-j> <Plug>VimwikiNextLink

"let g:airline_section_x = '%{PencilMode()}'

vnoremap <leader>c :OSCYank<CR>

"------------------------------------------------------------------------------
" IPython  configuration
"------------------------------------------------------------------------------
" For Ipython plugin - Matlab bindings
" map <F5> to save and run script
nnoremap <F5> :w<CR>:IPythonCellRun<CR>
inoremap <F5> <C-o>:w<CR><C-o>:IPythonCellRun<CR>

" map <F6> to evaluate current cell without saving
nnoremap <F6> :IPythonCellExecuteCellVerbose<CR>
inoremap <F6> <C-o>:IPythonCellExecuteCellVerbose<CR>
"nnoremap <F6> :REPLSendSession<CR>
"inoremap <F6> <C-o>:REPLSendSession<CR>
let g:repl_program = {
			\	'python': ['ipython'],
			\	'default': ['bash']
			\	}


" map <F7> to evaluate current cell and jump to next cell without saving
nnoremap <F7> :IPythonCellExecuteCellVerboseJump<CR>
inoremap <F7> <C-o>:IPythonCellExecuteCellVerboseJump<CR>

augroup ipython_cell_highlight
    autocmd!
    autocmd ColorScheme * highlight IPythonCell ctermbg=238 guifg=darkgrey guibg=#444d56
augroup END

" map [c and ]c to jump to the previous and next cell header
nnoremap [c :IPythonCellPrevCell<CR>
nnoremap ]c :IPythonCellNextCell<CR>

" map <F9> and <F10> to insert a cell header tag above/below and enter insert mode
nmap <F9> :IPythonCellInsertAbove<CR>a
nmap <F10> :IPythonCellInsertBelow<CR>a

" also make <F9> and <F10> work in insert mode
imap <F9> <C-o>:IPythonCellInsertAbove<CR>
imap <F10> <C-o>:IPythonCellInsertBelow<CR>


"------------------------------------------------------------------------------
" slime configuration
"------------------------------------------------------------------------------
" always use tmux
let g:slime_target = 'vimterminal'

" fix paste issues in ipython
let g:slime_python_ipython = 1

let g:slime_cell_delimiter = "# %%"
nmap <leader>s <Plug>SlimeSendCell

" always send text to the top-right pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{right-of}' }
let g:slime_dont_ask_default = 1

"------------------------------------------------------------------------------
" tab navigation
"------------------------------------------------------------------------------
" tab navigation: Alt or Ctrl+Shift may not work in terminal:
" http://vim.wikia.com/wiki/Alternative_tab_navigation
" Tab navigation like Firefox: only 'open new tab' works in terminal
nnoremap <C-t>     :tabnew<CR>
inoremap <C-t>     <Esc>:tabnew<CR>
" move to the previous/next tabpage.
nnoremap <C-j> gT
nnoremap <C-k> gt
" Go to last active tab
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>


"let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/plugged/vim-snippets/UltiSnips']

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


nnoremap gb :ls<cr>:b<space>
set hidden
let g:vimtex_quickfix_mode = 0  


nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


call wilder#setup({'modes': [':', '/', '?']})

set undofile
set undodir=~/.vim/undo

noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR>
            \<Cmd>lua require('hlslens').start()<CR>
noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR>
            \<Cmd>lua require('hlslens').start()<CR>
noremap * *<Cmd>lua require('hlslens').start()<CR>
noremap # #<Cmd>lua require('hlslens').start()<CR>
noremap g* g*<Cmd>lua require('hlslens').start()<CR>
noremap g# g#<Cmd>lua require('hlslens').start()<CR>
" use : instead of <Cmd>
nnoremap <silent> <leader>l :noh<CR>
