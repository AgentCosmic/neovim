" For neovim to use this config we need to set $VIMINIT environment variable. See README.
" This is the folder where we'll store all the files
let $ROOT = fnamemodify($MYVIMRC, ':h')
set runtimepath+=$ROOT

runtime mswin.vim

" ----- ----- ----- -----
" Behavior
" ----- ----- ----- -----

set ignorecase " Ignore case when searching, but search capital if used
set smartcase " But use it when there is uppercase
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --fixed-strings\ --hidden\ -g\ !.git/*\ -g\ !package-lock.json\ -g\ !Pipfile.lock\ -g\ !node_modules\ -g\ !venv\ -g\ !.venv
set grepformat=%f:%l:%c:%m,%f:%l:%m
set history=50 " Keep 50 lines of command line history
set path+=** " let's you fuzzy :find all files
set wildmenu " Auto complete on command line
set wildignore+=*.swp,.git,*/node_modules/*,*/venv/*,*/.venv/*,*.pyc,*.png,*.jpg,*.gif,*.psd,*.ai,desktop.ini,Thumbs.db " Ignore these files when searching
set hidden " Don't unload buffer when it's hidden
set lazyredraw " Don't redraw while executing macros (good performance config)
set synmaxcol=500 " Don't try to highlight lines longer than this
set signcolumn=yes " always show signcolumns
set colorcolumn=120 " set ruler to show at 120
set cursorline " highlight current line
set previewheight=8 " smaller preview window
set ruler " show the cursor position all the time
set scrolloff=1 " keep padding around cursor
set showcmd " display incomplete commands
set selection=inclusive " include the last character, required by some plugins

" Disable backup litters
set nobackup
set writebackup
" Use custom swap file location
set directory=$ROOT/swap//,.
" Use persistent undo
set undofile
set undodir=$ROOT/undo//,.

" Line number
set numberwidth=4
set relativenumber
set number

" Status line
set laststatus=3 " always show only 1 statusline
set statusline=
set statusline+=%{%&modified?'%#MyStatusLineModified#':'%#MyStatusLineUnmodified#'%} " highlight modified
set statusline+=\ \ |
set statusline+=%#MyStatusLinePath#
set statusline+=\ %f " working directory followed by file path
set statusline+=\ %r%h%w%q%m " flags: readonly, help, preview, list, modified
set statusline+=%= " right align from here
set statusline+=%#MyStatusLinePosition#
set statusline+=\ %l,%c\ ≡\ %L\ | " current line, cursor column, line/total percent
set statusline+=%#MyStatusLineMisc#
set statusline+=\ %{&ff}\ ∴\ %{strlen(&fenc)?&fenc:'none'}\ | " filetype, format, encoding
set statusline+=%#MyStatusLineFiletype#
set statusline+=\ %{&ft}\ |

" Hide command line
" set cmdheight=0

augroup vimrcBehavior
	autocmd!

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	" Also don't do it when the mark is in the first line, that is the default
	" position when opening a file.
	autocmd BufReadPost *
		\ if line("'\"") > 1 && line("'\"") <= line("$") |
		\   exe "normal! g`\"" |
		\ endif

	" Remove trailing whitespace before saving
	autocmd BufWritePre *.css,*.htm,*.html,*.js,*.json,*.py,*.ts,*.tsx,*.jsx,*.yaml,*.yml,*.xml,*.java,*.php,*.vue :%s/\(\s\+\|\)$//e

	" Don't list preview window
	autocmd BufEnter * :call <SID>DelistWindow()
	" Don't list quickfix window
	autocmd FileType qf set nobuflisted

	" Highlight yanked region
	au TextYankPost * lua vim.highlight.on_yank {higroup="Visual", timeout=100, on_visual=true}
augroup END

function! s:DelistWindow()
	if &previewwindow
		set nobuflisted
	endif
endf

" visual paste doesn't replace paste buffer
function! RestoreRegister()
	let @" = s:restore_reg
	return ''
endfunction
function! s:Repl()
	let s:restore_reg = @"
	return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" keep cursor position when changing buffer
augroup keepCursorPosition
	autocmd!
	autocmd BufLeave * let b:winview = winsaveview()
	autocmd BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
augroup END


" ----- ----- ----- -----
" Text and formatting
" ----- ----- ----- -----

" Default to unix line ending
set fileformats=unix,dos

" Wordwrap
set linebreak

" Formatting
set textwidth=119
set formatoptions=croq " only comments

" Indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set nocindent
set list lcs=tab:\|\ " show tab guides

" Folding
set foldnestmax=12
set foldlevel=9 " prefer to be open by default
set nofoldenable " disable by default
" define indent folds then allow manual folding
augroup enhanceFold
    autocmd!
    autocmd BufReadPre * setlocal foldmethod=indent
    autocmd BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END
fun! FoldIndent() abort
    setlocal foldmethod=indent
	normal! za
    setlocal foldmethod=manual
endfun
nnoremap za :call FoldIndent()<cr>

" Disable some native plugins to improve performance
let g:loaded_gzip = 1 " for editing compressed files
let g:loaded_netrwPlugin = 1 " for editing remote files
let g:loaded_tarPlugin = 1 " for browsing tar files
let g:loaded_2html_plugin = 1 " for generating HTML files with syntax highlight
let g:loaded_tutor_mode_plugin = 1 " vim tutor
let g:loaded_zipPlugin = 1 " for browsing zip files


" ----- ----- ----- -----
" Remapping
" ----- ----- ----- -----

" Change leader key
let mapleader = ' '

" Re-select after copying
vnoremap <c-c> "+ygv

" Delete without jumping http://vim.1045645.n5.nabble.com/How-to-delete-range-of-lines-without-moving-cursor-td5713219.html
command! -range D <line1>,<line2>d | norm <c-o>

" Don't use Ex mode, use Q for formatting
map Q gq

" Alternate file switching
nnoremap <bs> <c-^>

" Use 0 to move to first non-whitespace since I already have home button
nnoremap 0 ^
vnoremap 0 ^

" make k and l move one extra character
onoremap l 2l
onoremap h 2h

" Swap quote with backtick so it's easier to move to column
noremap ' `
vnoremap ' `
noremap ` '
vnoremap ` '

" Shorter undo sequence. Use CTRL-G u to break undo sequence. :h i_CTRL-G_u http://vim.wikia.com/wiki/Modified_undo_behavior
" Cannot use surrounds because it will disable delimitmate e.g. ()'"[]
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
inoremap . <c-g>u.
inoremap , <c-g>u,
inoremap = <c-g>u=

" Move line use ctrl-j and ctrl-k http://vim.wikia.com/wiki/Moving_lines_up_or_down
nnoremap <c-j> :m .+1<cr>==
nnoremap <c-k> :m .-2<cr>==
inoremap <c-j> <esc>:m .+1<cr>==gi
inoremap <c-k> <esc>:m .-2<cr>==gi
vnoremap <c-j> :m '>+1<cr>gv=gv
vnoremap <c-k> :m '<-2<cr>gv=gv

" Select last modified/pasted http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> <leader>v '`[' . strpart(getregtype(), 0, 1) . '`]'

" Navigate between windows
noremap <a-j> <c-w>j
noremap <a-k> <c-w>k
noremap <a-h> <c-w>h
noremap <a-l> <c-w>l

" Increment, decrement number
nnoremap <c-up> <C-a>
nnoremap <c-down> <C-x>
nnoremap <c-s-up> 10<C-a>
nnoremap <c-s-down> 10<C-x>

" Shortcuts
nnoremap <leader>s :update<cr>
nnoremap <leader>as :wa<cr>
nnoremap <leader>nh :nohlsearch<cr>
nnoremap <leader>q :q<cr>
vnoremap <leader>p "_dP
nnoremap <leader>ou :update<cr>:source %<cr>
" Substitute
nnoremap <F2> yiw:%s/\<<c-r>0\>/
" Grep
nnoremap <F3> g*Nyiw:cw<cr>:grep <c-r>0
" Delete buffer without closing the split
nnoremap <F4> :bn\|bd #<cr>

" Disable function keys in insert mode
inoremap <F2> <esc><F2>
inoremap <F3> <esc><F3>
inoremap <F4> <esc><F4>
inoremap <F5> <esc><F5>
inoremap <F6> <esc><F6>
inoremap <F7> <esc><F7>
inoremap <F8> <esc><F8>
inoremap <F9> <esc><F9>
inoremap <F10> <esc><F10>

" Highlight when double click
nnoremap <silent> <2-leftmouse> :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<cr>:set hls<cr>viwg<c-h>
" remove double click mapping in help file so we can navigate the link
augroup doubleClick
    autocmd!
    autocmd FileType help :silent! unmap <2-leftmouse>
	autocmd FileType qf :silent! unmap <2-leftmouse>
augroup END

" Get syntax under cursor
noremap <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>

" unmap ctrl-z so we can suspend the app
unmap <c-z>


" ----- ----- ----- -----
" Commands
" ----- ----- ----- -----

command! CdToFile cd %:p:h
command! DeleteControlM %s/$//
command! EVimrc :e $MYVIMRC
command! SS :syntax sync fromstart
command! -nargs=? Count :%s/<f-args>//gn

" edit a macro using cq(macro name)
fun! ChangeReg() abort
	let x = nr2char(getchar())
	call feedkeys("q:ilet @" . x . " = \<c-r>\<c-r>=string(@" . x . ")\<cr>\<esc>0f'", 'n')
endfun
nnoremap cr :call ChangeReg()<cr>


" ----- ----- ----- -----
" TUI/GUI
" ----- ----- ----- -----

if (has("termguicolors"))
	set termguicolors
endif
colorscheme	distinct
" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Make the cursor look nicer
set guicursor+=v:hor50
set guicursor+=a:blinkwait250-blinkon500-blinkoff250

" neovide
if exists("g:neovide")
    set guifont=Hack\ NF:h9
	let g:neovide_scroll_animation_length = 0.2 " not working yet
	let g:neovide_cursor_animation_length=0.1
	let g:neovide_cursor_trail_size = 0.2
	" it always use the wrong size and position
	let g:neovide_remember_window_size = v:false	
	let g:neovide_remember_window_position = v:false	
endif

" ----- ----- ----- -----
" Others
" ----- ----- ----- -----

command! EPlugin :e $ROOT/plugins.lua
luafile $ROOT/plugins.lua
