set nocompatible              " be iMproved, required
filetype off                  " required

" vim-plug---------------------------------------- {{{ 
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
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }
Plug 'davidhalter/jedi-vim'
Plug 'w0rp/ale'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'nathanaelkane/vim-indent-guides' 
Plug 'ryanoasis/vim-devicons'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'


" Initialize plugin system
call plug#end()

" }}} 
" General Settings ---------------------------------------- {{{ 
"
filetype plugin indent on
syntax enable

set incsearch
set hlsearch
set nowrap                      " don't wrap lines
set tabstop=4                   " a tab is four spaces
set softtabstop=4               " when hitting <BS>, this is an error now there is no completion pretend like a tab is removed, even if spaces
set expandtab                   " expand tabs by default ( overloadable per file type later,)
set shiftwidth=4                " number of spaces to use for autoindenting
set smarttab
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
set title
set hidden
set splitbelow
set splitright
set wildmenu
set wildmode=longest:full,list:full


" leader
let mapleader = "\<Space>"

" }}} 
" Plugin Configuration ---------------------------------------- {{{ 
"
" colorscheme ------------------------------------------------ {{{
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'soft'

" }}}
" airline ---------------------------------------- {{{ 
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" }}}
" vim-which-key---------------------------------------- {{{ 
"
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
set timeoutlen=1000

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" }}}
" fzf-vim ---------------------------------------- {{{
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
nmap <Leader>r :Tags<CR>

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

" }}}
" NERDTree ---------------------------------------- {{{

" autocmd bufenter * if ( winnr( "$",) == 1 && exists( b:NERDTree",) && b:NERDTree.isTabTree(),) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeIgnore=['.git', '.DS_Store', '\.swp$', '\.swo$', '\.pyc$', '\.pyo$']

" }}}
" nerdtree-git-plugin ---------------------------------------- {{{

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
" }}}
" vim-indent-guides ---------------------------------------- {{{ 
"
let g:indent_guides_enable_on_vim_startup = 1

let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" }}}
" deopulate ---------------------------------------- {{{ 

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_',
            \ 'disabled_syntaxes', ['Comment', 'String'])

call deoplete#custom#option('sources', {
    \ 'python': ['LanguageClient'],
\})
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" deoplete tab-complete
"let g:deoplete#disable_auto_complete = 1
let b:deoplete_disable_auto_complete=1

imap <silent><expr><Tab> pumvisible() ? "\<Down>"
	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (<SID>is_whitespace() ? "\<Tab>"
    \ : deoplete#manual_complete()))

smap <silent><expr><Tab> pumvisible() ? "\<Down>"
	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : deoplete#manual_complete()))

inoremap <expr><S-Tab> pumvisible() ? "\<Up>" : "\<C-h>"

"inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
"imap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>\<Plug>AutoPairsReturn"

"   }}} deoplulate
" LanguageClient-neovim ---------------------------------------- {{{ 

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'python': ['/usr/local/bin/pyls'],
    \ }
"     'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"     'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
"     'javascript.jsx': ['tcp://127.0.0.1:2089'],

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" }}} 
" vim-jedi ---------------------------------------- {{{ 

let g:jedi#popup_on_dot = 0
let g:jedi#completions_enabled = 0 " using deoplete instead

let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
" let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
" let g:jedi#completions_command = "<C-Space>"
" let g:jedi#rename_command = "<leader>r"

" }}} 
" ale ---------------------------------------- {{{ 

" run linter only on save
" let g:ale_lint_on_text_changed = 'never'

let g:ale_linters = {
            \   'python': ['flake8']
            \}

let g:ale_fixers = {
            \    'python': ['yapf']
            \}

let g:ale_fix_on_save = 1

" }}}
" vim-fugitive ---------------------------------------- {{{ 

nmap <leader>gb :Gblame<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gc :Gcommit -v<cr>
nmap <leader>ga :Git add -p<cr>
nmap <leader>gm :Gcommit --amend<cr>
nmap <leader>gp :Gpush<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gw :Gwrite<cr>

" }}}
" vim-devicons ---------------------------------------- {{{
" loading the plugin
let g:webdevicons_enable = 1

let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
" let g:webdevicons_conceal_nerdtree_brackets = 1

" }}}
" tagbar ---------------------------------------- {{{

map <leader>tg :TagbarToggle<CR>
 
let g:tagbar_sort=0
let g:tagbar_right = 1
let g:tagbar_autoclose = 1
let g:tagbar_width = 50
let g:tagbar_autofocus = 1
let g:tagbar_compact = 0
let g:tagbar_iconchars = ['▸', '▾']

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" }}}
" gutentags---------------------------------------- {{{  

" if executable('ctags')
"   call add(g:gutentags_modules, 'ctags')
" endif

" }}}
" }}}
" Mappings ---------------------------------------- {{{ 

" clear search highlight
nnoremap <silent> // :noh<cr>

" Toggle line numbers
nnoremap <leader>tn :setlocal number!<cr>

" toggle highlighting the cursor line
nnoremap <leader>tc :set cursorline!<cr> 

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
" }}}

" ctags
set tags=./tags;/

" vim:fdm=marker foldlevel=0
