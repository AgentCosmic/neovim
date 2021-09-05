" https://github.com/BurntSushi/ripgrep/releases
call plug#begin('$HOME/plugged')
" Universal Vim Functionality
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'tpope/vim-abolish'
Plug 'dyng/ctrlsf.vim'
Plug 'unblevable/quick-scope'
Plug 'wellle/targets.vim'
Plug 'rrethy/vim-illuminate'
Plug 'phaazon/hop.nvim'
Plug 'ctrlpvim/ctrlp.vim'
" Programming Related
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat' " so vim-surround can repeat with dot command
Plug 'jiangmiao/auto-pairs'
Plug 'tomtom/tcomment_vim'
Plug 'sickill/vim-pasta'
Plug 'AndrewRadev/sideways.vim'
Plug 'sheerun/vim-polyglot'
Plug 'michaeljsmith/vim-indent-object'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'alvan/vim-closetag'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'mattn/emmet-vim'
" IDE
Plug 'majutsushi/tagbar', { 'on': ['Tagbar', 'TagbarToggle', 'TagbarOpen'] } " https://github.com/universal-ctags/ctags-win32/releases
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'ray-x/lsp_signature.nvim'
Plug 'glepnir/lspsaga.nvim'
" GUI
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & npm install', 'on': 'MarkdownPreview' }
Plug 'kyazdani42/nvim-web-devicons' " required by barbar.nvim and nvim-tree.lue
Plug 'kyazdani42/nvim-tree.lua'
Plug 'romgrk/barbar.nvim'

" Plug 'Shougo/echodoc.vim' " used by coc
" Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go', 'tag': 'v1.22' }
" Evaluating
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" Plug 'ggandor/lightspeed.nvim'
" Plug 'nvim-lua/popup.nvim' " for telescope
" Plug 'nvim-lua/plenary.nvim' " for telescope
" Plug 'nvim-telescope/telescope.nvim'
call plug#end()


" firenvim
let g:firenvim_config = {
	\ 'localSettings': {
		\ '.*': {
			\ 'takeover': 'never',
		\ }
	\ }
\ }


" -----------------------------------------------------------------------------



" undotree
cabbrev UT UndotreeToggle



" vim-closetag
let g:closetag_filetypes = 'html,php,typescript,typescriptreact,javascriptreact,vue'



" quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars = 160



" tcomment
nmap <leader>c <c-_><c-_>
vmap <leader>c <c-_><c-_>
let g:tcomment#filetype#guess_typescriptreact = 1



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



" nvim-colorizer
lua require'colorizer'.setup({
	\  'css';
	\  'html';
	\  'javascript';
	\  'typescript';
	\  'javascriptreact';
	\  'typescriptreact';
	\  'vue';
	\  'vim';
\ }, { no_names = true })



" hop
lua require'hop'.setup()
nnoremap <leader>w :HopWord<cr>



" ctrlp
" get ripgref https://github.com/BurntSushi/ripgrep/releases
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
let g:ctrlp_search_options = '-g "!*.jpg" -g "!*.png" -g "!*.gif" -g "!*.svg" -g "!*.psd" -g "!*.ai" -g "!.git" -g "!node_modules" -g "!__pycache__" -g "!.venv" -g "!venv"' " search options for ripgrep to reuse in other vimrc
let g:ctrlp_user_command = {
	\ 'types': {
		\ 1: ['.git', 'cd %s && git ls-files -- . ":!:*.jpg" . ":!:*.png" . ":!:*.svg" . ":!:*.psd" . ":!:*.ai" . ":!:*/node_modules/*"'],
	\ },
	\ 'fallback': 'rg %s --files --color=never --hidden ' . g:ctrlp_search_options
\ }
nnoremap gb :CtrlPBuffer<cr>
nnoremap gh :CtrlPMRU<cr>
" nnoremap gt :CtrlPTag<cr>
let g:ctrlp_buftag_ctags_bin = 'ctags.exe'
" let g:ctrlp_user_command = 'rg %s --files --color=never'



" Emmet
let g:user_emmet_leader_key = '<c-y>'
let g:user_emmet_expandabbr_key = '<c-e>'
let g:user_emmet_settings = {
\    'typescriptreact' : {
\        'extends' : 'jsx',
\    },
\    'javascript' : {
\        'extends' : 'jsx',
\    },
\ }
imap <F6> <c-e>
" let g:user_emmet_expandword_key = '<c-e>'
" let g:user_emmet_complete_tag = 1



