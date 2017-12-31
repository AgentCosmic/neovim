if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab

" don't remove indent when commenting
inoremap <buffer> # <left><right>#

if !exists('g:path_to_python')
	let g:path_to_python = 'python'
endif

function! s:RunPython()
	:wa
	exec ':!' . g:path_to_python . ' "' . expand('%:p') . '"'
	call feedkeys('<cr>')
endfunction

command! -nargs=0 RunPython call <SID>RunPython()
noremap <buffer> <F6> :RunPython<cr>
inoremap <buffer> <F6> <esc>:RunPython<cr>
