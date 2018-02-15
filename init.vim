" This is the folder where we'll store all the files
let $USER = expand($VIM . '/../../user')
let $CACHE = $USER . '/cache'
set runtimepath+=$USER

" ----- ----- ----- -----
" Behavior
" ----- ----- ----- -----

runtime mswin.vim
filetype plugin indent on " Important for a lot of things
set incsearch " Do incremental searching
set ignorecase " Ignore case when searching, but search capital if used
set smartcase " But use it when there is uppercase
set grepprg=rg\ --vimgrep\ --no-heading
set grepformat=%f:%l:%c:%m,%f:%l:%m
set history=50 " Keep 50 lines of command line history
set wildmenu " Auto complete on command line
set wildignore+=*.swp,.git,.svn,*.pyc,*.png,*.jpg,*.gif,*.psd,desktop.ini,Thumbs.db " Ignore these files when searching
set hidden " Don't unload buffer when it's hidden
set lazyredraw " Don't redraw while executing macros (good performance config)
set encoding=utf8 " Set utf8 as standard encoding and en_US as the standard language
set synmaxcol=500 " Don't try to highlight lines longer than this

" Disable backup litters
set nobackup
set writebackup
" Use custom swap file location
set directory=$CACHE/swap//,.
" Use persistent undo
set undofile
set undodir=$CACHE/undo//,.

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

" function! s:DeleteBufferIfEmpty()
" 	" If no name and no content
" 	if bufname('%') == '' && line('$') == 1 && getline(1) == ''
" 		bwipe
" 		" This will trigger filetype detection, mainly to trigger syntax highlighting
" 		doautocmd BufRead
" 	endif
" endfunction

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

" keep cursor position when changing buffer
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

" Line number
set numberwidth=5
set relativenumber
set number

set colorcolumn=80,120 " set ruler to show at column 80 and 120
set cursorline " highlight current line
set previewheight=8 " smaller preview window
set ruler " show the cursor position all the time
set scrolloff=1 " keep padding around cursor
set showcmd " display incomplete commands
set showtabline=1 " show tabs only if there are more than one

" TODO doesn't work in neovim-qt
" Make the cursor look nicer
set guicursor+=v:hor50
set guicursor+=i:ver1
set guicursor+=a:blinkwait750-blinkon750-blinkoff250
set guioptions=erR " tabs & right scollbar. No menu, toolbar and bottom scollbar
set guitablabel=%-0.12t%M " format of tab label


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
nnoremap <c-j> :m .+1<cr>==
nnoremap <c-k> :m .-2<cr>==
inoremap <c-j> <esc>:m .+1<cr>==gi
inoremap <c-k> <esc>:m .-2<cr>==gi
vnoremap <c-j> :m '>+1<cr>gv=gv
vnoremap <c-k> :m '<-2<cr>gv=gv

" Select last modified/pasted http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> <leader>v '`[' . strpart(getregtype(), 0, 1) . '`]'
" Paste then select
" nmap <leader>p p<leader>v

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
call plug#begin('$USER/plugged')
" does neovim need this?
" Plug 'embear/vim-localvimrc'
Plug 'duff/vim-bufonly'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'itchyny/vim-cursorword'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
" Programming Related
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'tomtom/tcomment_vim'
Plug 'sickill/vim-pasta'
Plug 'AndrewRadev/sideways.vim'
Plug 'nathanaelkane/vim-indent-guides', {'on': ['IndentGuidesEnable', 'IndentGuidesToggle']}
" External Dependency
Plug 'ctrlpvim/ctrlp.vim' " https://github.com/BurntSushi/ripgrep/releases
Plug 'majutsushi/tagbar' " https://github.com/universal-ctags/ctags-win32/releases
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " python, pip3 install neovim
" GUI
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Language
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'
Plug 'pangloss/vim-javascript'
Plug 'captbaritone/better-indent-support-for-php-with-html'
" Evaluating
Plug 'wellle/targets.vim'
" Plug 'heavenshell/vim-jsdoc.git

Plug 'autozimu/LanguageClient-neovim', {
	\ 'branch': 'next',
	\ 'do': 'powershell -executionpolicy bypass -File install.ps1',
	\ }
Plug 'adoy/vim-php-refactoring-toolbox'
" Plug 'junegunn/fzf'
" Plug 'junegunn/fzf.vim'
call plug#end()



