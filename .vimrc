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
Plugin 'joshdick/onedark.vim'
Plugin 'drewtempelmeyer/palenight.vim'

Plugin 'ludovicchabant/vim-gutentags'
Plugin 'junegunn/goyo.vim'
Plugin 'enricobacis/vim-airline-clock'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'jupyter-vim/jupyter-vim'
Plugin 'sillybun/vim-repl'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


let g:ycm_path_to_python_interpreter='/usr/local/bin/python3'

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" Enable folding
set foldmethod=indent
set foldlevel=99
"Enable folding with the spacebar
"nnoremap <space> za

" open files with ctrl-p
nnoremap <leader>f :Files<cr>

au BufNewFile,BufRead *.py,*.java,*.cpp,*.c,*.cs,*.rkt,*.h,*.html
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

set encoding=utf-8

syntax on

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

let mapleader = " "
let maplocalleader = "\\"

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


" Latex
autocmd Filetype tex setl updatetime=1
let g:livepreview_previewer = 'open -a Preview'

nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

nnoremap <C-S-q> :tabprevious<CR>
nnoremap <C-q> :tabnext<CR>


if !exists('g:lasttab')
  let g:lasttab = 1
endif
nmap <leader><Tab> :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

nnoremap <ScrollWheelUp> <C-Y>
nnoremap <ScrollWheelDown> <C-E>

map <C-s> <Plug>(easymotion-s)


let g:vimtex_view_method = 'skim'


let g:pencil#conceallevel = 0     " 0=disable, 1=one char, 2=hide char, 3=hide all (def)
let g:pencil#concealcursor = 'c'  " n=normal, v=visual, i=insert, c=command (def)
let g:pencil#autoformat = 1      " 0=disable, 1=enable (def)



let g:goyo_height = 100
let g:goyo_linenr = 1




let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:ycm_autoclose_preview_window_after_completion=0
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
