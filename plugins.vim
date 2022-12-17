" https://github.com/BurntSushi/ripgrep/releases
call plug#begin('$HOME/plugged')
" Universal Vim Functionality
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle'  }
Plug 'tpope/vim-abolish'
Plug 'dyng/ctrlsf.vim', { 'on': 'CtrlSF'  }
Plug 'unblevable/quick-scope'
Plug 'wellle/targets.vim'
Plug 'rrethy/vim-illuminate'
Plug 'phaazon/hop.nvim'
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
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'javascriptreact', 'typescriptreact', 'htmldjango'] }
Plug 'nvim-lua/popup.nvim' " telescope
Plug 'nvim-lua/plenary.nvim' " telescope
Plug 'nvim-telescope/telescope.nvim'
" IDE
Plug 'majutsushi/tagbar', { 'on': ['Tagbar', 'TagbarToggle', 'TagbarOpen'] } " https://github.com/universal-ctags/ctags-win32/releases
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip' " snippets
Plug 'saadparwaiz1/cmp_luasnip' " snippets
" Plug 'rafamadriz/friendly-snippets' " snippets copied into project for customization
Plug 'ray-x/lsp_signature.nvim'
Plug 'RishabhRD/popfix' " lsputils
Plug 'RishabhRD/nvim-lsputils'
" GUI
Plug 'lukas-reineke/indent-blankline.nvim' " indent guides for spaces
Plug 'kyazdani42/nvim-web-devicons' " required by nvim-tree.lue
Plug 'kyazdani42/nvim-tree.lua', { 'on': ['NvimTreeFindFile', 'NvimTreeFocus'] }
Plug 'noib3/nvim-cokeline'
Plug 'numtostr/BufOnly.nvim', { 'on': 'BufOnly' }

" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go', 'tag': 'v1.22' }
" Evaluating
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" Plug 'kkoomen/vim-doge'
Plug 'perost/modelica-vim'
Plug 'voldikss/vim-floaterm'
call plug#end()


" firenvim
let g:firenvim_config = {
	\ 'localSettings': {
		\ '.*': {
			\ 'takeover': 'never',
		\ }
	\ }
\ }

" modelica-vim
au BufRead,BufNewFile *.mo set filetype=modelica

" floaterm
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9



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



" Telescope
nnoremap \ :lua telescope_project_files()<cr>
nnoremap gh :Telescope oldfiles<cr>
nnoremap gt :Telescope lsp_document_symbols<cr>
nnoremap <leader>rf :Telescope lsp_references<cr>
lua << EOF
-- use git_files, fallback to to find_files
function telescope_project_files ()
	local opts = {} -- add additional options here
	local ok = pcall(require'telescope.builtin'.git_files, opts)
	if not ok then require'telescope.builtin'.find_files(opts) end
end
require'telescope'.setup{
	defaults = {
		file_ignore_patterns = {'%.jpg$', '%.png$', '%.gif$', '%.svg$', '%.psd$', '%.ai$'},
		preview = {
			filesize_limit = 1,
			timeout = 250,
		},
	},
	sorters = 'get_fzy_sorter',
	pickers = {
		find_files = {
			hidden = true
		},
	}
}
EOF



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
\    'htmldjango' : {
\        'extends' : 'html',
\    },
\ }
imap <F6> <c-e>
" let g:user_emmet_expandword_key = '<c-e>'
" let g:user_emmet_complete_tag = 1


" cokeline
lua << EOF
local is_picking_focus = require('cokeline/mappings').is_picking_focus
local is_picking_close = require('cokeline/mappings').is_picking_close
local get_hex = require('cokeline/utils').get_hex
require('cokeline').setup({
	default_hl = {
		fg = function(buffer)
			return buffer.is_focused and get_hex('Todo', 'fg') or get_hex('Comment', 'fg')
		end,
		bg = function(buffer)
			return buffer.is_focused and get_hex('Normal', 'bg') or get_hex('ColorColumn', 'bg')
		end
	},
	components = {
		{
			text = ' ',
			bg = function(buffer)
				-- return buffer.is_focused and get_hex('PmenuSel', 'bg') or get_hex('ColorColumn', 'bg')
				return buffer.is_focused and get_hex('Normal', 'fg') or get_hex('ColorColumn', 'bg')
			end,
		},
		{
			text = function(buffer)
				return (is_picking_focus() or is_picking_close()) and ' ' .. buffer.pick_letter .. ' ' or ' ' .. buffer.devicon.icon
			end,
			fg = function(buffer)
				return (is_picking_focus() and get_hex('DiffAdd', 'fg')) or (is_picking_close() and get_hex('Error', 'fg')) or buffer.devicon.color
			end,
		},
		{
			text = function(buffer) return buffer.unique_prefix end,
			style = 'italic',
		},
		{
			text = function(buffer) return buffer.filename .. ' ' end,
			fg = function(buffer)
				if buffer.is_modified then
					return get_hex('ModeMsg', 'fg')
				end
				if buffer.is_focused then
					return get_hex('Todo', 'fg')
				end
				return get_hex('Comment', 'fg')
			end,
		},
		{
			text = '',
			delete_buffer_on_left_click = true,
		},
		{
			text = ' ',
		}
	},
})

