if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab

if !exists('g:path_to_ruby')
	let g:path_to_ruby = 'ruby'
endif

function! s:RunRuby()
	:wa
	exec ':!' . g:path_to_ruby . ' "' . expand('%:p') . '"'
	call feedkeys('<cr>')
endfunction

command! -nargs=0 RunRuby call <SID>RunRuby()
noremap <buffer> <F6> :RunRuby<cr>
inoremap <buffer> <F6> <esc>:RunRuby<cr>
