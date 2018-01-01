" This is the folder where we'll store all the files
let $USER = expand($VIM . '/../../user')
set runtimepath+=$USER

" ----- ----- ----- -----
" Behavior
" ----- ----- ----- -----

runtime mswin.vim
filetype plugin indent on " Important for a lot of things
set incsearch " Do incremental searching
set ignorecase " Ignore case when searching, but search capital if used
set smartcase " But use it when there is uppercase
set grepprg=ag\ --nogroup\ --nocolor\ --column
set history=50 " Keep 50 lines of command line history
set wildmenu " Auto complete on command line
set wildignore+=*.swp,.git,.svn,*.pyc,*.png,*.jpg,*.gif,*.psd,desktop.ini " Ignore these files when searching
set hidden " Don't unload buffer when it's hidden
set lazyredraw " Don't redraw while executing macros (good performance config)
set encoding=utf8 " Set utf8 as standard encoding and en_US as the standard language
set synmaxcol=500 " Don't try to highlight lines longer than this

" Disable backup litters
set nobackup
set writebackup
" Use custom swap file location
set directory=$USER/swap//,.
" Use persistent undo
set undofile
set undodir=$USER/undo//,.

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

	" OmniComplete
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
	autocmd FileType python setlocal omnifunc=python3complete#Complete

	" Remove trailing space before saving
	autocmd BufWritePre *.css,*.htm,*.html,*.js,*.php,*.py :%s/\s\+$//e

	" Delete empty buffers, specially for files opened with --remote option
	" autocmd BufAdd * nested :call <SID>DeleteBufferIfEmpty()
	" command must be nested to other autocommand will also be called,
	" specifically MiniBufExpl https://github.com/fholgado/minibufexpl.vim/issues/90#issuecomment-19815252

	" Don't list preview and quickfix window
	autocmd BufEnter * :call <SID>DelistWindow()
augroup END

function! s:DeleteBufferIfEmpty()
	" If no name and no content
	if bufname('%') == '' && line('$') == 1 && getline(1) == ''
		bwipe
		" This will trigger filetype detection, mainly to trigger syntax highlighting
		doautocmd BufRead
	endif
endfunction

function! s:DelistWindow() 
    if &previewwindow 
        set nobuflisted 
	elseif &filetype == 'qf'
		set nobuflisted
	endif
endf 

" vp doesn't replace paste buffer
function! RestoreRegister()
	let @" = s:restore_reg
	return ''
endfunction
function! s:Repl()
	let s:restore_reg = @"
	return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" keep cursor position when changin buffer
augroup keepCursorPosition
	autocmd!
	autocmd BufLeave * let b:winview = winsaveview()
	autocmd BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
augroup END


" ----- ----- ----- -----
" GUI
" ----- ----- ----- -----

set guifont=Consolas:h9
set background=dark
colorscheme	desert

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax on
set hlsearch

" Status line
set laststatus=2 " always show statusline
set statusline=\ %{getcwd()}\ \ \|\ \ %f " working directory followed by file path
set statusline+=\ %r " readonly flag
set statusline+=\ %m " modified flag
set statusline+=%= " right align from here
set statusline+=%c,\ %l\ \|\ %P\ of\ %L\ " cursor column, line/total percent
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'},\ %{&ff}]\  " encoding, format

" Make the cursor look nicer
set guicursor+=v:hor50
set guicursor+=i:ver1
set guicursor+=a:blinkwait750-blinkon750-blinkoff250

" Line number
set numberwidth=5
set relativenumber
set number

set colorcolumn=80,120 " set ruler to show at column 80 and 120
set cursorline " highlight current line
set guioptions=erR " tabs & right scollbar. No menu, toolbar and bottom scollbar
set guitablabel=%-0.12t%M " format of tab label
set previewheight=8 " smaller preview window
set ruler " show the cursor position all the time
set scrolloff=1 " keep padding around cursor
set showcmd " display incomplete commands
set showtabline=1 " show tabs only if there are more than one


" ----- ----- ----- -----
" Text
" ----- ----- ----- -----

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
set autoindent
set nocindent

