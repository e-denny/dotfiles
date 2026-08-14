" Name:         edgar-morning
" Description:  morning with 10% darker backgrounds
" Based on:     morning by Bram Moolenaar

set background=light

source $VIMRUNTIME/colors/vim.lua
let g:colors_name = 'edgar-morning'

let s:t_Co = &t_Co
let s:tgc = has('termguicolors') && &termguicolors

let g:terminal_ansi_colors = ['#000000', '#8b1a1a', '#005555', '#6b1fa0', '#006b4f', '#9b1f5a', '#3030a0', '#a9a9a9', '#444444', '#8b1a1a', '#005555', '#6b1fa0', '#006b4f', '#9b1f5a', '#3030a0', '#000000']
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

hi Normal guifg=#000000 guibg=#a8a8a8 guisp=NONE gui=NONE ctermfg=16 ctermbg=248 cterm=NONE term=NONE
hi ColorColumn guifg=#000000 guibg=#e5e5e5 guisp=NONE gui=NONE ctermfg=16 ctermbg=254 cterm=NONE term=reverse
hi Comment guifg=#8b5e00 guibg=NONE guisp=NONE gui=NONE ctermfg=94 ctermbg=NONE cterm=NONE term=bold
hi Conceal guifg=#878787 guibg=NONE guisp=NONE gui=NONE ctermfg=102 ctermbg=NONE cterm=NONE term=NONE
hi Constant guifg=#9b1f5a guibg=NONE guisp=NONE gui=NONE ctermfg=125 ctermbg=NONE cterm=NONE term=NONE
hi Cursor guifg=#cdcdcd guibg=#2e8b57 guisp=NONE gui=NONE ctermfg=252 ctermbg=29 cterm=NONE term=reverse
hi CursorColumn guifg=NONE guibg=#bdbdbd guisp=NONE gui=NONE ctermfg=NONE ctermbg=250 cterm=NONE term=NONE
hi CursorLine guifg=NONE guibg=#bdbdbd guisp=NONE gui=NONE ctermfg=NONE ctermbg=250 cterm=NONE term=underline
hi CursorLineNr guifg=#8b1a1a guibg=NONE guisp=NONE gui=bold ctermfg=88 ctermbg=NONE cterm=bold term=bold
hi DiffAdd guifg=#ffffff guibg=#5f875f guisp=NONE gui=NONE ctermfg=231 ctermbg=65 cterm=NONE term=reverse
hi DiffChange guifg=#ffffff guibg=#5f87af guisp=NONE gui=NONE ctermfg=231 ctermbg=67 cterm=NONE term=NONE
hi DiffDelete guifg=#ffffff guibg=#af5faf guisp=NONE gui=NONE ctermfg=231 ctermbg=133 cterm=NONE term=reverse
hi DiffText guifg=#000000 guibg=#b7b7b7 guisp=NONE gui=NONE ctermfg=16 ctermbg=250 cterm=NONE term=reverse
hi Directory guifg=#006b4f guibg=NONE guisp=NONE gui=bold ctermfg=29 ctermbg=NONE cterm=bold term=NONE
hi EndOfBuffer guifg=#8b5e00 guibg=#b7b7b7 guisp=NONE gui=bold ctermfg=94 ctermbg=250 cterm=bold term=NONE
hi Error guifg=#ff0000 guibg=#a8a8a8 guisp=NONE gui=reverse ctermfg=196 ctermbg=248 cterm=reverse term=bold,reverse
hi ErrorMsg guifg=#ff0000 guibg=#a8a8a8 guisp=NONE gui=reverse ctermfg=196 ctermbg=248 cterm=reverse term=bold,reverse
hi FoldColumn guifg=#3030a0 guibg=NONE guisp=NONE gui=NONE ctermfg=61 ctermbg=NONE cterm=NONE term=NONE
hi Folded guifg=#3030a0 guibg=#bdbdbd guisp=NONE gui=NONE ctermfg=61 ctermbg=250 cterm=NONE term=NONE
hi Identifier guifg=#005555 guibg=NONE guisp=NONE gui=NONE ctermfg=23 ctermbg=NONE cterm=NONE term=NONE
hi Ignore guifg=NONE guibg=NONE guisp=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE term=NONE
hi IncSearch guifg=#006b4f guibg=NONE guisp=NONE gui=reverse ctermfg=29 ctermbg=NONE cterm=reverse term=bold,reverse,underline
hi LineNr guifg=#8b5e00 guibg=NONE guisp=NONE gui=NONE ctermfg=94 ctermbg=NONE cterm=NONE term=NONE
hi MatchParen guifg=#cdcdcd guibg=#6a5acd guisp=NONE gui=NONE ctermfg=252 ctermbg=62 cterm=NONE term=bold,underline
hi ModeMsg guifg=#000000 guibg=NONE guisp=NONE gui=bold ctermfg=16 ctermbg=NONE cterm=bold term=bold
hi MoreMsg guifg=#006b4f guibg=NONE guisp=NONE gui=bold ctermfg=29 ctermbg=NONE cterm=bold term=NONE
hi NonText guifg=#8b5e00 guibg=#a9a9a9 guisp=NONE gui=bold ctermfg=94 ctermbg=248 cterm=bold term=NONE
hi Pmenu guifg=#000000 guibg=#a0a0a0 guisp=NONE gui=NONE ctermfg=16 ctermbg=247 cterm=NONE term=reverse
hi PmenuMatch guifg=#8b1a1a guibg=#a0a0a0 guisp=NONE gui=NONE ctermfg=88 ctermbg=247 cterm=NONE term=NONE
hi PmenuMatchSel guifg=#a52a2a guibg=#ffff00 guisp=NONE gui=NONE ctermfg=124 ctermbg=226 cterm=NONE term=NONE
hi PmenuSbar guifg=NONE guibg=#a8a8a8 guisp=NONE gui=NONE ctermfg=NONE ctermbg=248 cterm=NONE term=reverse
hi PmenuSel guifg=#000000 guibg=#ffff00 guisp=NONE gui=NONE ctermfg=16 ctermbg=226 cterm=NONE term=bold
hi PmenuThumb guifg=NONE guibg=#000000 guisp=NONE gui=NONE ctermfg=NONE ctermbg=16 cterm=NONE term=NONE
hi PreProc guifg=#6b1fa0 guibg=NONE guisp=NONE gui=NONE ctermfg=55 ctermbg=NONE cterm=NONE term=NONE
hi Question guifg=#006b4f guibg=NONE guisp=NONE gui=bold ctermfg=29 ctermbg=NONE cterm=bold term=standout
hi QuickFixLine guifg=#000000 guibg=#ffff00 guisp=NONE gui=NONE ctermfg=16 ctermbg=226 cterm=NONE term=NONE
hi Search guifg=#ffffff guibg=#6b1fa0 guisp=NONE gui=NONE ctermfg=252 ctermbg=55 cterm=NONE term=reverse
hi SignColumn guifg=#3030a0 guibg=NONE guisp=NONE gui=NONE ctermfg=61 ctermbg=NONE cterm=NONE term=reverse
hi Special guifg=#3030a0 guibg=NONE guisp=NONE gui=NONE ctermfg=61 ctermbg=NONE cterm=NONE term=NONE
hi SpecialKey guifg=#a9a9a9 guibg=NONE guisp=NONE gui=NONE ctermfg=248 ctermbg=NONE cterm=NONE term=bold
hi SpellBad guifg=#ff0000 guibg=NONE guisp=#ff0000 gui=undercurl ctermfg=196 ctermbg=NONE cterm=underline term=underline
hi SpellCap guifg=#00d700 guibg=NONE guisp=#00d700 gui=undercurl ctermfg=40 ctermbg=NONE cterm=underline term=underline
hi SpellLocal guifg=#a52a2a guibg=NONE guisp=#a52a2a gui=undercurl ctermfg=124 ctermbg=NONE cterm=underline term=underline
hi SpellRare guifg=#2e8b57 guibg=NONE guisp=#2e8b57 gui=undercurl ctermfg=29 ctermbg=NONE cterm=underline term=underline
hi Statement guifg=#8b1a1a guibg=NONE guisp=NONE gui=bold ctermfg=88 ctermbg=NONE cterm=bold term=NONE
hi StatusLine guifg=#ffffff guibg=#000000 guisp=NONE gui=bold ctermfg=255 ctermbg=16 cterm=bold term=bold,reverse
hi StatusLineNC guifg=#a9a9a9 guibg=#000000 guisp=NONE gui=NONE ctermfg=248 ctermbg=16 cterm=NONE term=bold,underline
hi TabLine guifg=#000000 guibg=#a9a9a9 guisp=NONE gui=underline ctermfg=16 ctermbg=248 cterm=underline term=bold,underline
hi TabLineFill guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse term=NONE
hi TabLineSel guifg=#000000 guibg=#a8a8a8 guisp=NONE gui=bold ctermfg=16 ctermbg=248 cterm=bold term=bold,reverse
hi Title guifg=#8b1a1a guibg=NONE guisp=NONE gui=bold ctermfg=88 ctermbg=NONE cterm=bold term=NONE
hi TitleBar guifg=#000000 guibg=#b7b7b7 guisp=NONE gui=NONE ctermfg=16 ctermbg=249 cterm=NONE term=NONE
hi TitleBarNC guifg=#5f5f5f guibg=#a9a9a9 guisp=NONE gui=NONE ctermfg=59 ctermbg=250 cterm=NONE term=NONE
hi Todo guifg=#000000 guibg=#ffff00 guisp=NONE gui=NONE ctermfg=16 ctermbg=226 cterm=NONE term=bold,reverse
hi ToolbarButton guifg=NONE guibg=#a9a9a9 guisp=NONE gui=bold ctermfg=NONE ctermbg=248 cterm=bold term=bold,reverse
hi ToolbarLine guifg=NONE guibg=NONE guisp=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE term=reverse
hi Type guifg=#1e6b1e guibg=NONE guisp=NONE gui=bold ctermfg=22 ctermbg=NONE cterm=bold term=NONE
hi Underlined guifg=#3030a0 guibg=NONE guisp=NONE gui=underline ctermfg=61 ctermbg=NONE cterm=underline term=underline
hi VertSplit guifg=#a9a9a9 guibg=#000000 guisp=NONE gui=NONE ctermfg=248 ctermbg=16 cterm=NONE term=NONE
hi Visual guifg=NONE guibg=#bbbbbb guisp=NONE gui=NONE ctermfg=NONE ctermbg=250 cterm=NONE term=reverse
hi VisualNOS guifg=NONE guibg=#3030a0 guisp=NONE gui=NONE ctermfg=NONE ctermbg=61 cterm=NONE term=NONE
hi WarningMsg guifg=#6b1fa0 guibg=NONE guisp=NONE gui=bold ctermfg=55 ctermbg=NONE cterm=bold term=standout
hi WildMenu guifg=#000000 guibg=#ffff00 guisp=NONE gui=bold ctermfg=16 ctermbg=226 cterm=bold term=bold
hi lCursor guifg=#ffffff guibg=#8b1a1a guisp=NONE gui=NONE ctermfg=252 ctermbg=88 cterm=NONE term=NONE

" Re-apply plugin highlight overrides after plugins install their defaults.
" Uses BufEnter so it fires after obsidian.nvim installs its hl_groups.
lua << EOF
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("EdgarMorningPluginHl", { clear = true }),
  pattern = "*.md",
  callback = function()
    if vim.g.colors_name == "edgar-morning" then
      vim.api.nvim_set_hl(0, "ObsidianRefText", { fg = "#7c35c9", underline = true })
    end
  end,
})
EOF

if s:tgc || s:t_Co >= 256
  finish
endif

" vim: et ts=8 sw=2 sts=2
