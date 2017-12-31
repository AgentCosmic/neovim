if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

if !exists('g:path_to_php')
	let g:path_to_php = 'php'
endif
if !exists('g:path_to_phpunit')
	let g:path_to_phpunit = 'phpunit'
endif
if !exists('g:phpunit_bootstrap')
	let g:phpunit_bootstrap = 'bootstrap.php'
endif
if !exists('g:phpunit_config')
	let g:phpunit_config = 'phpunit.xml'
endif

function! s:PhpUnitSetFile()
	let s:test_file = expand('%:p')
endfunction

function! s:PhpUnitUnsetFile()
	unlet s:test_file
endfunction

function! s:RunPhpUnit()
	let l:file = exists('s:test_file') ? s:test_file : expand('%:p')
	:wa
	exec ':!' . g:path_to_php . ' "' . g:path_to_phpunit . '" --bootstrap "' . g:phpunit_bootstrap . '" -c "' . g:phpunit_config . '" UnitTest "' . l:file . '"'
	call feedkeys('<cr>')
endfunction

command! -nargs=0 PhpUnitSetFile call <SID>PhpUnitSetFile()
command! -nargs=0 PhpUnitUnsetFile call <SID>PhpUnitUnsetFile()
command! -nargs=0 RunPhpUnit call <SID>RunPhpUnit()
noremap <buffer> <F6> :RunPhpUnit<cr>
inoremap <buffer> <F6> <esc>:RunPhpUnit<cr>
