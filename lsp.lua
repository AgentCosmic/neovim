vim.lsp.enable({
	'efm',
	'yamlls',
	'ts_ls',
	'jsonls',
	'html',
	'cssls',
	'eslint',
	'stylelint_lsp',
	'bashls',
	'lua_ls',
	'basedpyright',
	'gopls',
})

vim.lsp.config('*', {
	root_markers = { '.git' },
	single_file_support = true,
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		-- set keybindings
		local buf = args.buf
		local opts = { noremap = true, silent = true }
		vim.api.nvim_buf_set_keymap(buf, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
		vim.api.nvim_buf_set_keymap(buf, 'n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
		vim.api.nvim_buf_set_keymap(buf, 'n', '<leader>ld', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
		vim.api.nvim_buf_set_keymap(buf, 'n', '<leader>D', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
		vim.api.nvim_buf_set_keymap(buf, 'n', 'g=', '<cmd>lua vim.lsp.buf.format({ async = true })<cr>', opts)
		vim.api.nvim_buf_set_keymap(buf, 'n', '<leader>ih',
			'<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>', opts)

		-- set custom commands
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client.name == 'ts_ls' then
			vim.api.nvim_buf_create_user_command(args.buf, 'OrganizeImports', function()
				client:exec_cmd({
						title = 'organize_imports',
						command = '_typescript.organizeImports',
						arguments = {
							vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
						}
					},
					{ bufnr = vim.api.nvim_get_current_buf() })
			end, {})
		end
	end,
})

-- diagnostics messages
vim.diagnostic.config({ virtual_text = { current_line = true } })
-- diagnostic signs
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
	local hl = 'DiagnosticSign' .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

-- this is where we install all the language servers
local lsp_bins = vim.fn.stdpath('data') .. '/lsp'

-- go get github.com/mattn/efm-langserver
-- npm install prettier
-- pip install ruff
-- npm i bash-language-server prettier-plugin-solidity
local prettier_path = './node_modules/.bin/prettier' -- default to local
local prettier_config = ' --config-precedence file-override --use-tabs --single-quote --print-width 120'
-- use our own if project doesn't have
if vim.fn.executable(prettier_path) ~= 1 then
	prettier_path = lsp_bins .. '/node_modules/.bin/prettier'
end
local prettier_cmd = prettier_path .. prettier_config
vim.lsp.config('efm', {
	cmd = { lsp_bins .. '/efm-langserver' },
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
		hover = true,
		documentSymbol = true,
		codeAction = true,
	},
	filetypes = {
		'json', 'yaml', 'markdown',
		'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
		'sh', 'python',
		'vue', 'solidity'
	},
	settings = {
		rootMarkers = { '.git/', 'node_modules/' },
		languages = {
			json = {
				{ formatCommand = prettier_cmd .. ' --parser json', formatStdin = true },
			},
			yaml = {
				{ formatCommand = prettier_cmd .. ' --parser yaml', formatStdin = true },
			},
			markdown = {
				{ formatCommand = prettier_cmd .. ' --parser markdown', formatStdin = true },
			},
			html = {
				{ formatCommand = prettier_cmd .. ' --parser html', formatStdin = true },
			},
			css = {
				{ formatCommand = prettier_cmd .. ' --parser css', formatStdin = true },
			},
			javascript = {
				{ formatCommand = prettier_cmd .. ' --parser babel', formatStdin = true },
			},
			typescript = {
				{ formatCommand = prettier_cmd .. ' --parser typescript', formatStdin = true },
			},
			javascriptreact = {
				{ formatCommand = prettier_cmd .. ' --parser babel', formatStdin = true },
			},
			typescriptreact = {
				{ formatCommand = prettier_cmd .. ' --parser typescript', formatStdin = true },
			},
			sh = {
				{ lintCommand = lsp_bins .. '/shellcheck -f gcc -x' },
			},
			python = {
				{ formatCommand = lsp_bins .. '/venv/bin/ruff format --quiet -', formatStdin = true },
				{ formatCommand = lsp_bins .. '/venv/bin/ruff check --fix --quiet -', formatStdin = true },
			},
			vue = {
				{ formatCommand = prettier_cmd .. ' --parser vue', formatStdin = true },
			},
			solidity = {
				{ formatCommand = prettier_cmd .. ' --parser solidity-parse', formatStdin = true },
			},
		}
	}
})

-- npm i yaml-language-server
vim.lsp.config('yamlls', {
	cmd = { lsp_bins .. '/node_modules/.bin/yaml-language-server', '--stdio' },
})

-- npm i typescript-language-server
vim.lsp.config('ts_ls', {
	cmd = { lsp_bins .. '/node_modules/.bin/typescript-language-server', '--stdio' },
	init_options = {
		-- hostInfo = 'neovim',
		preferences = {
			includeInlayParameterNameHints = 'all',
			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
	},
})

-- json, css, html, eslint
-- npm i vscode-langservers-extracted
vim.lsp.config('jsonls', {
	cmd = { lsp_bins .. '/node_modules/.bin/vscode-json-language-server', '--stdio' },
})
vim.lsp.config('html', {
	cmd = { lsp_bins .. '/node_modules/.bin/vscode-html-language-server', '--stdio' },
})
vim.lsp.config('cssls', {
	cmd = { lsp_bins .. '/node_modules/.bin/vscode-css-language-server', '--stdio' },
})
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/eslint.lua
vim.lsp.config('eslint', {
	cmd = { lsp_bins .. '/node_modules/.bin/vscode-eslint-language-server', '--stdio' },
})


-- npm i stylelint-lsp
vim.lsp.config('stylelint_lsp', {
	cmd = { lsp_bins .. '/node_modules/.bin/stylelint-lsp', '--stdio' },
})

-- npm i bash-language-server
vim.lsp.config('bashls', {
	cmd = { lsp_bins .. '/node_modules/.bin/bash-language-server', 'start' },
})

-- lua https://github.com/LuaLS/lua-language-server/releases
vim.lsp.config('lua_ls', {
	cmd = { lsp_bins .. '/lua_ls/bin/lua-language-server' },
	settings = {
		Lua = {
			workspace = {
				preloadFileSize = 1500,
			},
		},
	},
	-- add neovim https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/lua_ls.lua
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
				return
			end
		end
		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				version = 'LuaJIT'
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
				}
			}
		})
	end,
})