local map = vim.api.nvim_set_keymap
map('n', '<tab>', '<Plug>(cokeline-focus-next)', { silent = true })
map('n', '<s-tab>', '<Plug>(cokeline-focus-prev)', { silent = true })
map('n', '<c-tab>', '<Plug>(cokeline-switch-next)', { silent = true })
map('n', '<c-s-tab>', '<Plug>(cokeline-switch-prev)', { silent = true })
map('n', '<c-f4>', ':BufOnly<cr>', { silent = true, noremap = true })
map('n', '<leader><tab>', '<Plug>(cokeline-pick-focus)', { silent = true })
EOF



" nvim-tree.lue
cabbrev NTF NvimTreeFindFile
nmap <leader>nt :NvimTreeFocus<cr>
lua << EOF
require'nvim-tree'.setup {
	filters = {
		custom = {'.git', 'node_modules'},
	},
	view = {
		adaptive_size = true,
	},
	renderer = {
		add_trailing = true,
		indent_markers = {
			enable = true,
		},
	},
	sync_root_with_cwd = true,
	auto_reload_on_write = true,
}
EOF



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
	-- show signature
	require "lsp_signature".on_attach({}, bufnr)

	-- Mappings.
	local opts = { noremap=true, silent=true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
	buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
	buf_set_keymap('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
	-- buf_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
	buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false, border = "rounded"})<cr>', opts)
	buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({popup_opts = {border = "rounded"}})<cr>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next({popup_opts = {border = "rounded"}})<cr>', opts)
	buf_set_keymap('n', 'g=', '<cmd>lua vim.lsp.buf.format({ async = true })<cr>', opts)
	buf_set_keymap('n', '<leader>oi', '<cmd>lua organize_imports()<cr>', opts)
	buf_set_keymap('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
	-- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
	-- buf_set_keymap('n', 'gm', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
	-- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
	-- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
	-- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', opts)

	-- floating windows
	vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'})
	vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'rounded'})
	-- diagnostics options
	vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = { prefix = '❱' },
	})

	-- lsputils
	vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
    vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
    vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
    vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
    vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
    vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
    vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
    vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

	-- auto format
	-- if client.server_capabilities.document_formatting then
	-- 	vim.cmd [[augroup AutoFormat]]
	-- 	vim.cmd [[autocmd! * <buffer>]]
	-- 	vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
	-- 	vim.cmd [[augroup END]]
	-- end
end

-- this is where we install all the language servers
local lsp_bins = vim.api.nvim_eval("$ROOT . '\\lsp'")

-- nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- npm i typescript-language-server
nvim_lsp.tsserver.setup{
	on_attach = function(client, bufnr)
		client.server_capabilities.document_formatting = false	
		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\typescript-language-server.cmd', '--stdio' }
}

-- npm i vscode-langservers-extracted
nvim_lsp.cssls.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\vscode-css-language-server.cmd', '--stdio' },
	settings = {
		css = {
			validate = false,
		}
	}
}
nvim_lsp.html.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\vscode-html-language-server.cmd', '--stdio' },
}
nvim_lsp.jsonls.setup{
	on_attach = function(client, bufnr)
		client.server_capabilities.document_formatting = false	
		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\vscode-json-language-server.cmd', '--stdio' },
}

