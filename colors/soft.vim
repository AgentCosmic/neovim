" Vim color file
" Author: Dalton Tan <daltonyi@hotmail.com>

set background=dark
hi clear
if exists('syntax_on')
	syntax reset
endif

let g:colors_name = 'soft'

function! s:h(group, style, ...)
	execute 'highlight' a:group
		\ 'guifg='   (has_key(a:style, 'fg')    ? a:style.fg   : 'NONE')
		\ 'guibg='   (has_key(a:style, 'bg')    ? a:style.bg   : 'NONE')
		\ 'guisp='   (has_key(a:style, 'sp')    ? a:style.sp   : 'NONE')
		\ 'gui='     (has_key(a:style, 'gui')   ? a:style.gui  : 'NONE')
endfunction

let s:red = '#ffb2b5'
let s:purple = '#ddbaff'
let s:blue = '#99cbff'
let s:green = '#8bd6bd'
let s:yellow = '#becc7a'
let s:orange = '#e5bf8a'
let s:highlight = '#1e497a'
let s:grey95 = '#f1ede4' " white
let s:grey85 = '#d6d4cb' " fg
let s:grey75 = '#bdb8b1' " inactive tab
let s:grey65 = '#a29d97' " comment
let s:grey25 = '#3d3c37' " Visual
let s:grey20 = '#30302e' " CursorLine
let s:grey15 = '#262624' " bg
let s:grey10 = '#1c1b19' " column
let s:grey05 = '#12110e' " black

" Syntax Groups (descriptions and ordering from `:h w18`)

call s:h('Comment', {'fg': s:grey65})
call s:h('Constant', {'fg': s:orange})
call s:h('String', {'fg': s:orange})
call s:h('Character', {'fg': s:orange})
call s:h('Number', {'fg': s:yellow})
call s:h('Boolean', {'fg': s:yellow})
call s:h('Float', {'fg': s:yellow})

call s:h("Identifier", { "fg": s:blue })
call s:h('Function', {'fg': s:blue})

call s:h('Statement', {'fg': s:green})
call s:h('Conditional', {'fg': s:green})
call s:h('Repeat', {'fg': s:green})
call s:h('Label', {'fg': s:green, 'gui': 'none'})
call s:h('Operator', {'fg': s:green})
call s:h('Keyword', {'fg': s:green})
call s:h('Exception', {'fg': s:green})

call s:h('PreProc', {'fg': s:yellow})
call s:h('Include', {'fg': s:yellow})
call s:h('Define', {'fg': s:yellow})
call s:h('Macro', {'fg': s:yellow, 'gui': 'italic'})
call s:h('PreCondit', {'fg': s:yellow})

call s:h('Type', {'fg': s:purple, 'gui': 'none'})
call s:h('StorageClass', {'fg': s:purple, 'gui': 'none'})
call s:h('Structure', {'fg': s:purple})
call s:h('Typedef', {'fg': s:purple})

call s:h('Special', {'fg': s:yellow})
call s:h('SpecialChar', {'fg': s:green})
call s:h('Tag', {'fg': s:blue, 'gui': 'italic'})
call s:h('Delimiter', {'fg': s:orange})
call s:h('SpecialComment', {'fg': s:grey85})
call s:h('Debug', {'fg': s:purple})

call s:h('Underlined', {'fg': s:grey65, 'gui': 'underline'})
call s:h('Ignore', {'fg': s:grey65, 'bg': 'bg'})
call s:h('Error', {'fg': s:red, 'bg': 'NONE', 'sp': s:red})
call s:h('Todo', {'fg': s:grey95, 'bg': 'bg', 'gui': 'bold'})

" Highlighting Groups (descriptions and ordering from `:h highlight-groups`) {{{