-- pip install basedpyright
vim.lsp.config('basedpyright', {
	cmd = { lsp_bins .. '/venv/bin/basedpyright-langserver', '--stdio' },
})

-- go install -v golang.org/x/tools/gopls
vim.lsp.config('gopls', {
	cmd = { 'gopls' },
})

------------------------------------------------------------------------------
-- Unused, outdated, or not working
------------------------------------------------------------------------------

-- npm i @vue/language-server typescript-language-server
-- vim.lsp.config('volar', {
-- 	cmd = { lsp_bins .. '/node_modules/.bin/vue-language-server', '--stdio' },
-- 	filetypes = { 'vue' },
-- 	init_options = {
-- 		typescript = {
-- 			tsdk = lsp_bins .. '/node_modules/typescript/lib',
-- 		},
-- 	},
-- })

-- https://github.com/NomicFoundation/hardhat-vscode/blob/development/server/README.md
-- npm i @nomicfoundation/solidity-language-server
-- vim.lsp.enable('solidity')
-- vim.lsp.config('solidity', {
-- 	cmd = { lsp_bins .. '/node_modules/.bin/nomicfoundation-solidity-language-server', '--stdio' },
-- })

-- https://github.com/razzmatazz/csharp-language-server
-- vim.lsp.enable('csharp_ls')

-- rustup component add rust-analyzer
-- vim.lsp.enable('rust_analyzer')
-- vim.lsp.config('rust_analyzer', {
-- 	settings = {
-- 		['rust-analyzer'] = {
-- 			diagnostics = {
-- 				enable = false,
-- 			}
-- 		}
-- 	}
-- })

-- https://github.com/eclipse/eclipse.jdt.ls
-- https://download.eclipse.org/jdtls/milestones/0.57.0/
-- using v0.57 because newer versions require java 17
-- vim.lsp.enable('jdtls')
-- vim.lsp.config('jdtls', {
-- 	cmd = { 'java', '-jar', lsp_bins ..
-- 	'/jdtls/plugins/org.eclipse.equinox.launcher_1.5.700.v20200207-2156.jar',
-- 		'-Declipse.application=org.eclipse.jdt.ls.core.id1', '-Dosgi.bundles.defaultStartLevel=4',
-- 		'-Declipse.product=org.eclipse.jdt.ls.core.product', '-Dlog.protocol=true', '-Dlog.level=ALL',
-- 		'-Xms1g',
-- 		'-Xmx2G', '--add-modules=ALL-SYSTEM', '--add-opens', 'java.base/java.util=ALL-UNNAMED', '--add-opens',
-- 		'java.base/java.lang=ALL-UNNAMED', '-configuration', lsp_bins .. '/jdtls/config_win', '-data',
-- 		lsp_bins .. '/jdtls/workspace' }
-- })
