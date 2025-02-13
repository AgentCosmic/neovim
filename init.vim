" For neovim to use this config we need to set $VIMINIT environment variable. See README.
" This is the folder where we'll store all the files
let $ROOT = fnamemodify($MYVIMRC, ':h')
set runtimepath+=$ROOT

" ----- ----- ----- -----
" Behavior
" ----- ----- ----- -----

set ignorecase " Ignore case when searching, but search capital if used
set smartcase " But use it when there is uppercase
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --fixed-strings\ --hidden\ -g\ !.git/*\ -g\ !package-lock.json\ -g\ !poetry.lock\ -g\ !requirements.txt
set grepformat=%f:%l:%c:%m,%f:%l:%m
set history=50 " Keep 50 lines of command line history
set path+=** " let's you fuzzy :find all files
set wildmenu " Auto complete on command line
set wildignore+=*.swp,.git,*/node_modules/*,*/.venv/*,*/venv/*,*.pyc,*.png,*.jpg,*.jpeg,*.gif,desktop.ini,Thumbs.db " Ignore these files when searching
set hidden " Don't unload buffer when it's hidden
set lazyredraw " Don't redraw while executing macros (good performance config)
set synmaxcol=500 " Don't try to highlight lines longer than this
set signcolumn=yes " always show signcolumns
set cursorline " highlight current line
set previewheight=8 " smaller preview window
set ruler " show the cursor position all the time
set scrolloff=4 " keep padding around cursor
set showcmd " display incomplete commands
set selection=inclusive " include the last character, required by some plugins
set inccommand=split " live preview of substitutions in a split

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
set statusline+=%{%&modified?'%#StatusModified#':'%#StatusUnmodified#'%} " highlight modified
set statusline+=\ \ %{%&modified?'%#StatusArrowModified#':'%#StatusArrowUnmodified#'%}|
set statusline+=%#StatusPath#
set statusline+=\ %f " working directory followed by file path
set statusline+=\ %r%h%w%q%m\  " flags: readonly, help, preview, list, modified
set statusline+=%#StatusArrowPath#%#StatusArrowPath2#
set statusline+=%= " right align from here
set statusline+=%#StatusPositionArrow#%#StatusPositionArrow2#
set statusline+=%#StatusPosition#
set statusline+=\ %l,%c\ 󰦨\ %L\ | " current line, cursor column, line/total percent
set statusline+=%#StatusMiscArrow#
set statusline+=%#StatusMisc#
set statusline+=\ %{&ff}\ 󰇙\ %{strlen(&fenc)?&fenc:'none'}\ | " filetype, format, encoding
set statusline+=%#StatusFiletypeArrow#
set statusline+=%#StatusFiletype#
set statusline+=\ 󰅩\ %{&ft}\ |

augroup vimrcBehavior
	autocmd!

	" When editing a file, always jump to the last known cursor position. Don't do it when the position is invalid or
	" when inside an event handler (happens when dropping a file on gvim). Also don't do it when the mark is in the
	" first line, that is the default position when opening a file.
	autocmd BufReadPost *
		\ if line("'\"") > 1 && line("'\"") <= line("$") |
		\   exe "normal! g`\"" |
		\ endif

	" Remove trailing whitespace before saving
	autocmd BufWritePre *.css,*.htm,*.html,*.js,*.json,*.py,*.ts,*.tsx,*.jsx,*.yaml,*.yml,*.toml,*.xml,*.java,*.php,*.vue,*.go :%s/\(\s\+\|\)$//e

	" Don't list quickfix window, always move quickfix window to bottom, fix the buffer to the window, q to close
	autocmd FileType qf set nobuflisted | wincmd J | setlocal winfixbuf | nnoremap <buffer> q :q<cr>

	" automatically open quickfix and loclist window when it changes
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow

	" Highlight yanked region
	autocmd TextYankPost * lua vim.highlight.on_yank {higroup="Visual", timeout=200, on_visual=true}

	" fix missing sql commentstring
	autocmd FileType sql setlocal commentstring=--\ %s
augroup END

" so visual paste doesn't replace paste buffer
function! RestoreRegister()
	let @" = s:restore_reg
	return ''
endfunction
function! s:Repl()
	let s:restore_reg = @"
	return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" enable cfilter plugin for filtering quickfix list
packadd cfilter

" Disable some native plugins to improve performance
let g:loaded_gzip = 1 " for editing compressed files
let g:loaded_netrwPlugin = 1 " for editing remote files
let g:loaded_tarPlugin = 1 " for browsing tar files
let g:loaded_2html_plugin = 1 " for generating HTML files with syntax highlight
let g:loaded_tutor_mode_plugin = 1 " vim tutor
let g:loaded_zipPlugin = 1 " for browsing zip files


" ----- ----- ----- -----
" Text and formatting
" ----- ----- ----- -----

" Default to unix line ending
set fileformats=unix,dos

" Wordwrap
set linebreak
set breakindent " indent line after breaking
let &showbreak = 'Ĺ '
set breakindentopt=sbr,list:2

" Formatting
set textwidth=119
set formatoptions=crqnj " auto formatting for comments and list

" Indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set nocindent
" Auto tab guides for 4 and 2 spaces
set list listchars=tab:▏\ ,leadmultispace:▏\ \ \ ,
function! s:UpdateLead()
	if (&tabstop == 2)
        setlocal listchars=leadmultispace:▏\ ,
    endif
endfun
augroup indentGuide
    autocmd!
    autocmd OptionSet tabstop call s:UpdateLead()
    autocmd BufEnter * call s:UpdateLead()
augroup END

" Folding
set foldmethod=indent
set foldnestmax=12
set foldlevel=9 " prefer to be open by default
set nofoldenable " disable by default


" ----- ----- ----- -----
" Remapping
" ----- ----- ----- -----

" Change leader key
let mapleader = ' '

" Re-select after copying
vnoremap <c-c> "+ygv

" Paste from clipboard
imap <c-v> <esc>"+p']']a
cnoremap <c-v> <c-r>+

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

" Move line use alt-j and alt-k http://vim.wikia.com/wiki/Moving_lines_up_or_down
nnoremap <a-j> :m .+1<cr>==
nnoremap <a-k> :m .-2<cr>==
inoremap <a-j> <esc>:m .+1<cr>==gi
inoremap <a-k> <esc>:m .-2<cr>==gi
vnoremap <a-j> :m '>+1<cr>gv=gv
vnoremap <a-k> :m '<-2<cr>gv=gv

" Select last modified/pasted http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> <leader>v '`[' . strpart(getregtype(), 0, 1) . '`]'

" Navigate between windows
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l

" Increment, decrement number
nnoremap <a-up> <C-a>
nnoremap <a-down> <C-x>
nnoremap <a-s-up> 10<C-a>
nnoremap <a-s-down> 10<C-x>

" Shortcuts
nnoremap <leader>s :update<cr>
nnoremap <leader>as :wa<cr>
nnoremap <leader>nh :nohlsearch<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>ou :update<cr>:source %<cr>
noremap <leader>y "+y
" Delete buffer without closing the split
nnoremap <leader>d :bn\|bd #<cr>
" Substitute
nnoremap <F2> yiw:%s/\<<c-r>0\>/<c-r>0
" Grep
nnoremap <F3> g*Nyiw:cw<cr>:Grep <c-r>0
" Save with ctrl-s
noremap <silent> <c-s> :update<cr>
vnoremap <silent> <c-s> <c-c>:update<cr>
inoremap <silent> <c-s> <c-o>:update<cr>
" Comment
nmap <leader>c gcc

" don't jump when search
nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr>

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


" ----- ----- ----- -----
" Commands
" ----- ----- ----- -----

command! CdToFile cd %:p:h
command! DeleteControlM %s/$//
command! EVimrc :e $MYVIMRC
command! SS :syntax sync fromstart
command! CopyPath :let @+ = expand("%") | let @" = expand("%")
command! SpaceToTab :set smartindent noexpandtab tabstop=4 shiftwidth=4 | retab!
command! TabToSpace :set expandtab | retab!
command! BufOnly :%bd | e# | bd#

" Edit a macro using cq(macro name)
function! ChangeReg() abort
	let x = nr2char(getchar())
	call feedkeys("q:ilet @" . x . " = \<c-r>\<c-r>=string(@" . x . ")\<cr>\<esc>0f'", 'n')
endfun
nnoremap cr :call ChangeReg()<cr>

" Add :gr as a shortcut to run :grep without needing to press <cr>
" https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
function! Grep(...)
	return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
command! -nargs=+ -complete=file -bar Grep cgetexpr Grep(<f-args>)
cnoreabbrev <expr> gr  (getcmdtype() ==# ':' && getcmdline() ==# 'gr')  ? 'Grep' : 'grep'

" When using `dd` in the quickfix list, remove the item from the quickfix list.
function! RemoveQFItem(mode) range abort
  let l:qf_list = getqflist()

  " distinguish mode for getting delete index and delete count
  if a:mode == 'v'
    let l:del_qf_idx = getpos("'<")[1] - 1
    let l:del_ct = getpos("'>")[1] - l:del_qf_idx
  else
    let l:del_qf_idx = line('.') - 1
    let l:del_ct = v:count > 1 ? v:count : 1
  endif

  " delete lines and update quickfix
  for item in range(l:del_ct)
    call remove(l:qf_list, l:del_qf_idx)
  endfor
  call setqflist(l:qf_list, 'r')

  if len(l:qf_list) > 0
    execute l:del_qf_idx + 1 . 'cfirst'
    copen
  else
    cclose
  endif
endfunction

autocmd FileType qf nmap <buffer> dd :call RemoveQFItem('n')<cr>
autocmd FileType qf vmap <buffer> dd :call RemoveQFItem('v')<cr>


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

" ----- ----- ----- -----
" Others
" ----- ----- ----- -----

command! EPlugin :e $ROOT/plugins.lua
luafile $ROOT/plugins.lua