" LSP http://langserver.org/
let g:LanguageClient_windowLogMessageLevel = "Log"
let g:LanguageClient_loggingLevel = 'DEBUG'
" must be full path
let g:LanguageClient_serverCommands = {
	\ 'javascript': ['C:/Users/Dalton/AppData/Roaming/npm/javascript-typescript-stdio.cmd'],
	\ 'html': ['C:/Users/Dalton/AppData/Roaming/npm/html-languageserver.cmd', '--stdio'],
	\ 'css': ['C:/Users/Dalton/AppData/Roaming/npm/css-languageserver.cmd', '--stdio'],
	\ 'scss': ['C:/Users/Dalton/AppData/Roaming/npm/css-languageserver.cmd', '--stdio'],
	\ 'python': ['C:/Python/36/Scripts/pyls.exe'],
	\ }
	" \ 'php': ['D:/Vim/home/plugged/LanguageClient-neovim/wrapper-server.cmd'],
	" \ 'php': ['C:/php-7.0.27/php.exe', 'D:/Vim/home/language-servers/php/bin/php-language-server.php'],
autocmd FileType javascript,html,css,scss,python nnoremap <buffer> <silent> K :call LanguageClient_textDocument_hover()<CR>
autocmd FileType javascript,html,css,scss,python nnoremap <buffer> <silent> gd :call LanguageClient_textDocument_definition()<CR>
autocmd FileType javascript,html,css,scss,python nnoremap <buffer> <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
autocmd FileType javascript,html,css,scss,python nnoremap <buffer> <silent> <leader>= :call LanguageClient_textDocument_formatting()<cr>
" npm install -g javascript-typescript-langserver vscode-html-languageserver-bin vscode-css-languageserver-bin
" pip install python-language-server

" PHP Refactoring Toolbox
let g:vim_php_refactoring_use_default_mapping = 0
nnoremap <unique> <Leader>rv :call PhpRenameLocalVariable()<CR>
nnoremap <unique> <Leader>rp :call PhpExtractClassProperty()<CR>
nnoremap <unique> <Leader>ru :call PhpExtractUse()<CR>
nnoremap <unique> <Leader>ruu :call PhpDetectUnusedUseStatements()<CR>



" localvimrc
" let g:localvimrc_name = '_lvimrc'
" let g:localvimrc_count = 1
" let g:localvimrc_sandbox = 0
" let g:localvimrc_ask = 0

" BufOnly
nnoremap <c-F4> :BufOnly<cr>

" undotree
cabbrev UT UndotreeToggle

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'

" incsearch
map /  <plug>(incsearch-forward)
map ?  <plug>(incsearch-backward)



" delimitmate
let delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_expand_cr = 1

" tcomment
nmap <leader>c <c-_><c-_>
vmap <leader>c <c-_><c-_>
" imap <leader>c <c-o><c-_><c-_>

" sideways
noremap <c-h> :SidewaysLeft<cr>
noremap <c-l> :SidewaysRight<cr>

" ctrlp
let g:ctrlp_cache_dir = $CACHE . '/ctrlp'
let g:ctrlp_map = '<space>'
let g:ctrlp_show_hidden = 1
let g:ctrlp_open_multiple_files = 'i'
let g:ctrlp_by_filename = 1
let g:ctrlp_match_current_file = 0
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](\..+)$',
			\ 'file': '\v[\/](.+\.min\.(css|js))$'
\ }
let g:user_command_async = 1
let g:ctrlp_search_options = '-g "!*.jpg" -g "!*.png" -g "!*.gif" -g "!*.psd" -g "!*.ai"' " search options for ripgrep to reuse in other vimrc
let g:ctrlp_user_command = {
			\ 'types': {
				\ 1: ['.git', 'cd %s && git ls-files | rg --files --color=never ' . g:ctrlp_search_options],
			\ },
			\ 'fallback': 'rg %s --files --color=never ' . g:ctrlp_search_options
			\ }
nnoremap gt :CtrlPBufTag<cr>
nnoremap gT :CtrlPBufTagAll<cr>
nnoremap gb :CtrlPBuffer<cr>
nnoremap g/ :CtrlPLine<cr>
nnoremap gm :CtrlPMRU<cr>" 
" let g:ctrlp_user_command = 'rg %s --files --color=never'

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


" airline
let g:airline#extensions#branch#enabled = 0
let g:airline_detect_paste = 0
let g:airline_detect_crypt = 0
let g:airline_extensions = ['quickfix', 'ctrlp', 'whitespace', 'ale', 'tabline']
let g:airline_theme = 'bubblegum'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1
nnoremap <tab> :bn<cr>
nnoremap <s-tab> :bp<cr>
vnoremap <tab> :bn<cr>
vnoremap <s-tab> :bp<cr>
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
" let g:airline_powerline_fonts = 1
" set guifont=Hack:h9


" Emmet
let g:user_emmet_leader_key = '<c-y>'
let g:user_emmet_expandabbr_key = '<c-e>'
" let g:user_emmet_expandword_key = '<c-e>'
let g:user_emmet_complete_tag = 1



" ----- ----- ----- -----
" Others
" ----- ----- ----- -----

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