" barbar.nvim
let bufferline = get(g:, 'bufferline', {})
let bufferline.animation = v:false
let bufferline.maximum_padding = 2
let bufferline.icon_separator_active = '▌'
let bufferline.icon_separator_inactive = '▌'
nnoremap <silent> <tab> :BufferNext<cr>
nnoremap <silent> <s-tab> :BufferPrevious<cr>
nnoremap <silent> <f4> :BufferClose<cr>
nnoremap <silent> <c-f4> :BufferCloseAllButCurrent<cr>
nnoremap <silent> <leader><tab> :BufferPick<cr>
nnoremap <silent> <c-s-tab> :BufferMovePrevious<cr>
nnoremap <silent> <c-tab> :BufferMoveNext<cr>



" nvim-tree.lue
cabbrev NO NvimTreeOpen
let g:nvim_tree_ignore = ['.git', 'node_modules']
let g:nvim_tree_indent_markers = 1



" LSP
lua << EOF
local nvim_lsp = require('lspconfig')

function organize_imports()
	local params = vim.lsp.util.make_range_params()
	params.context = {diagnostics = {}, only = {'source.organizeImports'}}
	local responses = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
	if not responses or vim.tbl_isempty(responses) then
		return
	end
	for _, response in pairs(responses) do
		for _, result in pairs(response.result or {}) do
			if result.edit then
				vim.lsp.util.apply_workspace_edit(result.edit)
			else
				vim.lsp.buf.execute_command(result.command)
			end
		end
	end
	vim.cmd [[normal zz]]
end