" Folding
set foldmethod=indent
set foldnestmax=8
set foldlevel=9 " prefer to be open by default
set nofoldenable " disable by default


" ----- ----- ----- -----
" Remapping
" ----- ----- ----- -----

" Delete without jumping http://vim.1045645.n5.nabble.com/How-to-delete-range-of-lines-without-moving-cursor-td5713219.html
command! -range D <line1>,<line2>d | norm <c-o> 

" Don't use Ex mode, use Q for formatting
" map Q gq

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

" Move line use alt-j and alt-k http://vim.wikia.com/wiki/Moving_lines_up_or_down
nnoremap <a-j> :m .+1<cr>==
nnoremap <a-k> :m .-2<cr>==
inoremap <a-j> <esc>:m .+1<cr>==gi
inoremap <a-k> <esc>:m .-2<cr>==gi
vnoremap <a-j> :m '>+1<cr>gv=gv
vnoremap <a-k> :m '<-2<cr>gv=gv

" Select last modified/pasted http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> <leader>v '`[' . strpart(getregtype(), 0, 1) . '`]'
" Paste then select
" nmap <leader>p p<leader>v

" Navigate between windows
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l

" Increment, decrement number
nnoremap <c-up> <C-a>
nnoremap <c-down> <C-x>
nnoremap <c-s-up> 10<C-a>
nnoremap <c-s-down> 10<C-x>

" Shortcuts
nnoremap <leader>s :update<cr>
nnoremap <leader>a :wa<cr>
nnoremap <leader>h :nohlsearch<cr>
nnoremap <leader>q :q<cr>
vnoremap <leader>p "_dP
nnoremap <leader>o :update<cr>:source %<cr>
" Substitute
nnoremap <F2> yiw:%s/\<<c-r>0\>/
" Grep
nnoremap <F3> g*Nyiw:cw<cr>:grep <c-r>0 
" Delete buffer
nnoremap <F4> :bdelete<cr>
nnoremap <c-F4> :BufOnly<cr>
nnoremap <Space> :CtrlP<cr>

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

" Get syntax under cursor
noremap <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>

"
" ----- ----- ----- -----
" Commands
" ----- ----- ----- -----

command! CdToFile cd %:p:h
command! DeleteControlM %s/$//
command! EVimrc :e $USER/init.vim


" ----- ----- ----- -----
" Plugins
" ----- ----- ----- -----

" checkout https://github.com/Shougo/dein.vim/
call plug#begin('plugged')
" does neovim need this?
" Plug 'embear/vim-localvimrc'
Plug 'fholgado/minibufexpl.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'easymotion/vim-easymotion'
Plug 'sickill/vim-pasta'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'ap/vim-css-color'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'captbaritone/better-indent-support-for-php-with-html'
Plug 'nathanaelkane/vim-indent-guides', {'on': ['IndentGuidesEnable', 'IndentGuidesToggle']}
Plug 'AndrewRadev/sideways.vim'
Plug 'itchyny/vim-cursorword'
Plug 'w0rp/ale'
Plug 'haya14busa/incsearch.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Evaluating
" Plug 'python-mode/python-mode', {'for': 'python'}
Plug 'sbdchd/neoformat', {'on': ['Neoformat']}
Plug 'wellle/targets.vim'

" Plug 'haya14busa/incsearch-fuzzy.vim'
" Plug 'heavenshell/vim-jsdoc.git
" https://github.com/ramitos/jsctags
" https://github.com/ternjs/tern_for_vim
call plug#end()


" airline
let g:airline#extensions#branch#enabled = 0
let g:airline_detect_paste = 0
let g:airline_detect_crypt = 0
let g:airline_extensions = ['quickfix', 'ctrlp', 'whitespace', 'ale']
let g:airline_theme = 'bubblegum'
let g:airline_powerline_fonts = 1
set guifont=Hack:h9

" undotree
cabbrev UT UndotreeToggle

" ale
let g:ale_sign_column_always = 1
let g:ale_linters = {'javascript': ['jshint']}
" let g:ale_lint_on_save = 1
" let g:ale_lint_on_text_changed = 0

" delimitmate
let delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_expand_cr = 1

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'