call s:h('ColorColumn', {'bg': s:grey10})
call s:h('Conceal', {'bg': 'bg', 'fg': s:grey25})
call s:h('Cursor', {'fg': s:grey15, 'bg': s:grey85})
call s:h('CursorColumn', {'bg': s:grey20})
call s:h('CursorLine', {'bg': s:grey20})
call s:h('Directory', {'fg': s:orange})
call s:h('DiffAdd', {'fg': s:blue, 'bg': s:grey25})
call s:h('DiffChange', {'fg': s:orange, 'bg': s:grey25})
call s:h('DiffDelete', {'fg': s:red, 'bg': 'NONE'})
call s:h('DiffText', {'bg': s:grey25, 'gui': 'italic,bold'})
call s:h('EndOfBuffer', {'fg': s:grey65, 'bg': 'NONE'})
call s:h('ErrorMsg', {'fg': s:red, 'bg': 'NONE', 'sp': s:red})
call s:h('VertSplit', {'fg': s:grey65, 'bg': s:grey15})
call s:h('Folded', {'fg': s:grey65, 'bg': s:grey05})
call s:h('FoldColumn', {'fg': s:grey65, 'bg': s:grey05})
call s:h('SignColumn', {'fg': s:purple, 'bg': 'bg'})
call s:h('IncSearch', {'fg': s:grey15, 'bg': s:orange})
call s:h('Substitute', {'fg': s:orange, 'bg': s:grey15})
call s:h('LineNr', {'fg': s:grey65})
call s:h('CursorLineNr', {'fg': s:grey65})
call s:h('MatchParen', {'fg': s:grey15, 'bg': s:green})
call s:h('ModeMsg', {'fg': s:orange})
call s:h('MsgArea', {'fg': s:grey85})
call s:h('MsgSeparator', {'fg': s:yellow})
call s:h('MoreMsg', {'fg': s:yellow})
call s:h('NonText', {'fg': s:grey65})
call s:h('Normal', {'fg': s:grey85, 'bg': s:grey15})
call s:h('NormalFloat', {'fg': s:grey85, 'bg': s:grey20})
call s:h('Pmenu', {'fg': s:grey85, 'bg': s:grey25})
call s:h('PmenuSel', {'fg': s:grey15, 'bg': s:green})
call s:h('PmenuSbar', {'bg': s:grey95})
call s:h('PmenuThumb', {'fg': s:green})
call s:h('Question', {'fg': s:orange})
call s:h('QuickFixLine', {'bg': s:grey25, 'gui': 'bold'})
call s:h('Search', {'fg': s:grey95, 'bg': s:highlight, 'gui': 'underline'})
call s:h('SpecialKey', {'fg': s:grey65, 'gui': 'italic'})
call s:h('SpellBad', {'fg': s:red, 'gui': 'undercurl', 'sp': s:red})
call s:h('SpellCap', {'fg': s:orange, 'gui': 'undercurl', 'sp': s:orange})
call s:h('SpellLocal', {'fg': s:yellow, 'gui': 'undercurl', 'sp': s:yellow})
call s:h('SpellRare', {'fg': s:yellow, 'gui': 'undercurl', 'sp': s:yellow})
call s:h('StatusLine', {'fg': s:grey85, 'bg': s:grey20})
call s:h('StatusLineNC', {'fg': s:grey65, 'bg': s:grey10})
call s:h('TabLine', {'fg': s:grey85, 'bg': s:grey05})
call s:h('TabLineFill', {'fg': s:grey85, 'bg': s:grey05})
call s:h('TabLineSel', {'fg': s:grey85, 'bg': s:grey15})
call s:h('Title', {'fg': s:purple})
call s:h('Visual', {'bg': s:grey25})
call s:h('VisualNOS', {'bg': s:grey25})
call s:h('WarningMsg', {'fg': s:orange})
call s:h('Whitespace', {'fg': s:grey25})
call s:h('WildMenu', {'fg': s:grey15, 'bg': s:blue})

" ------------------------------------------------------------------------------

" custom status line highlight groups

call s:h('MyStatusLineUnmodified', {'fg': s:grey65, 'bg': s:grey10})
call s:h('MyStatusLineModified', {'fg': s:grey15, 'bg': s:orange})
call s:h('MyStatusLinePath', {'fg': s:grey85, 'bg': s:grey25})
call s:h('MyStatusLinePosition', {'fg': s:grey65, 'bg': s:grey10})
call s:h('MyStatusLineMisc', {'fg': s:grey75, 'bg': s:grey25})
call s:h('MyStatusLineFiletype', {'fg': s:grey65, 'bg': s:grey10})

" languages

hi link cssProp Statement
hi link cssAtRule Type
hi link cssPseudoClassId Type

hi link jsxAttrib Statement

" quick-scope

call s:h('QuickScopePrimary', {'fg': s:grey95, 'gui': 'underline'})
call s:h('QuickScopeSecondary', {'fg': s:grey65, 'gui': 'underline'})

" illuminate

call s:h('illuminatedWord', {'gui': 'underline'})

" LSP

call s:h('LspDiagnosticsDefaultError', {'fg': s:red, 'sp': s:red})
call s:h('LspDiagnosticsDefaultWarning', {'fg': s:orange, 'sp': s:orange})
call s:h('LspDiagnosticsDefaultInformation', {'fg': s:grey85})
call s:h('LspDiagnosticsDefaultHint', {'fg': s:grey65})
call s:h('LspDiagnosticsUnderlineError', {'gui': 'underline', 'sp': s:red})
call s:h('LspDiagnosticsUnderlineWarning', {'gui': 'underline', 'sp': s:orange})
call s:h('LspDiagnosticsUnderlineInformation', {'gui': 'underline', 'sp': s:blue})
call s:h('LspDiagnosticsUnderlineHint', {'gui': 'underline', 'sp': s:grey65})
call s:h('LspDiagnosticsSignError', {'fg': s:red})
call s:h('LspDiagnosticsDefaultWarning', {'fg': s:orange})
call s:h('LspReferenceText', {'gui': 'underline'})
hi link LspReferenceWrite LspReferenceText
hi link LspReferenceRead LspReferenceText

" barbar.nvim

call s:h('BufferTabpages', {'fg': s:grey05, 'bg': s:grey05})
call s:h('BufferTabpageFill', {'fg': s:grey05, 'bg': s:grey05})
call s:h('BufferOffset', {'bg': s:grey15})

call s:h('BufferCurrent', {'fg': s:grey95, 'bg': s:grey25})
hi link BufferCurrentIcon BufferCurrent
hi link BufferCurrentIndex BufferCurrent
call s:h('BufferCurrentMod', {'fg': s:orange, 'bg': s:grey25})
call s:h('BufferCurrentSign', {'fg': s:green, 'bg': s:grey25})
call s:h('BufferCurrentTarget', {'fg': s:orange, 'bg': s:grey25})

call s:h('BufferInactive', {'fg': s:grey75, 'bg': s:grey05})
hi link BufferInactiveIcon BufferInactive
hi link BufferInactiveIndex BufferInactive
hi link BufferInactiveMod BufferInactive
call s:h('BufferInactiveMod', {'fg': s:orange, 'bg': s:grey05})
call s:h('BufferInactiveSign', {'fg': s:grey25, 'bg': s:grey05})
call s:h('BufferInactiveTarget', {'fg': s:orange, 'bg': s:grey05})

hi link BufferVisible BufferInactive
hi link BufferVisibleIcon BufferVisible
hi link BufferVisibleIndex BufferVisible
hi link BufferVisibleMod BufferVisible
hi link BufferVisibleSign BufferInactiveSign
hi link BufferVisibleTarget BufferInactiveTarget

" hop.nvim

call s:h('HopNextKey', {'fg': s:orange})
call s:h('HopNextKey1', {'fg': s:blue})
call s:h('HopNextKey2', {'fg': s:blue})
call s:h('HopUnmatched', {'fg': s:grey65})

" nvim-tree.lua

call s:h('NvimTreeRootFolder', {'fg': s:blue})
" call s:h('NvimTreeFolderName', {'fg': s:orange})
call s:h('NvimTreeOpenedFolderName', {'fg': s:orange})
call s:h('NvimTreeExecFile', {'fg': s:grey85})
call s:h('NvimTreeGitDirty', {'fg': s:blue})
