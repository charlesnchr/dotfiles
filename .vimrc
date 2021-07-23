set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'tpope/vim-surround'
Plugin 'Raimondi/delimitMate'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-syntastic/syntastic'
Plugin 'ryanoasis/vim-devicons'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'rafi/awesome-vim-colorschemes'
Plugin 'preservim/nerdcommenter'
Plugin 'preservim/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'kien/ctrlp.vim'
Plugin 'aserebryakov/vim-todo-lists'
Plugin 'freitass/todo.txt-vim'
" markdown syntax
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
" writing
Plugin 'reedes/vim-pencil'
Plugin 'xuhdev/vim-latex-live-preview'
Plugin 'lervag/vimtex'
Plugin 'easymotion/vim-easymotion'
Plugin 'xolox/vim-colorscheme-switcher'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-notes'
" styling
Plugin 'joshdick/onedark.vim'
Plugin 'drewtempelmeyer/palenight.vim'
" misc 
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'junegunn/goyo.vim'
Plugin 'enricobacis/vim-airline-clock'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'jupyter-vim/jupyter-vim'
Plugin 'sillybun/vim-repl'
Plugin 'vimwiki/vimwiki'
Plugin 'unblevable/quick-scope'
Plugin 'kana/vim-textobj-user'
Plugin 'rbonvall/vim-textobj-latex'
Plugin 'tools-life/taskwiki'
Plugin 'mhinz/vim-startify'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'junegunn/gv.vim'
Plugin 'voldikss/vim-floaterm'
Plugin 'mg979/vim-visual-multi'
Plugin 'mattn/calendar-vim'
Plugin 'python-mode/python-mode'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let mapleader = ","
let maplocalleader = " " " used to be \\

let g:ycm_path_to_python_interpreter='/usr/local/bin/python3'

set splitbelow
set splitright
set startofline " only relevant for nvim as otherwise default

" Enable folding
set foldmethod=indent
set foldlevel=99
"Enable folding with the spacebar
"nnoremap <space> za

" open files with ctrl-p
nnoremap <leader>f :Files<cr>
nnoremap <leader>b :Buffer<cr>
nnoremap <leader>h :History<cr>

au BufNewFile,BufRead *.py,*.java,*.cpp,*.c,*.cs,*.rkt,*.h,*.html
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

" Reopen the last edited position in files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set encoding=utf-8

syntax on

" for vimwiki
filetype plugin on
let g:vimwiki_list = [{
  \ 'path': '$HOME/0main/wiki',
  \ 'template_path': '$HOME/0main/wiki/templates',
  \ 'template_default': 'default',
  \ 'template_ext': '.html'}]


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
set background=dark

if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

colorscheme palenight

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
let g:pencil#conceallevel = 0     " 0=disable, 1=one char, 2=hide char, 3=hide all (def)
let g:pencil#concealcursor = 'c'  " n=normal, v=visual, i=insert, c=command (def)
let g:pencil#autoformat = 0      " 0=disable, 1=enable (def)
let g:goyo_height = 100
let g:goyo_linenr = 1


" autocomplete
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:ycm_autoclose_preview_window_after_completion=0
map <localleader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
" for latex
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme



" programming
nnoremap <localleader>r :REPLToggle<Cr>
nnoremap <localleader>e :REPLSendSession<Cr>
nnoremap <silent> <F9> :FloatermNew<CR>
tnoremap <silent> <F9> <C-\><C-n>:FloatermNew<CR>
nnoremap <silent> <F10> :FloatermPrev<CR>
tnoremap <silent> <F10> <C-\><C-n>:FloatermPrev<CR>
nnoremap <silent> <F11> :FloatermNext<CR>
tnoremap <silent> <F11> <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <F12> :FloatermToggle<CR>
tnoremap <silent> <F12> <C-\><C-n>:FloatermToggle<CR>

" -------------------
" NAVIGATION
" -------------------
" Ctrl-]/[ inserts line below/above
nnoremap <A-h> :<CR>mzO<Esc>`z:<CR>
nnoremap <A-l> :<CR>mzo<Esc>`z:<CR>

" Move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" buffer cycle
:nnoremap <A-q> :bnext<CR>
:nnoremap <A-S-q> :bprevious<CR>

" -------------------
" CONVENIENCE
" -------------------
" quick save 
nnoremap <A-s> :w<cr>
inoremap <A-s> <Esc>:w<cr>

" quick edit
nnoremap <localleader>ve :e ~/.vimrc<cr>
nnoremap <localleader>vs :source ~/.vimrc<cr>
nnoremap <localleader>vp :PluginInstall<cr>
nnoremap <localleader>w :w<cr>
nnoremap <localleader>q :close<cr>
nnoremap <localleader>0 :Startify<cr>


let g:startify_bookmarks = [
            \ { 'p': '~/0main/0phd' },
            \ { 'c': '~/0main/0phd/ccRestore' },
            \ { 'g': '~/GitHub' },
            \ '~/0main',
            \ ]


hi VimwikiHeader1 guifg=#00FF03
hi VimwikiHeader2 guifg=#83ebd3
hi VimwikiHeader3 guifg=#83c8eb

" Insert timestamp
nmap <F3> i<C-R>=strftime("%Y-%m-%d")<CR><Esc>
"imap <F3> <C-R>=strftime("%Y-%m-%d %H:%M %p")<CR>
imap <F3> <C-R>=strftime("%Y-%m-%d")<CR>

