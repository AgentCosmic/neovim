vim.lsp.enable({
	'oxfmt',
	'oxlint',
	'ts_ls',
	'jsonls',
	'html',
	'cssls',
	'stylelint_lsp',
	'efm',
	'bashls',
	'lua_ls',
	'yamlls',
	'basedpyright',
	'ruff',
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

		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		-- ts_ls: disable formatting, add OrganizeImports command
		if client.name == 'ts_ls' then
			client.server_capabilities.documentFormattingProvider = false
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

		-- ddisable Ruff hover in favor of Pyright
		if client.name == 'ruff' then
			client.server_capabilities.hoverProvider = false
		end

		-- integrate with built-in completion
		vim.lsp.completion.enable(true, client.id, buf, {
			autotrigger = true,
			convert = function(item)
				return { abbr = item.label:gsub('%b()', '') }
			end,
		})
		vim.lsp.inline_completion.enable(true)
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


-- Add a rounded border to all LSP floating windows (hover, signature help)
-- https://github.com/neovim/neovim/issues/38248
local orig_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "rounded"
	return orig_open_floating_preview(contents, syntax, opts, ...)
end
local function set_popup_border(winid)
	if winid and winid >= 0 and vim.api.nvim_win_is_valid(winid) then
		pcall(vim.api.nvim_win_set_config, winid, { border = "rounded" })
	end
end
-- Case 1: item already has `info` — popup is created by C code before CompleteChanged
-- Lua callbacks fire; grab preview_winid after yielding to the event loop.
vim.api.nvim_create_autocmd("CompleteChanged", {
	group = vim.api.nvim_create_augroup("CompletionPopupBorder", { clear = true }),
	callback = function()
		vim.schedule(function()
			local info = vim.fn.complete_info({ "selected" })
			set_popup_border(info.preview_winid)
		end)
	end,
})
-- Case 2: async LSP completionItem/resolve — popup is created via nvim__complete_set
-- after a network round-trip, long after CompleteChanged has already fired.
if vim.api.nvim__complete_set then
	local orig = vim.api.nvim__complete_set
	---@diagnostic disable-next-line: duplicate-set-field
	vim.api.nvim__complete_set = function(index, opts)
		local windata = orig(index, opts)
		set_popup_border(windata and windata.winid)
		return windata
	end
end


---------- Languages ----------

-- this is where we install all the language servers
local lsp_bins = vim.fn.stdpath('data') .. '/lsp'


-- npm i oxfmt
vim.lsp.config('oxfmt', {
	cmd = function(dispatchers, config)
		local cmd = 'oxfmt'
		local full_path
		if (config or {}).root_dir then
			local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
			if vim.fn.executable(local_cmd) == 1 then
				full_path = local_cmd
			end
		end
		if not full_path then
			full_path = vim.fs.joinpath(lsp_bins, 'node_modules/.bin', cmd)
		end
		return vim.lsp.rpc.start({ full_path, '--lsp' }, dispatchers)
	end,
})

-- npm i oxlint
vim.lsp.config('oxlint', {
	cmd = function(dispatchers, config)
		local cmd = 'oxlint'
		local full_path
		if (config or {}).root_dir then
			local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
			if vim.fn.executable(local_cmd) == 1 then
				full_path = local_cmd
			end
		end
		if not full_path then
			full_path = vim.fs.joinpath(lsp_bins, 'node_modules/.bin', cmd)
		end
		print(full_path)
		return vim.lsp.rpc.start({ full_path, '--lsp' }, dispatchers)
	end,
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

-- json, css, html
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

-- npm i stylelint-lsp
vim.lsp.config('stylelint_lsp', {
	cmd = { lsp_bins .. '/node_modules/.bin/stylelint-lsp', '--stdio' },
})


-- go get github.com/mattn/efm-langserver
-- https://github.com/koalaman/shellcheck
vim.lsp.config('efm', {
	cmd = { lsp_bins .. '/efm-langserver' },
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
		hover = true,
		documentSymbol = true,
		codeAction = true,
	},
	filetypes = { 'sh' },
	settings = {
		rootMarkers = { '.git/' },
		languages = {
			sh = {
				{ lintCommand = lsp_bins .. '/shellcheck -f gcc -x' },
			},
		}
	}
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


-- npm i yaml-language-server
vim.lsp.config('yamlls', {
	cmd = { lsp_bins .. '/node_modules/.bin/yaml-language-server', '--stdio' },
})


-- pip install basedpyright
vim.lsp.config('basedpyright', {
	cmd = { lsp_bins .. '/.venv/bin/basedpyright-langserver', '--stdio' },
	settings = {
		pyright = {
			-- using Ruff's import organizer
			disableOrganizeImports = true,
		},
	},
})

-- pip install ruff
vim.lsp.config('ruff', {
	cmd = { lsp_bins .. '/.venv/bin/ruff', 'server' },
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
