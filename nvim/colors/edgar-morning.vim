" Name:         edgar-morning
" Description:  morning with 10% darker backgrounds
" Based on:     morning by Bram Moolenaar

set background=light

source $VIMRUNTIME/colors/vim.lua
let g:colors_name = 'edgar-morning'

let s:t_Co = &t_Co
let s:tgc = has('termguicolors') && &termguicolors

let g:terminal_ansi_colors = ['#cdcdcd', '#a52a2a', '#ff00ff', '#6a0dad', '#008787', '#2e8b57', '#6a5acd', '#a9a9a9', '#0000ff', '#a52a2a', '#ff00ff', '#6a0dad', '#008787', '#2e8b57', '#6a5acd', '#000000']
for i in range(g:terminal_ansi_colors->len())
  let g:terminal_color_{i} = g:terminal_ansi_colors[i]
endfor

hi! link CurSearch Search
hi! link CursorLineFold CursorLine
hi! link CursorLineSign CursorLine
hi! link Float Number
hi! link Function Identifier
hi! link LineNrAbove LineNr
hi! link LineNrBelow LineNr
hi! link MessageWindow Pmenu
hi! link Number Constant
hi! link PopupNotification Todo
hi! link StatusLineTerm Statusline
hi! link StatusLineTermNC StatuslineNC
hi! link TabPanel Normal
hi! link TabPanelFill EndOfBuffer
hi! link Terminal Normal