" Emmet
let g:user_emmet_leader_key = '<c-y>'
let g:user_emmet_expandabbr_key = '<c-e>'
" let g:user_emmet_expandword_key = '<c-e>'
let g:user_emmet_complete_tag = 1

" Comments
nmap <leader>c <c-_><c-_>
" imap <leader>c <c-o><c-_><c-_>
vmap <leader>c <c-_><c-_>

" localvimrc
let g:localvimrc_name = '_lvimrc'
let g:localvimrc_count = 1
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" ctrlp
let g:ctrlp_show_hidden = 1
let g:ctrlp_open_multiple_files = 'i'
let g:ctrlp_by_filename = 1
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](\..+)$',
	\ 'file': '\v[\/](Thumbs.db)$'
\ }
nnoremap gt :CtrlPBufTag<cr>
nnoremap gT :CtrlPBufTagAll<cr>
nnoremap gb :CtrlPBuffer<cr>
nnoremap g/ :CtrlPLine<cr>

" Tagbar
cabbrev TT TagbarToggle
let g:tagbar_sort = 0
let g:tagbar_type_php  = {
	\ 'ctagstype': 'php',
	\ 'kinds': [
		\ 'i:interfaces',
		\ 'c:classes',
		\ 'd:constant definitions',
		\ 'f:functions',
		\ 'j:javascript functions:1'
	\ ]
\ }

" deoplete
inoremap <expr> <tab> pumvisible() ? '<c-n>' : '<tab>'
inoremap <expr> <s-tab> pumvisible() ? '<c-p>' : '<s-tab>'
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 1
let g:deoplete#min_keyword_length = 3
let g:deoplete#sources#syntax#min_keyword_length = 3
if !exists('g:deoplete#delimiter_patterns')
	let g:deoplete#delimiter_patterns= {}
endif
let g:deoplete#delimiter_patterns.php = ['\', '::', '->']


" MiniBufExpl
nnoremap <tab> :MBEbn<cr>
nnoremap <s-tab> :MBEbp<cr>
vnoremap <tab> :MBEbn<cr>
vnoremap <s-tab> :MBEbp<cr>
inoremap <c-tab> <esc>:MBEbf<cr>
vnoremap <c-tab> <esc>:MBEbf<cr>
nnoremap <c-tab> :MBEbf<cr>
inoremap <c-s-tab> <esc>:MBEbb<cr>
vnoremap <c-s-tab> <esc>:MBEbb<cr>
nnoremap <c-s-tab> :MBEbb<cr>
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplCycleArround = 1
" For third party colorschemes
" hi MBENormal guifg=fg gui=none
" hi MBEChanged guifg=fg gui=italic
" hi link MBEVisibleNormal MBENormal
" hi link MBEVisibleChanged MBEChanged
" hi MBEVisibleActiveNormal gui=bold
" hi MBEVisibleActiveChanged gui=bold,italic


" incsearch
map /  <plug>(incsearch-forward)
map ?  <plug>(incsearch-backward)
map g/ <plug>(incsearch-stay)
" incsearch-fuzzy
map z/ <plug>(incsearch-fuzzy-/)
map z? <plug>(incsearch-fuzzy-?)
map zg/ <plug>(incsearch-fuzzy-stay)


" sideways
noremap <a-h> :SidewaysLeft<cr>
noremap <a-l> :SidewaysRight<cr>



" ----- ----- ----- -----
" Others
" ----- ----- ----- -----

" Code taken from TagbarToggle
" Get the number of the scratch buffer. Will create one if needed.
function! GetScratchBuffer(name) abort
    let buffer_number = bufwinnr(a:name)
    if buffer_number == -1
		" create buffer
		let eventignore_save = &eventignore
		set eventignore=all
		execute 'silent keepalt belowright vertical 60split ' . a:name
		let &eventignore = eventignore_save

		setlocal noreadonly " in case the "view" mode is used
		setlocal buftype=nofile
		setlocal bufhidden=hide
		setlocal noswapfile
		setlocal nobuflisted
		setlocal nomodifiable
		setlocal nolist
		setlocal nonumber
		setlocal winfixwidth
		setlocal textwidth=0
		setlocal nocursorline
		setlocal nocursorcolumn
		setlocal nospell

		if exists('+relativenumber')
			setlocal norelativenumber
		endif

		setlocal nofoldenable
		setlocal foldcolumn=0
		" Reset fold settings in case a plugin set them globally to something
		" expensive. Apparently 'foldexpr' gets executed even if 'foldenable' is
		" off, and then for every appended line (like with :put).
		setlocal foldmethod&
		setlocal foldexpr&

		let buffer_number = bufwinnr(a:name)
    endif
	return buffer_number