-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	--Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
	-- reference highlighting
	require 'illuminate'.on_attach(client)

	-- Mappings.
	local opts = { noremap=true, silent=true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
	-- buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
	-- buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
	-- buf_set_keymap('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
	-- buf_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
	-- buf_set_keymap('n', '<leader>d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', opts)
	buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', opts)
	-- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', opts)
	-- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', opts)
	buf_set_keymap('n', 'g=', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
	buf_set_keymap('n', '<leader>oi', '<cmd>lua organize_imports()<cr>', opts)
	-- buf_set_keymap('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
	-- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
	-- buf_set_keymap('n', 'gm', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
	-- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
	-- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
	-- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', opts)
	-- buf_set_keymap('n', 'g=', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)

	-- lspsaga
	buf_set_keymap('n', '<leader>ac', ':Lspsaga code_action<cr>', opts)
	buf_set_keymap('n', 'K', ':Lspsaga hover_doc<cr>', opts)
	buf_set_keymap('n', '<leader>K', ':Lspsaga signature_help<cr>', opts)
	buf_set_keymap('n', '<leader>rn', ':Lspsaga rename<cr>', opts)
	buf_set_keymap('n', '<leader>ld', ':Lspsaga show_line_diagnostics<cr>', opts)
	buf_set_keymap('n', ']d', ':Lspsaga diagnostic_jump_next<cr>', opts)
	buf_set_keymap('n', '[d', ':Lspsaga diagnostic_jump_prev<cr>', opts)
	buf_set_keymap('n', '<leader>rf', ':Lspsaga lsp_finder<cr>', opts)

	-- auto format
	if client.resolved_capabilities.document_formatting then
		vim.cmd [[augroup AutoFormat]]
		vim.cmd [[autocmd! * <buffer>]]
		vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync({}, 2000)]]
		vim.cmd [[augroup END]]
	end
end

-- this is where we install all the language servers
local lsp_bins = vim.api.nvim_eval("$ROOT . '\\lsp'")

-- npm i  typescript-language-server
nvim_lsp.tsserver.setup{
	on_attach = function(client, bufnr)
		client.resolved_capabilities.document_formatting = false	
		on_attach(client, bufnr)
	end,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\typescript-language-server.cmd', '--stdio' }
}

-- npm i vscode-langservers-extracted
nvim_lsp.cssls.setup{
	on_attach = on_attach,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\vscode-css-language-server.cmd', '--stdio' },
	settings = {
		css = {
			validate = false,
		}
	}
}
nvim_lsp.html.setup{
	on_attach = on_attach,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\vscode-html-language-server.cmd', '--stdio' },
}
nvim_lsp.jsonls.setup{
	on_attach = function(client, bufnr)
		client.resolved_capabilities.document_formatting = false	
		on_attach(client, bufnr)
	end,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\vscode-json-language-server.cmd', '--stdio' },
}

-- go get github.com/mattn/efm-langserver
-- npm install eslint_d prettier
-- pip install black
local eslint = {
	lintCommand = lsp_bins .. '\\node_modules\\.bin\\eslint_d -f unix --stdin --stdin-filename ${INPUT}',
	lintStdin = true,
	lintFormats = {'%f:%l:%c: %m'},
	lintIgnoreExitCode = true,
	formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
	formatStdin = true
}
local prettier_path = '.\\node_modules\\.bin\\prettier.cmd' -- default to local
local prettier_config = ' --config-precedence file-override --no-semi --use-tabs --single-quote'
-- use our own if project doesn't have
if vim.fn.executable(prettier_path) ~= 1 then
	prettier_path = lsp_bins .. '\\node_modules\\.bin\\prettier.cmd'
end
prettier_cmd = prettier_path .. prettier_config
nvim_lsp.efm.setup {
	on_attach = on_attach,
	init_options = {
		documentFormatting = true,
		hover = true,
		documentSymbol = true,
		codeAction = true,
	},
	filetypes = {'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'css', 'html', 'json', 'python', 'yaml'},
	settings = {
		rootMarkers = {'.git/', 'node_modules/'},
		languages = {
			typescript = {
				{formatCommand = prettier_cmd .. ' --parser typescript', formatStdin = true},
				eslint,
			},
			typescriptreact = {
				{formatCommand = prettier_cmd .. ' --parser typescript', formatStdin = true},
				eslint,
			},
			javascript = {
				{formatCommand = prettier_cmd .. ' --parser babel', formatStdin = true},
				eslint,
			},
			javascriptreact = {
				{formatCommand = prettier_cmd .. ' --parser babel', formatStdin = true},
				eslint,
			},
			css = {
				{formatCommand = prettier_cmd .. ' --parser css', formatStdin = true},
			},
			html = {
				{formatCommand = prettier_cmd .. ' --parser html', formatStdin = true},
			},
			json = {
				{formatCommand = prettier_cmd .. ' --parser json', formatStdin = true},
			},
			python = {
				{formatCommand = lsp_bins .. '\\.venv\\Scripts\\black.exe --quiet -', formatStdin = true},
			},
			yaml = {
				{formatCommand = prettier_cmd .. ' --parser yaml', formatStdin = true},
			},
		}
	}
}

-- npm i pyright
nvim_lsp.pyright.setup{
	on_attach = on_attach,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\pyright-langserver.cmd', '--stdio' }
}

-- npm i yaml-language-server
nvim_lsp.yamlls.setup{
	on_attach = on_attach,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\yaml-language-server.cmd', '--stdio' },
}
EOF



" nvim-compe
set completeopt=menuone,noselect
lua << EOF
-- Compe setup
require'compe'.setup {
	enabled = true;
	autocomplete = true;
	debug = false;
	min_length = 1;
	preselect = 'enable';
	throttle_time = 80;
	source_timeout = 200;
	incomplete_delay = 400;
	max_abbr_width = 100;
	max_kind_width = 100;
	max_menu_width = 100;
	documentation = {
		border = 'single'
	};

	source = {
		path = true;
		nvim_lsp = true;
		buffer = true;
	};
}

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col('.') - 1
	if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
		return true
	else
		return false
	end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t '<C-n>'
	elseif check_back_space() then
		return t '<Tab>'
	else
		return vim.fn['compe#complete']()
	end
end
_G.s_tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t '<C-p>'
	else
		return t '<S-Tab>'
	end
end

vim.api.nvim_set_keymap('i', '<tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('i', '<s-tab>', 'v:lua.s_tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<s-tab>', 'v:lua.s_tab_complete()', {expr = true})
vim.api.nvim_set_keymap('i', '<c-space>', '<cmd>call compe#confirm()<cr>', {noremap = true})
EOF



" lsp_signature
lua require'lsp_signature'.on_attach()



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





" telescope
" nnoremap <space> :Telescope git_files<cr>
" nnoremap gh :Telescope oldfiles<cr>
" nnoremap gt :Telescope lsp_document_symbols<cr>
" nnoremap \rf :Telescope lsp_references<cr>
" lua << EOF
" require'telescope'.setup{
" 	defaults = {
" 		file_ignore_patterns = {'%.jpg$', '%.png$', '%.gif$', '%.svg$', '%.psd$', '%.ai$'},
" 	},
" 	pickers = {
" 		find_files = {
" 			theme = 'dropdown'
" 		},
" 		git_files = {
" 			theme = 'dropdown'
" 		},
" 		oldfiles = {
" 			theme = 'dropdown'
" 		},
" 		lsp_document_symbols = {
" 			theme = 'dropdown'
" 		},
" 		lsp_references = {
" 			theme = 'dropdown'
" 		},
" 	}
" }
" EOF