hi Normal guifg=#000000 guibg=#cdcdcd guisp=NONE gui=NONE ctermfg=16 ctermbg=252 cterm=NONE term=NONE
hi ColorColumn guifg=#000000 guibg=#e5e5e5 guisp=NONE gui=NONE ctermfg=16 ctermbg=254 cterm=NONE term=reverse
hi Comment guifg=#0000ff guibg=NONE guisp=NONE gui=NONE ctermfg=21 ctermbg=NONE cterm=NONE term=bold
hi Conceal guifg=#878787 guibg=NONE guisp=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE term=NONE
hi Constant guifg=#ff00ff guibg=NONE guisp=NONE gui=NONE ctermfg=201 ctermbg=NONE cterm=NONE term=NONE
hi Cursor guifg=#cdcdcd guibg=#2e8b57 guisp=NONE gui=NONE ctermfg=252 ctermbg=29 cterm=NONE term=reverse
hi CursorColumn guifg=NONE guibg=#bdbdbd guisp=NONE gui=NONE ctermfg=NONE ctermbg=250 cterm=NONE term=NONE
hi CursorLine guifg=NONE guibg=#bdbdbd guisp=NONE gui=NONE ctermfg=NONE ctermbg=250 cterm=NONE term=underline
hi CursorLineNr guifg=#a52a2a guibg=NONE guisp=NONE gui=bold ctermfg=124 ctermbg=NONE cterm=bold term=bold
hi DiffAdd guifg=#ffffff guibg=#5f875f guisp=NONE gui=NONE ctermfg=231 ctermbg=65 cterm=NONE term=reverse
hi DiffChange guifg=#ffffff guibg=#5f87af guisp=NONE gui=NONE ctermfg=231 ctermbg=67 cterm=NONE term=NONE
hi DiffDelete guifg=#ffffff guibg=#af5faf guisp=NONE gui=NONE ctermfg=231 ctermbg=133 cterm=NONE term=reverse
hi DiffText guifg=#000000 guibg=#b7b7b7 guisp=NONE gui=NONE ctermfg=16 ctermbg=250 cterm=NONE term=reverse
hi Directory guifg=#008787 guibg=NONE guisp=NONE gui=bold ctermfg=30 ctermbg=NONE cterm=bold term=NONE
hi EndOfBuffer guifg=#0000ff guibg=#b7b7b7 guisp=NONE gui=bold ctermfg=21 ctermbg=250 cterm=bold term=NONE
hi Error guifg=#ff0000 guibg=#cdcdcd guisp=NONE gui=reverse ctermfg=196 ctermbg=252 cterm=reverse term=bold,reverse
hi ErrorMsg guifg=#ff0000 guibg=#cdcdcd guisp=NONE gui=reverse ctermfg=196 ctermbg=252 cterm=reverse term=bold,reverse
hi FoldColumn guifg=#00008b guibg=NONE guisp=NONE gui=NONE ctermfg=18 ctermbg=NONE cterm=NONE term=NONE
hi Folded guifg=#00008b guibg=#bdbdbd guisp=NONE gui=NONE ctermfg=18 ctermbg=250 cterm=NONE term=NONE
hi Identifier guifg=#008787 guibg=NONE guisp=NONE gui=NONE ctermfg=30 ctermbg=NONE cterm=NONE term=NONE
hi Ignore guifg=NONE guibg=NONE guisp=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE term=NONE
hi IncSearch guifg=#2e8b57 guibg=NONE guisp=NONE gui=reverse ctermfg=29 ctermbg=NONE cterm=reverse term=bold,reverse,underline
hi LineNr guifg=#a52a2a guibg=NONE guisp=NONE gui=NONE ctermfg=124 ctermbg=NONE cterm=NONE term=NONE
hi MatchParen guifg=#cdcdcd guibg=#6a5acd guisp=NONE gui=NONE ctermfg=252 ctermbg=62 cterm=NONE term=bold,underline
hi ModeMsg guifg=#000000 guibg=NONE guisp=NONE gui=bold ctermfg=16 ctermbg=NONE cterm=bold term=bold
hi MoreMsg guifg=#2e8b57 guibg=NONE guisp=NONE gui=bold ctermfg=29 ctermbg=NONE cterm=bold term=NONE
hi NonText guifg=#0000ff guibg=#a9a9a9 guisp=NONE gui=bold ctermfg=21 ctermbg=248 cterm=bold term=NONE
hi Pmenu guifg=#000000 guibg=#a0a0a0 guisp=NONE gui=NONE ctermfg=16 ctermbg=247 cterm=NONE term=reverse
hi PmenuMatch guifg=#a52a2a guibg=#a0a0a0 guisp=NONE gui=NONE ctermfg=124 ctermbg=247 cterm=NONE term=NONE
hi PmenuMatchSel guifg=#a52a2a guibg=#ffff00 guisp=NONE gui=NONE ctermfg=124 ctermbg=226 cterm=NONE term=NONE
hi PmenuSbar guifg=NONE guibg=#cdcdcd guisp=NONE gui=NONE ctermfg=NONE ctermbg=252 cterm=NONE term=reverse
hi PmenuSel guifg=#000000 guibg=#ffff00 guisp=NONE gui=NONE ctermfg=16 ctermbg=226 cterm=NONE term=bold
hi PmenuThumb guifg=NONE guibg=#000000 guisp=NONE gui=NONE ctermfg=NONE ctermbg=16 cterm=NONE term=NONE
hi PreProc guifg=#6a0dad guibg=NONE guisp=NONE gui=NONE ctermfg=55 ctermbg=NONE cterm=NONE term=NONE
hi Question guifg=#008787 guibg=NONE guisp=NONE gui=bold ctermfg=30 ctermbg=NONE cterm=bold term=standout
hi QuickFixLine guifg=#000000 guibg=#ffff00 guisp=NONE gui=NONE ctermfg=16 ctermbg=226 cterm=NONE term=NONE
hi Search guifg=#cdcdcd guibg=#6a0dad guisp=NONE gui=NONE ctermfg=252 ctermbg=55 cterm=NONE term=reverse
hi SignColumn guifg=#00008b guibg=NONE guisp=NONE gui=NONE ctermfg=18 ctermbg=NONE cterm=NONE term=reverse
hi Special guifg=#6a5acd guibg=NONE guisp=NONE gui=NONE ctermfg=62 ctermbg=NONE cterm=NONE term=NONE
hi SpecialKey guifg=#a9a9a9 guibg=NONE guisp=NONE gui=NONE ctermfg=248 ctermbg=NONE cterm=NONE term=bold
hi SpellBad guifg=#ff0000 guibg=NONE guisp=#ff0000 gui=undercurl ctermfg=196 ctermbg=NONE cterm=underline term=underline
hi SpellCap guifg=#00d700 guibg=NONE guisp=#00d700 gui=undercurl ctermfg=40 ctermbg=NONE cterm=underline term=underline
hi SpellLocal guifg=#a52a2a guibg=NONE guisp=#a52a2a gui=undercurl ctermfg=124 ctermbg=NONE cterm=underline term=underline
hi SpellRare guifg=#2e8b57 guibg=NONE guisp=#2e8b57 gui=undercurl ctermfg=29 ctermbg=NONE cterm=underline term=underline
hi Statement guifg=#a52a2a guibg=NONE guisp=NONE gui=bold ctermfg=124 ctermbg=NONE cterm=bold term=NONE
hi StatusLine guifg=#eeeeee guibg=#000000 guisp=NONE gui=bold ctermfg=255 ctermbg=16 cterm=bold term=bold,reverse
hi StatusLineNC guifg=#a9a9a9 guibg=#000000 guisp=NONE gui=NONE ctermfg=248 ctermbg=16 cterm=NONE term=bold,underline
hi TabLine guifg=#000000 guibg=#a9a9a9 guisp=NONE gui=underline ctermfg=16 ctermbg=248 cterm=underline term=bold,underline
hi TabLineFill guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse term=NONE
hi TabLineSel guifg=#000000 guibg=#cdcdcd guisp=NONE gui=bold ctermfg=16 ctermbg=252 cterm=bold term=bold,reverse
hi Title guifg=#a52a2a guibg=NONE guisp=NONE gui=bold ctermfg=124 ctermbg=NONE cterm=bold term=NONE
hi TitleBar guifg=#000000 guibg=#b7b7b7 guisp=NONE gui=NONE ctermfg=16 ctermbg=249 cterm=NONE term=NONE
hi TitleBarNC guifg=#5f5f5f guibg=#a9a9a9 guisp=NONE gui=NONE ctermfg=59 ctermbg=250 cterm=NONE term=NONE
hi Todo guifg=#000000 guibg=#ffff00 guisp=NONE gui=NONE ctermfg=16 ctermbg=226 cterm=NONE term=bold,reverse
hi ToolbarButton guifg=NONE guibg=#a9a9a9 guisp=NONE gui=bold ctermfg=NONE ctermbg=248 cterm=bold term=bold,reverse
hi ToolbarLine guifg=NONE guibg=NONE guisp=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE term=reverse
hi Type guifg=#2e8b57 guibg=NONE guisp=NONE gui=bold ctermfg=29 ctermbg=NONE cterm=bold term=NONE
hi Underlined guifg=#6a5acd guibg=NONE guisp=NONE gui=underline ctermfg=62 ctermbg=NONE cterm=underline term=underline
hi VertSplit guifg=#a9a9a9 guibg=#000000 guisp=NONE gui=NONE ctermfg=248 ctermbg=16 cterm=NONE term=NONE
hi Visual guifg=NONE guibg=#bbbbbb guisp=NONE gui=NONE ctermfg=NONE ctermbg=250 cterm=NONE term=reverse
hi VisualNOS guifg=NONE guibg=#0000ff guisp=NONE gui=NONE ctermfg=NONE ctermbg=21 cterm=NONE term=NONE
hi WarningMsg guifg=#6a0dad guibg=NONE guisp=NONE gui=bold ctermfg=55 ctermbg=NONE cterm=bold term=standout
hi WildMenu guifg=#000000 guibg=#ffff00 guisp=NONE gui=bold ctermfg=16 ctermbg=226 cterm=bold term=bold
hi lCursor guifg=#cdcdcd guibg=#a52a2a guisp=NONE gui=NONE ctermfg=252 ctermbg=124 cterm=NONE term=NONE


if s:tgc || s:t_Co >= 256
  finish
endif

" vim: et ts=8 sw=2 sts=2
