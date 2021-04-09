" https://github.com/BurntSushi/ripgrep/releases
call plug#begin('$HOME/plugged')
" Universal Vim Functionality
Plug 'duff/vim-bufonly'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'itchyny/vim-cursorword'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-abolish'
Plug 'dyng/ctrlsf.vim'
Plug 'unblevable/quick-scope'
" Programming Related
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'tomtom/tcomment_vim'
Plug 'sickill/vim-pasta'
Plug 'AndrewRadev/sideways.vim'
Plug 'wellle/targets.vim'
Plug 'sheerun/vim-polyglot'
Plug 'nathanaelkane/vim-indent-guides', {'on': ['IndentGuidesEnable', 'IndentGuidesToggle']}
Plug 'Shougo/echodoc.vim' " used by coc
" External Dependency
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'ctrlpvim/ctrlp.vim' " https://github.com/BurntSushi/ripgrep/releases
Plug 'majutsushi/tagbar', { 'on': ['Tagbar', 'TagbarToggle', 'TagbarOpen'] } " https://github.com/universal-ctags/ctags-win32/releases
" Plug 'w0rp/ale'
" Language
Plug 'mattn/emmet-vim'
Plug 'alvan/vim-closetag'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go', 'tag': 'v1.22' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & npm install', 'on': 'MarkdownPreview' }
" GUI
Plug 'norcalli/nvim-colorizer.lua' " only works on neovim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Evaluating
Plug 'tommcdo/vim-exchange'
Plug 'michaeljsmith/vim-indent-object'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'tweekmonster/django-plus.vim'
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

call plug#end()

" ultisnips
let g:UltiSnipsExpandTrigger = '<leader><tab>'


" -----------------------------------------------------------------------------


" BufOnly
nnoremap <c-F4> :BufOnly<cr>

" undotree
cabbrev UT UndotreeToggle

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'

" vim-closetag
let g:closetag_filetypes = 'html,php,vue'

" quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars = 160

" tcomment
nmap <leader>c <c-_><c-_>
vmap <leader>c <c-_><c-_>
" imap <leader>c <c-o><c-_><c-_>

" sideways
noremap <c-h> :SidewaysLeft<cr>
noremap <c-l> :SidewaysRight<cr>

" auto-pairs
augroup AutoPairs
	autocmd!
	autocmd FileType html,vue let b:AutoPairs = AutoPairsDefine({'<!--' : '-->'})
	autocmd FileType css,vue let b:AutoPairs = AutoPairsDefine({'/**' : '*/', '/*' : '*/'})
	autocmd FileType html,htmldjango let b:AutoPairs = AutoPairsDefine({'{%' : '%}'})
	autocmd FileType php let b:AutoPairs = AutoPairsDefine({'<?php' : '?>'})
augroup end
inoremap {, {},<left><left>
inoremap (, (),<left><left>
inoremap [, [],<left><left>

" CtrlSF
let g:ctrlsf_ackprg = 'rg'

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
nnoremap gb :CtrlPBuffer<cr>
nnoremap g/ :CtrlPLine<cr>
nnoremap gm :CtrlPMRU<cr>
" nnoremap gt :CtrlPTag<cr>
let g:ctrlp_buftag_ctags_bin = 'ctags.exe'
" let g:ctrlp_user_command = 'rg %s --files --color=never'



" echodoc
set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'



" coc
" CocInstall coc-css coc-html coc-json coc-tsserver coc-yaml coc-python coc-vetur
" coc-go coc-emmet
let g:coc_config_home = $ROOT . '/coc'
let g:coc_data_home = $ROOT . '/coc'
let g:coc_config_home = $HOME . '/coc'
let g:coc_data_home = $HOME . '/coc'
set updatetime=500 " You will have bad experience for diagnostic messages when it's default 4000.
set shortmess+=c " don't give |ins-completion-menu| messages.
set signcolumn=yes " always show signcolumns
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <tab>
			\ pumvisible() ? "\<c-n>" :
			\ <SID>check_back_space() ? "\<tab>" :
			\ coc#refresh()
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<c-h>"
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> for confirm completion
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
" Mappings
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>r <Plug>(coc-rename)
nnoremap <silent> gt :<c-u>CocList outline<cr>
nnoremap <silent> gT :<c-u>CocList -I symbols<cr>
nnoremap <silent> gD :<c-u>CocList diagnostics<cr>
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap g= :call CocAction('format')<cr>
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
nnoremap <silent> K :call <SID>show_documentation()<cr>
function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
augroup CocGroup
	autocmd!
	" Setup formatexpr specified filetype(s).
	autocmd FileType javascript,json,vue,html,css,go setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	" Auto format and fix import for go
	autocmd BufWritePre *.go :call CocAction('format') | CocCommand editor.action.organizeImport
	autocmd BufWritePre *.vue,*.js :call CocAction('format')
augroup end
" Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)
" Close preview window when completion is done.
" autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif



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
	\ 'css': [],
	\ 'python': ['mypy'],
	\ 'go': [],
\}
" \ 'go': ['golint'],
" \ 'css': ['stylelint'],
let g:ale_python_pyls_executable = 'C:/Python36/Scripts/pyls'
function! SetALEShortcuts()
	" nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
	" nnoremap <buffer> <silent> gd :ALEGoToDefinition<CR>
	nnoremap <buffer> <silent> gf :ALEFix<CR>
	" nnoremap <buffer> <silent> <f3> :ALEFindReferences<CR>
	" nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
	" nnoremap <buffer> <silent> <leader>= :call LanguageClient#textDocument_formatting()<CR>
endfunction()
augroup ALE
  autocmd!
  autocmd FileType javascript,html,css,scss,python,go call SetALEShortcuts()
augroup end
" npm install -g javascript-typescript-langserver vscode-html-languageserver-bin stylelint 
" pip install python-language-server rope mypy flake8 isort



" vim-go
let g:go_code_completion_enabled =  0
let g:go_fmt_autosave = 0
nmap gI <Plug>(go-imports):w<cr>
nmap gV <Plug>(go-vet)
" use for CtrlPTag
augroup VimGo
	autocmd!
	autocmd FileType go nnoremap <buffer> gt :GoDecls<cr>
	autocmd FileType go nnoremap <buffer> gT :GoDeclsDir<cr>
augroup end



" vue
let g:vue_disable_pre_processors=1



" Emmet
let g:user_emmet_leader_key = '<c-y>'
let g:user_emmet_expandabbr_key = '<c-e>'
" let g:user_emmet_expandword_key = '<c-e>'
" let g:user_emmet_complete_tag = 1



" MiniBufExpl
" nnoremap <tab> :MBEbn<cr>
" nnoremap <s-tab> :MBEbp<cr>
" vnoremap <tab> :MBEbn<cr>
" vnoremap <s-tab> :MBEbp<cr>
" inoremap <c-tab> <esc>:MBEbf<cr>
" vnoremap <c-tab> <esc>:MBEbf<cr>
" nnoremap <c-tab> :MBEbf<cr>
" inoremap <c-s-tab> <esc>:MBEbb<cr>
" vnoremap <c-s-tab> <esc>:MBEbb<cr>
" nnoremap <c-s-tab> :MBEbb<cr>
" let g:miniBufExplUseSingleClick = 1
" let g:miniBufExplCycleArround = 1



" nvim-colorizer
lua require'colorizer'.setup({
	\  'css';
	\  'javascript';
	\  'vue';
\ }, { no_names = true })



" airline
let g:airline_theme = 'base16' " for nvim-qt
" let g:airline_theme = 'bubblegum' " for gonvim
let g:airline_extensions = ['tabline']
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s:'
nnoremap <tab> :bn<cr>
vnoremap <tab> :bn<cr>
nnoremap <s-tab> :bp<cr>
vnoremap <s-tab> :bp<cr>