-- go get github.com/mattn/efm-langserver
-- npm install eslint_d prettier
-- pip install black isort
local eslint = {
	lintCommand = lsp_bins .. '\\node_modules\\.bin\\eslint_d -f unix --stdin --stdin-filename ${INPUT}',
	lintStdin = true,
	lintFormats = {'%f:%l:%c: %m'},
	lintIgnoreExitCode = true,
	formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
	formatStdin = true
}
local prettier_path = '.\\node_modules\\.bin\\prettier.cmd' -- default to local
local prettier_config = ' --config-precedence file-override --use-tabs --single-quote --print-width 120'
-- use our own if project doesn't have
if vim.fn.executable(prettier_path) ~= 1 then
	prettier_path = lsp_bins .. '\\node_modules\\.bin\\prettier.cmd'
end
prettier_cmd = prettier_path .. prettier_config
nvim_lsp.efm.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = {
		documentFormatting = true,
		hover = true,
		documentSymbol = true,
		codeAction = true,
	},
	filetypes = {'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'css', 'html', 'json', 'python', 'yaml', 'markdown', 'solidity'},
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
				{formatCommand = lsp_bins .. '\\.venv\\Scripts\\isort.exe --quiet -', formatStdin = true},
			},
			yaml = {
				{formatCommand = prettier_cmd .. ' --parser yaml', formatStdin = true},
			},
			markdown = {
				{formatCommand = prettier_cmd .. ' --parser markdown', formatStdin = true},
			},
			solidity = {
				{formatCommand = prettier_path .. ' --parser solidity-parse', formatStdin = true},
			},
		}
	}
}

-- npm i pyright
nvim_lsp.pyright.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\pyright-langserver.cmd', '--stdio' }
}

-- npm i yaml-language-server
nvim_lsp.yamlls.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { lsp_bins .. '\\node_modules\\.bin\\yaml-language-server.cmd', '--stdio' },
}

-- https://docs.soliditylang.org/en/latest/installing-solidity.html
nvim_lsp.solc.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { lsp_bins .. '\\solc.exe', '--lsp' },
}

-- https://github.com/eclipse/eclipse.jdt.ls
-- using v0.57 because we're using java 8
nvim_lsp.jdtls.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { 'java.exe', '-jar', lsp_bins .. '\\jdtls\\plugins\\org.eclipse.equinox.launcher_1.5.700.v20200207-2156.jar', '-Declipse.application=org.eclipse.jdt.ls.core.id1', '-Dosgi.bundles.defaultStartLevel=4', '-Declipse.product=org.eclipse.jdt.ls.core.product', '-Dlog.protocol=true', '-Dlog.level=ALL', '-Xms1g', '-Xmx2G', '--add-modules=ALL-SYSTEM', '--add-opens', 'java.base/java.util=ALL-UNNAMED', '--add-opens', 'java.base/java.lang=ALL-UNNAMED', '-configuration', lsp_bins .. '\\jdtls\\config_win', '-data', lsp_bins .. '\\jdtls\\workspace' }
}
EOF



" nvim-cmp
set completeopt=menu,menuone,noselect
lua << EOF
local cmp = require'cmp'
local cmp_buffer = require'cmp_buffer'
cmp.setup({
	mapping = {
		['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<C-D>'] = cmp.mapping.scroll_docs(-4),
		['<C-F>'] = cmp.mapping.scroll_docs(4),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{
			name = 'buffer',
			options = {
				get_bufnrs = function()
					return vim.api.nvim_list_bufs() -- use all buffers
				end,
			},
		},
		{ name = 'path' },
		{ name = 'luasnip' },
	},
	window = {
		documentation = {
			border = 'single'
		},
	},
	snippet = {
		expand = function(args)
			-- required even if not used
			require'luasnip'.lsp_expand(args.body)
		end,
    },
	sorting = {
		comparators = {
			cmp.config.compare.exact,
			cmp.config.compare.score,
			function(...) return cmp_buffer:compare_locality(...) end,
			cmp.config.compare.recently_used,
			cmp.config.compare.offset,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		}
	}
})
EOF

" luasnip
lua require("luasnip.loaders.from_vscode").load({ paths = { vim.env.HOME .. '/snippets' } })
imap <silent><expr> <c-s-n> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
smap <silent><expr> <c-s-n> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 



" vim-illuminate
lua << EOF
require('illuminate').configure({
	under_cursor = false,
})
EOF



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
" override Telescope
augroup VimGo
	autocmd!
	autocmd FileType go nnoremap <buffer> gt :GoDecls<cr>
	autocmd FileType go nnoremap <buffer> gT :GoDeclsDir<cr>
augroup end
