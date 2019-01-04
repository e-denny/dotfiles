set nocompatible              " be iMproved, required
filetype off                  " required

" {{{ vim-plug
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'liuchengxu/vim-which-key'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Initialize plugin system
call plug#end()
" }}} vim-plug

filetype plugin indent on
syntax enable

" {{{ General Settings
set incsearch
set hlsearch
set nowrap                      " don't wrap lines
set tabstop=4                   " a tab is four spaces
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set expandtab                   " expand tabs by default (overloadable per file type later)
set shiftwidth=4                " number of spaces to use for autoindenting
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent                  " always set autoindenting on
set copyindent                  " copy the previous indentation on autoindenting
set number                      " always show line numbers
set showmatch                   " set show matching parenthesis
set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
                                "    case-sensitive otherwise
set smarttab                    " insert tabs on the start of a line according to
                                "    shiftwidth, not tabstop
set scrolloff=4                 " keep 4 lines off the edges of the screen when scrolling
set visualbell                  " don't beep
set noerrorbells                " don't beep
set showcmd

set modelines=2

" }}} General Settings 

" leader
let mapleader = "\<Space>"

" {{{ Plugins

"   {{{ colorscheme
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'soft'
"   }}} colorscheme

"   {{{ airline
let g:airline_powerline_fonts = 1

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
"   }}} airline
"
"   {{{ vim-which-key
"
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
set timeoutlen=1000

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

"   }}} vim-which-key

"   {{{ fzf-vim
"
" Hide statusline of terminal buffer
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>fc :Colors<CR>
nnoremap <silent> <Leader>fb :Buffers<CR>
nnoremap <silent> <Leader>fl :Lines<CR>
nnoremap <silent> <Leader>fa :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>fm :Marks<CR>

"    }}} fzf-vim

"   {{{ NERDTree

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

"   }}} NERDTree

" }}} Plugins

" Toggle line numbers
nnoremap <leader>tn :setlocal number!<cr>

" toggle highlighting the cursor line
nnoremap <leader>tc :set cursorline!<cr> 

nmap ; :Buffers<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>r :Tags<CR>

" window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Circular windows navigation
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W

" Buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" Toggle NERD Tree
nnoremap <leader>tt :NERDTreeToggle<cr>

" ctags
set tags=./tags;/

" vim:fdm=marker foldlevel=0