endfunction

" Replace the content of the buffer
function! ReplaceContent(buffer_number, content) abort
	" focus on buffer
	let original_buffer = winnr()
    if original_buffer == a:buffer_number
        let in_buffer = 1
    else
        let in_buffer = 0
        call s:winexec(a:buffer_number . 'wincmd w')
    endif

    let lazyredraw_save = &lazyredraw
    set lazyredraw
    let eventignore_save = &eventignore
    set eventignore=all

    setlocal modifiable

    silent %delete _

    " Delete empty lines at the end of the buffer
    for linenr in range(line('$'), 1, -1)
        if getline(linenr) =~ '^$'
            execute 'silent ' . linenr . 'delete _'
        else
            break
        endif
    endfor

	" render
	silent put = a:content

    setlocal nomodifiable

    let &lazyredraw  = lazyredraw_save
    let &eventignore = eventignore_save

	" return to previous buffer
    if !in_buffer
        call s:winexec(original_buffer . 'wincmd w')
    endif
endfunction

function! s:winexec(cmd) abort
    let eventignore_save = &eventignore
    set eventignore=BufEnter
    execute a:cmd
    let &eventignore = eventignore_save
endfunction


" BufOnly from https://github.com/duff/vim-bufonly
command! -nargs=? -complete=buffer -bang BufOnly :call <SID>BufOnly('<args>', '<bang>')
function! s:BufOnly(buffer, bang)
	if a:buffer == ''
		" No buffer provided, use the current buffer.
		let buffer = bufnr('%')
	elseif (a:buffer + 0) > 0
		" A buffer number was provided.
		let buffer = bufnr(a:buffer + 0)
	else
		" A buffer name was provided.
		let buffer = bufnr(a:buffer)
	endif

	if buffer == -1
		echohl ErrorMsg
		echomsg "No matching buffer for" a:buffer
		echohl None
		return
	endif

	let last_buffer = bufnr('$')

	let delete_count = 0
	let n = 1
	while n <= last_buffer
		if n != buffer && buflisted(n)
			if a:bang == '' && getbufvar(n, '&modified')
				echohl ErrorMsg
				echomsg 'No write since last change for buffer'
							\ n '(add ! to override)'
				echohl None
			else
				silent exe 'bdel' . a:bang . ' ' . n
				if ! buflisted(n)
					let delete_count = delete_count+1
				endif
			endif
		endif
		let n = n+1
	endwhile

	if delete_count == 1
		echomsg delete_count "buffer deleted"
	elseif delete_count > 1
		echomsg delete_count "buffers deleted"
	endif

endfunction


" Vim default diff does not work well
set diffexpr=MyDiff()
function! MyDiff()
	let opt = '-a --binary '
	if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	let arg1 = v:fname_in
	if arg1 =~ ' ' | let arg1 = '\"' . arg1 . '\"' | endif
	let arg2 = v:fname_new
	if arg2 =~ ' ' | let arg2 = '\"' . arg2 . '\"' | endif
	let arg3 = v:fname_out
	if arg3 =~ ' ' | let arg3 = '\"' . arg3 . '\"' | endif
	let eq = ''
	if $VIMRUNTIME =~ ' '
		if &sh =~ '\<cmd'
			let cmd = '\"' . $VIMRUNTIME . '\diff\"'
			let eq = '\"\"'
		else
			let cmd = substitute($VIMRUNTIME, ' ', '\" ', '') . '\diff\"'
		endif
	else
		let cmd = $VIMRUNTIME . '\diff'
	endif
	silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction
