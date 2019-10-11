" checkout https://github.com/Shougo/dein.vim/
" https://github.com/BurntSushi/ripgrep/releases
call plug#begin('$USER/plugged')
" does neovim need this?
" Plug 'embear/vim-localvimrc'
Plug 'duff/vim-bufonly'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'itchyny/vim-cursorword'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-abolish'
" Programming Related
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'tomtom/tcomment_vim'
Plug 'sickill/vim-pasta'
Plug 'AndrewRadev/sideways.vim'
Plug 'wellle/targets.vim'
Plug 'nathanaelkane/vim-indent-guides', {'on': ['IndentGuidesEnable', 'IndentGuidesToggle']}
Plug 'Shougo/echodoc.vim' " used by coc
" External Dependency
Plug 'neoclide/coc.nvim', { 'tag': '*', 'do': { -> coc#util#install() } } " install yarn first
Plug 'ctrlpvim/ctrlp.vim' " https://github.com/BurntSushi/ripgrep/releases
Plug 'majutsushi/tagbar', { 'on': ['Tagbar', 'TagbarToggle', 'TagbarOpen'] } " https://github.com/universal-ctags/ctags-win32/releases
Plug 'w0rp/ale'
" GUI
" Plug 'fholgado/minibufexpl.vim'
" Language
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'
Plug 'pangloss/vim-javascript'
Plug 'alvan/vim-closetag'
Plug 'captbaritone/better-indent-support-for-php-with-html'
Plug 'pearofducks/ansible-vim'
Plug 'posva/vim-vue', { 'for': 'vue' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'on': 'MarkdownPreview' }
Plug 'dyng/ctrlsf.vim'
" Evaluating
Plug 'unblevable/quick-scope'
Plug 'tommcdo/vim-exchange'
Plug 'leafgarland/typescript-vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }
Plug 'ap/vim-buftabline'
call plug#end()


" QuickScope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars = 160
highlight QuickScopePrimary guifg='#f1ede4' gui=underline
highlight QuickScopeSecondary guifg='#94918a' gui=underline

" ultisnips
let g:UltiSnipsExpandTrigger = '<leader><tab>'


" -----------------------------------------------------------------------------


" localvimrc
let g:localvimrc_name = '_lvimrc'
let g:localvimrc_count = 1
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" BufOnly
nnoremap <c-F4> :BufOnly<cr>

" undotree
cabbrev UT UndotreeToggle

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'

" vim-closetag
let g:closetag_filetypes = 'html,php,vue'

" tcomment
nmap <leader>c <c-_><c-_>
vmap <leader>c <c-_><c-_>
" imap <leader>c <c-o><c-_><c-_>

" sideways
noremap <c-h> :SidewaysLeft<cr>
noremap <c-l> :SidewaysRight<cr>

" ctrlp
let g:ctrlp_map = '<space>'
let g:ctrlp_show_hidden = 1
let g:ctrlp_open_multiple_files = 'i'
let g:ctrlp_by_filename = 1
let g:ctrlp_match_current_file = 0
let g:ctrlp_custom_ignore = {
			\ 'dir': '\v[\/](\..+|node_modules|__pycache__)$',
			\ 'file': '\v[\/](.+\.min\.(css|js))$'
			\ }
let g:user_command_async = 1
let g:ctrlp_search_options = '-g "!*.jpg" -g "!*.png" -g "!*.gif" -g "!*.psd" -g "!*.ai" -g "!node_modules" -g "!__pycache__" -g "!venv"' " search options for ripgrep to reuse in other vimrc
let g:ctrlp_user_command = {
			\ 'types': {
				\ 1: ['.git', 'cd %s && git ls-files -- . ":!:*.jpg" . ":!:*.png" . ":!:*.psd" . ":!:*.ai"'],
			\ },
			\ 'fallback': 'rg %s --files --color=never ' . g:ctrlp_search_options
			\ }
nnoremap gt :CtrlPBufTag<cr>
nnoremap gT :CtrlPBufTagAll<cr>
nnoremap gb :CtrlPBuffer<cr>
nnoremap g/ :CtrlPLine<cr>
nnoremap gm :CtrlPMRU<cr>
" use exuberant ctags because universal ctags isn't supported
let g:ctrlp_buftag_ctags_bin = 'ectags.exe'
" gotags doesn't work now
let g:ctrlp_buftag_types = {
\ 'go'         : '--language-force=go --golang-types=ftv',
\ }
" let g:ctrlp_user_command = 'rg %s --files --color=never'



" CtrlSF
let g:ctrlsf_ackprg = 'rg'



" echodoc
set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'



" coc
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=500
" don't give |ins-completion-menu| messages.
set shortmess+=c
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
	if &filetype == 'vim'
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
" Highlight symbol under cursor on CursorHold
if exists('CocActionAsync')
	autocmd CursorHold * silent call CocActionAsync('highlight')
endif
" Remap for rename current word
nmap <leader>r <Plug>(coc-rename)
" Remap for format selected region
nmap g= :call CocAction('format')<cr>
augroup CocGroup
	autocmd!
	" Setup formatexpr specified filetype(s).
	autocmd FileType typescript,json,vue setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap ga <Plug>(coc-codeaction-selected)
nmap ga <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)
" Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif



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
" go get -u github.com/jstemmer/gotags
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

" ale
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 0
let g:ale_open_list = 'on_save' " auto open and close location list on save
let g:ale_list_window_size = 5
" let g:ale_fix_on_save = 1
let g:ale_fixers = {
	\ 'javascript': ['eslint'],
	\ 'python': ['isort'],
	\ 'go': [],
\}
let g:ale_linters = {
	\ 'javascript': [],
	\ 'css': ['stylelint'],
	\ 'python': ['mypy'],
	\ 'go': ['golint'],
\}
let g:ale_python_pyls_executable = 'C:/Python36/Scripts/pyls'
function! SetALEShortcuts()
	" nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
	" nnoremap <buffer> <silent> gd :ALEGoToDefinition<CR>
	nnoremap <buffer> <silent> gf :ALEFix<CR>
	" nnoremap <buffer> <silent> <f3> :ALEFindReferences<CR>
	nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
	" nnoremap <buffer> <silent> <leader>= :call LanguageClient#textDocument_formatting()<CR>
endfunction()
augroup ALE
  autocmd!
  autocmd FileType javascript,html,css,scss,python,go call SetALEShortcuts()
augroup END
" npm install -g javascript-typescript-langserver vscode-html-languageserver-bin stylelint 
" pip install python-language-server rope mypy flake8 isort



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


" Vim Go
let g:go_code_completion_enabled =  0
let g:go_fmt_autosave = 0
nmap gI <Plug>(go-imports):w<cr>
nmap gV <Plug>(go-vet)



" vue
let g:vue_disable_pre_processors=1



" Emmet
let g:user_emmet_leader_key = '<c-y>'
let g:user_emmet_expandabbr_key = '<c-e>'
" let g:user_emmet_expandword_key = '<c-e>'
let g:user_emmet_complete_tag = 1

" fzf
" Plug 'junegunn/fzf'
" Plug 'junegunn/fzf.vim'
" nnoremap <space> :Files<cr>
" nnoremap gt :BTags<cr>
" nnoremap gT :Tags<cr>
" nnoremap gb :Buffers<cr>
" nnoremap g/ :Lines<cr>
" nnoremap gh :History<cr> 
" nnoremap gm :Marks<cr> 
" nnoremap <c-p> :Commands<cr> 

nnoremap <tab> :bn<cr>
nnoremap <s-tab> :bp<cr>
vnoremap <tab> :bn<cr>
vnoremap <s-tab> :bp<cr>
inoremap <c-tab> <esc>:bf<cr>
vnoremap <c-tab> <esc>:bf<cr>
nnoremap <c-tab> :bf<cr>
inoremap <c-s-tab> <esc>:bb<cr>
vnoremap <c-s-tab> <esc>:bb<cr>
nnoremap <c-s-tab> :bb<cr>
