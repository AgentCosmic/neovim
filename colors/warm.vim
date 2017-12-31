" Vim color file
" Author: Dalton Tan <daltonyi@hotmail.com>

set background=dark
hi clear
if exists("syntax_on")
	syntax reset
endif

let g:colors_name="consis"


hi Boolean         guifg=#ffa640
hi Character       guifg=#e5d477
hi Number          guifg=#ffa640
hi String          guifg=#e5d477
hi Conditional     guifg=#7bdb8b               gui=bold
hi Constant        guifg=#ffa640               gui=bold
hi Cursor          guifg=#262524 guibg=#f8f8f0
hi Debug           guifg=#ccb8b8               gui=bold
hi Define          guifg=#ffa640
hi Delimiter       guifg=#8f8f8f
hi DiffAdd         guifg=#99cbff guibg=#394952
hi DiffChange      guifg=#ffa640 guibg=#4f4437
hi DiffDelete      guifg=#ffa2a0 guibg=NONE
hi DiffText                      guibg=#4f4437 gui=italic,bold

hi Directory       guifg=#e8b5ff               gui=bold
hi Error           guifg=#ffa2a0 guibg=NONE
hi ErrorMsg        guifg=#ffa2a0 guibg=NONE    gui=bold
hi Exception       guifg=#e8b5ff               gui=bold
hi Float           guifg=#ffa640
hi FoldColumn      guifg=#94908a guibg=#0e1112
hi Folded          guifg=#94908a guibg=#0e1112
hi Function        guifg=#99cbff
hi Identifier      guifg=#99cbff
hi Ignore          guifg=#808080 guibg=bg
hi IncSearch       guifg=#e5d477 guibg=#262524

hi Keyword         guifg=#7bdb8b               gui=bold
hi Label           guifg=#e5d477               gui=none
hi Macro           guifg=#e5d477               gui=italic
hi SpecialKey      guifg=#ffa640               gui=italic

hi MatchParen      guifg=#000000 guibg=#99cbff gui=bold
hi ModeMsg         guifg=#e5d477
hi MoreMsg         guifg=#e5d477
hi Operator        guifg=#7bdb8b

hi Pmenu           guifg=#d6d3ce guibg=#46474a
hi PmenuSel        guifg=#262524 guibg=#99cbff
hi PmenuSbar                     guibg=#f2ede6
hi PmenuThumb      guifg=#ffa640

hi PreCondit       guifg=#e8b5ff               gui=bold
hi PreProc         guifg=#e8b5ff
hi Question        guifg=#ffa640
hi Repeat          guifg=#7bdb8b               gui=bold
hi Search          guifg=#ffffff guibg=#455354

hi SignColumn      guifg=#e8b5ff guibg=bg
hi SpecialChar     guifg=#7bdb8b               gui=bold
hi SpecialComment  guifg=#94908a               gui=bold
hi Special         guifg=#ffa640 guibg=bg      gui=italic
hi SpecialKey      guifg=#888a85               gui=italic
if has("spell")
	hi SpellBad    guisp=#ffa2a0 gui=undercurl
	hi SpellCap    guisp=#e8b5ff gui=undercurl
	hi SpellLocal  guisp=#e5d477 gui=undercurl
	hi SpellRare   guisp=#ffa640 gui=undercurl
endif
hi Statement       guifg=#7bdb8b               gui=bold
hi StatusLine      guifg=#46474a guibg=#d6d3ce
hi StatusLineNC    guifg=#46474a guibg=#d6d3ce
hi StorageClass    guifg=#7bdb8b               gui=italic
hi Structure       guifg=#ffa640
hi Tag             guifg=#7bdb8b               gui=italic
hi Title           guifg=#e8b5ff
hi Todo            guifg=#ffffff guibg=bg      gui=bold

hi Typedef         guifg=#ffa640
hi Type            guifg=#ffa640               gui=none
hi Underlined      guifg=#808080               gui=underline

hi VertSplit       guifg=#808080 guibg=#080808 gui=bold
hi VisualNOS                     guibg=#403d3d
hi Visual                        guibg=#403d3d
hi WarningMsg      guifg=#ffa640               gui=bold
hi WildMenu        guifg=#262524 guibg=#99cbff

hi Normal          guifg=#d6d3ce guibg=#262524
hi Comment         guifg=#94908a
hi CursorLine                    guibg=#303032
hi CursorColumn                  guibg=#303032
hi LineNr          guifg=#6f7978
hi CursorLineNr    guifg=#6f7978
hi NonText         guifg=#6f7978 guibg=#262524
hi ColorColumn                   guibg=#1b1c1d


hi MBENormal guifg=#c2c7cc
hi MBEChanged guifg=fg gui=italic
hi link MBEVisibleNormal MBENormal
hi link MBEVisibleChanged MBEChanged
hi MBEVisibleActiveNormal guibg=#46474a gui=bold
hi MBEVisibleActiveChanged guibg=#46474a gui=bold,italic


hi phpFunctions  guifg=#e8b5ff
