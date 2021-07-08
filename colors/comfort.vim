" Vim color file
" Author: Dalton Tan <daltonyi@hotmail.com>

set background=dark
hi clear
if exists("syntax_on")
	syntax reset
endif

let g:colors_name="comfort"

hi Boolean         guifg=#ffa640
hi Character       guifg=#e5d477
hi Number          guifg=#ffa640
hi String          guifg=#e5d477
hi Conditional     guifg=#7bdb7b               gui=bold
hi Constant        guifg=#ffa640               gui=bold
hi Cursor          guifg=#262624 guibg=#d6d4cb
hi Define          guifg=#ffa640
hi Delimiter       guifg=#94918a
hi DiffAdd         guifg=#99cbff guibg=#484744
hi DiffChange      guifg=#ffa640 guibg=#484744
hi DiffDelete      guifg=#ffa2a0 guibg=NONE
hi DiffText                      guibg=#484744 gui=italic,bold

hi Directory       guifg=#d5bbff               gui=bold
hi Error           guifg=#ffa2a0 guibg=NONE
hi ErrorMsg        guifg=#ffa2a0 guibg=NONE    gui=bold
hi Exception       guifg=#d5bbff               gui=bold
hi Float           guifg=#ffa640
hi FoldColumn      guifg=#94918a guibg=#12110e
hi Folded          guifg=#94918a guibg=#12110e
hi Function        guifg=#99cbff
hi Identifier      guifg=#99cbff
hi Ignore          guifg=#94918a guibg=bg
hi IncSearch       guifg=#e5d477 guibg=#262624

hi Keyword         guifg=#7bdb7b               gui=bold
hi Label           guifg=#e5d477               gui=none
hi Macro           guifg=#e5d477               gui=italic
hi SpecialKey      guifg=#ffa640               gui=italic

hi MatchParen      guifg=#262624 guibg=#7bdb7b gui=bold
hi ModeMsg         guifg=#e5d477
hi MoreMsg         guifg=#e5d477
hi Operator        guifg=#7bdb7b

hi Pmenu           guifg=#d6d4cb guibg=#484744
hi PmenuSel        guifg=#262624 guibg=#ffa640
hi PmenuSbar                     guibg=#f1ede4
hi PmenuThumb      guifg=#ffa640

hi PreCondit       guifg=#d5bbff               gui=bold
hi PreProc         guifg=#d5bbff
hi Question        guifg=#ffa640
hi Repeat          guifg=#7bdb7b               gui=bold
hi Search          guifg=#f1ede4 guibg=#706a5a

hi SignColumn      guifg=#d5bbff guibg=bg
hi SpecialChar     guifg=#7bdb7b               gui=bold
hi SpecialComment  guifg=#94918a               gui=bold
hi Special         guifg=#ffa640 guibg=bg      gui=italic
hi SpecialKey      guifg=#94918a               gui=italic
if has("spell")
	hi SpellBad    guisp=#ffa2a0 gui=undercurl
	hi SpellCap    guisp=#d5bbff gui=undercurl
	hi SpellLocal  guisp=#e5d477 gui=undercurl
	hi SpellRare   guisp=#ffa640 gui=undercurl
endif
hi Statement       guifg=#7bdb7b               gui=bold
hi StatusLine      guifg=#484744 guibg=#d6d4cb
hi StatusLineNC    guifg=#484744 guibg=#d6d4cb
hi StorageClass    guifg=#7bdb7b               gui=italic
hi Structure       guifg=#ffa640
hi Tag             guifg=#7bdb7b               gui=italic
hi Title           guifg=#d5bbff
hi Todo            guifg=#f1ede4 guibg=bg      gui=bold

hi Typedef         guifg=#ffa640
hi Type            guifg=#ffa640               gui=none
hi Underlined      guifg=#94918a               gui=underline

hi VertSplit       guifg=#484744 guibg=#484744
hi VisualNOS                     guibg=#3d3c37
hi Visual                        guibg=#3d3c37
hi WarningMsg      guifg=#ffa640               gui=bold
hi WildMenu        guifg=#262624 guibg=#99cbff

hi Normal          guifg=#d6d4cb guibg=#262624
hi Comment         guifg=#94918a
hi CursorLine                    guibg=#30302e
hi CursorColumn                  guibg=#30302e
hi LineNr          guifg=#94918a
hi CursorLineNr    guifg=#94918a
hi NonText         guifg=#94918a guibg=#262624
hi ColorColumn                   guibg=#1c1b1a
hi Whitespace      guifg=#3d3c37

hi Conceal		guibg=bg		guifg=#3d3c37

" ------------------------------------------------------------------------------

" quick-scope

hi QuickScopePrimary	guifg=#f1ede4	gui=underline
hi QuickScopeSecondary	guifg=#94918a	gui=underline

" CtrlP

hi CtrlPMatch guifg=#99cbff

" LSP

hi LspDiagnosticsDefaultError gui=undercurl guifg=#ffa2a0
hi LspDiagnosticsSignError guifg=#ffa2a0
hi LspDiagnosticsDefaultWarning guifg=#ffa640
hi LspReferenceText gui=underline
hi link LspReferenceWrite LspReferenceText
hi link LspReferenceRead LspReferenceText

" nvim-compe

" hi link CompeDocumentation NormalFloat

" barbar.nvim

hi BufferTabpages guifg=#12110e guibg=#12110e
hi BufferTabpageFill guifg=#12110e guibg=#12110e
hi BufferOffset guibg=#262624

hi BufferCurrent guifg=#d6d4cb guibg=#262624
hi link BufferCurrentIcon BufferCurrent
hi link BufferCurrentIndex BufferCurrent
hi BufferCurrentMod guifg=#99cbff guibg=#262624
hi BufferCurrentSign guifg=#262624 guibg=#262624
hi BufferCurrentTarget guifg=#ffa2a0 guibg=#262624

hi BufferVisible guifg=#94918a guibg=#262624
hi link BufferVisibleIcon BufferVisible
hi link BufferVisibleIndex BufferVisible
hi BufferVisibleMod guifg=#99cbff guibg=#262624
hi BufferVisibleSign guifg=#262624 guibg=#262624
hi BufferVisibleTarget guifg=#ffa2a0 guibg=#262624

hi BufferInactive guifg=#94918a guibg=#12110e
hi link BufferInactiveIcon BufferInactive
hi link BufferInactiveIndex BufferInactive
hi BufferInactiveMod guifg=#99cbff guibg=#12110e
hi BufferInactiveSign guifg=#12110e guibg=#12110e
hi BufferInactiveTarget guifg=#ffa2a0 guibg=#12110e

" red = '#ffa2a0'
" orange = '#ffa640'
" yellow = '#e5d477'
" green = '#7bdb7b'
" blue = '#99cbff'
" purple = '#d5bbff'
" grey95 = '#f1ede4' " white
" grey85 = '#d6d4cb' " fg
" grey60 = '#94918a' " grey
" grey45 = '#706a5a' " Search
" grey30 = '#484744' " UI
" grey25 = '#3d3c37' " Visual
" grey20 = '#30302e' " CursorLine
" grey15 = '#262624' " bg
" grey10 = '#1c1b1a' " column
" grey5 = '#12110e'  " black
