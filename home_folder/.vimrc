set nocompatible              " be iMproved, required
filetype off                  " required

" Plugin management now handled by lazy.nvim in init.lua

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

let mapleader = ","
let maplocalleader = " " " used to be \\

set splitbelow
set splitright

" Enable folding
set foldmethod=indent
set foldlevel=99

" File-specific indentation
au BufNewFile,BufRead *.py,*.java,*.cpp,*.c,*.cs,*.rkt,*.h,*.html
            \ set tabstop=4 |
            \ set softtabstop=4 |
            \ set shiftwidth=4 |
            \ set textwidth=89 |
            \ set expandtab |
            \ set autoindent |
            \ set fileformat=unix

" Default indentation
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

set laststatus=2
set signcolumn=yes

" True color support for tmux
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors

" Platform-specific shell settings
if has("win32")
    set shell=powershell
    set shellcmdflag=-command
    set shellquote=\"
    set shellxquote=
endif

" Fix for :Rg and Ranger preview
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

" Basic editor settings
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

" Tab navigation
if !exists('g:lasttab')
    let g:lasttab = 1
endif
nmap <leader><Tab> :exe "tabn ".g:lasttab<CR>
nmap <localleader><Tab> <C-^>
au TabLeave * let g:lasttab = tabpagenr()

nnoremap <ScrollWheelUp> <C-Y>
nnoremap <ScrollWheelDown> <C-E>

" LaTeX configuration
if has('mac')
    let g:vimtex_view_method = 'skim'
elseif has('unix')
    let g:latex_view_general_viewer = 'zathura'
    let g:vimtex_view_method = "zathura"
endif
let g:vimtex_syntax_conceal_disable = 1
let g:vimtex_fold_enabled = 1
let g:vimtex_quickfix_mode = 0

function! WC()
    let filename = expand("%")
    let cmd = "./texcount.pl -inc " . filename
    let result = system(cmd)
    echo result
endfunction

command WC call WC()

" Goyo settings
let g:goyo_width = 85

" Terminal settings
tnoremap <C-b> <C-\><C-n>
let g:neoterm_autoscroll = 1

" Convenience mappings
nnoremap <C-S-s> :w<cr>
inoremap <C-S-s> <Esc>:w<cr>

" Quick edit
nnoremap <localleader>ve :edit <C-r>=fnameescape(resolve(expand('~/.vimrc')))<CR><CR>
nnoremap <localleader>vz :edit <C-r>=fnameescape(resolve(expand('$ZDOTDIR/.zshrc')))<CR><CR>
nnoremap <localleader>vl :edit <C-r>=fnameescape(resolve(expand('$ZDOTDIR/dotfiles/.zshrc_local')))<CR><CR>
nnoremap <localleader>vs :source <C-r>=fnameescape(resolve(expand('~/.vimrc')))<CR><CR>
nnoremap <localleader>vp :PlugInstall<cr>
nnoremap <localleader>vk :!python ~/dotfiles/home_folder_macos/.config/karabiner/karabiner-template/generate_karabiner.py<cr>

nnoremap <localleader>w :w<cr>
nnoremap <localleader>q :quit<cr>
imap <C-k> <Esc>:wq<CR>
nnoremap <D-v> "+p
inoremap <D-v> <C-r>+

nnoremap <localleader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <leader>qf :copen<cr>

" Insert timestamp
nmap <F3> i<C-R>=strftime("%Y-%m-%d")<CR><Esc>
imap <F3> <C-R>=strftime("%Y-%m-%d")<CR>

" VimWiki specific mappings
autocmd FileType vimwiki map <buffer> <C-h> <Plug>VimwikiDiaryPrevDay<CR>
autocmd FileType vimwiki map <buffer> <C-l> <Plug>VimwikiDiaryNextDay<CR>

" Slime configuration
let g:slime_target = 'tmux'
let g:slime_bracketed_paste = 1
let g:slime_cell_delimiter = "# %%"
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': ':.2' }
let g:slime_dont_ask_default = 1

" IPython configuration
autocmd FileType python map <buffer> [g :IPythonCellPrevCell<CR>
autocmd FileType python map <buffer> ]g :IPythonCellNextCell<CR>

" Folding settings for various languages
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
set undofile
set undodir=~/.vim/undo

" Clear search highlights
nnoremap <silent> <leader>l :noh<CR>

" FZF custom commands
command! -bang -nargs=* RgWiki
            \ call fzf#vim#grep("rg -g '*.{wiki,md}' --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir':'~/0main/Syncthing/wiki'}), <bang>0)

command! -bang -nargs=* RgThesis
            \ call fzf#vim#grep("rg -g '*.{tex}' --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir':'~/1private/Github/phd-thesis'}), <bang>0)

" Search for selected text, forwards or backwards
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

" Window resizing
noremap <silent> <A-.> :vertical resize +10<CR>
noremap <silent> <A-n> :vertical resize -10<CR>
noremap <silent> <A-m> :resize +10<CR>
noremap <silent> <A-,> :resize -10<CR>

" Command abbreviations
ca tn tabnew
ca th tabp
ca tl tabn
ca dn !dolphin --select

" Ranger style marks command
function! Marks()
    marks
    echo('Mark: ')
    let s:mark = nr2char(getchar())
    redraw
    execute "normal! '" . s:mark
endfunction

" OSC yank for remote sessions
if has('mac')
    autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankRegister +' | endif
elseif has('unix')
    autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister "' | endif
endif

" Highlight word under cursor
nnoremap <silent> <localleader><return> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>

" Edit alternate file convenience mapping
nnoremap <BS> <C-^>

" Autocorrect highlighting
highlight AutocorrectGood ctermfg=Green guifg=Green gui=undercurl

" Quicker way to open command window
nnoremap ; :
xnoremap ; :
nnoremap q; q:

" Python debugging
autocmd BufWinEnter *.py nmap <silent> <F5>:w<CR>:terminal python -m pdb '%:p'<CR>

" Create file if does not exist
noremap <leader>gf :e <cfile><cr>

" No whitespace in terminal
augroup vimrc
  autocmd TermOpen * silent! DisableWhitespace
augroup END

set shada=!,'1000,<500,s100,h

" VimWiki auto header
augroup AutoWikiHeader
    autocmd!
    autocmd bufnewfile */diary/*.wiki execute "so ~/dotfiles/headers/wiki_header.txt" | execute "silent! %s/%DATE%/".escape(fnamemodify(bufname('%'), ':t:r'), '/')
augroup END

" Custom color command
command! Colo silent !zsh -c 'source $HOME/.zshrc; colo'
