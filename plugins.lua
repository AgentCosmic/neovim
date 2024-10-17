---@diagnostic disable: undefined-global
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

	------------------------------------------------------------------------------
	-- Universal Vim Functionality
	------------------------------------------------------------------------------


	{
		'wellle/targets.vim',
		event = 'BufRead',
	},

	{
		'hrsh7th/nvim-cmp',
		dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-nvim-lsp-signature-help', 'L3MON4D3/LuaSnip' },
		event = 'InsertEnter',
		config = function()
			vim.opt.completeopt = 'menu,menuone,noselect'
			local cmp = require('cmp')
			local cmp_buffer = require('cmp_buffer')
			local luasnip = require('luasnip')
			cmp.setup({
				mapping = {
					['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					['<C-Space>'] = cmp.mapping.complete(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<C-D>'] = cmp.mapping.scroll_docs(-4),
					['<C-F>'] = cmp.mapping.scroll_docs(4),
					['<C-N>'] = cmp.mapping(function(fallback)
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
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
					{ name = 'nvim_lsp_signature_help' },
					{ name = 'luasnip' },
				},
				window = {
					documentation = {
						border = 'single'
					},
				},
				sorting = {
					comparators = {
						cmp.config.compare.exact, -- so that snippets are near the top
						cmp.config.compare.score,
						function(...) return cmp_buffer:compare_locality(...) end,
						cmp.config.compare.recently_used,
						cmp.config.compare.offset,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					}
				},
				snippet = {
					expand = function(args)
						-- required even if not used
						require('luasnip').lsp_expand(args.body)
					end,
				},
			})
		end
	},

	{
		-- snippet plugin in requried for nvim-cmp to work
		'L3MON4D3/LuaSnip',
		dependencies = { 'saadparwaiz1/cmp_luasnip' },
		event = 'InsertEnter',
		config = function()
			-- luasnip needs to load snippets before nvim-cmp is loaded
			require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.env.ROOT .. '/snippets' } })
		end
	},

	{
		'rrethy/vim-illuminate',
		event = 'BufRead',
		config = function()
			require('illuminate').configure({
				under_cursor = false,
			})
		end
	},

	{
		'smoka7/hop.nvim',
		cmd = 'HopChar1',
		init = function()
			vim.api.nvim_set_keymap('n', '<leader>h', ':HopChar1<cr>', { noremap = true, silent = true })
		end,
		config = function()
			require('hop').setup({
				-- customized for custom keyboard layout, excluding Q & Z
				keys = 'etahiscnodywkrgpjmbfulxv',
			})
		end
	},

	{
		'tpope/vim-abolish',
		event = 'BufRead',
	},

	{
		'Shatur/neovim-session-manager',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local Path = require('plenary.path')
			local config = require('session_manager.config')
			require('session_manager').setup({
				sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'),
				autoload_mode = config.AutoloadMode.CurrentDir,
				autosave_last_session = true,
				autosave_only_in_session = true,
				autosave_ignore_filetypes = { 'gitcommit', 'gitrebase', 'neo-tree' },
			})
		end
	},


	------------------------------------------------------------------------------
	-- Programming Related
	------------------------------------------------------------------------------


	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = { 'vim', 'vimdoc', 'lua', 'javascript', 'typescript', 'html', 'css', 'python', 'markdown', 'tsx', 'vue', 'go' },
				auto_install = false,
				indent = {
					enable = true,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							['ib'] = '@block.inner',
							['ab'] = '@block.outer',
							['af'] = '@function.outer',
							['if'] = '@function.inner',
							['ic'] = '@conditional.inner',
							['ac'] = '@conditional.outer',
							['il'] = '@loop.inner',
							['al'] = '@loop.outer',
							['ip'] = '@parameter.inner',
							['ap'] = '@parameter.outer',
						},
					},
					move = {
						enable = true,
						goto_next_start = {
							[']f'] = '@function.outer',
							[']c'] = '@conditional.outer',
							[']l'] = '@loop.outer',
						},
						goto_next_end = {
							[']F'] = '@function.outer',
							[']C'] = '@conditional.outer',
							[']L'] = '@loop.outer',
						},
						goto_previous_start = {
							['[f'] = '@function.outer',
							['[c'] = '@conditional.outer',
							['[l'] = '@loop.outer',
						},
						goto_previous_end = {
							['[F'] = '@function.outer',
							['[C'] = '@conditional.outer',
							['[L'] = '@loop.outer',
						},
					},
				},
			})
		end
	},

	{
		'kylechui/nvim-surround',
		event = 'BufRead',
		config = function()
			require('nvim-surround').setup({})
		end
	},

	{
		'michaeljsmith/vim-indent-object',
		event = 'BufRead',
	},

	{
		'jeetsukumaran/vim-indentwise',
		event = 'BufRead',
	},

	{
		'altermo/ultimate-autopair.nvim',
		event = { 'InsertEnter' },
		branch = 'v0.6',
		opts = {}
	},

	{
		'folke/ts-comments.nvim',
		event = 'VeryLazy',
		opts = {},
	},

	{
		'AndrewRadev/sideways.vim',
		cmd = { 'SidewaysLeft', 'SidewaysRight' },
		init = function()
			vim.api.nvim_set_keymap('n', '<a-h>', ':SidewaysLeft<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<a-l>', ':SidewaysRight<cr>', { noremap = true, silent = true })
		end
	},

	{
		'alvan/vim-closetag',
		ft = { 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'htmldjango', 'svg', 'php', 'vue' },
		init = function()
			vim.g.closetag_filetypes = 'html,typescript,typescriptreact,javascriptreact,svg,php,vue'
		end
	},

	{
		'mattn/emmet-vim',
		ft = { 'html', 'css', 'javascriptreact', 'typescriptreact', 'htmldjango', 'vue' },
		init = function()
			vim.g.user_emmet_leader_key = '<c-y>'
			vim.g.user_emmet_expandabbr_key = '<c-e>'
			vim.g.user_emmet_settings = {
				typescriptreact = { extends = 'jsx' },
				javascript = { extends = 'jsx' },
				htmldjango = { extends = 'html' },
			}
		end
	},

	{
		'Exafunction/codeium.vim',
		event = 'BufEnter',
		config = function()
			vim.keymap.set('i', '<c-b>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
		end
	},


	------------------------------------------------------------------------------
	-- LSP
	------------------------------------------------------------------------------


	{
		'neovim/nvim-lspconfig',
		dependencies = { 'cmp-nvim-lsp' },
		ft = {
			'json', 'yaml', 'markdown',
			'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
			'sh', 'lua', 'python', 'htmldjango',
			'go', 'vue', 'java', 'solidity', 'rust', 'cs'
		},
		config = function()
			local nvim_lsp = require('lspconfig')

			function Organize_imports()
				vim.lsp.buf.execute_command({
					command = '_typescript.organizeImports',
					arguments = { vim.api.nvim_buf_get_name(0) },
				})
			end

			-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
			local on_attach = function(client, bufnr)
				local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
				local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

				-- Enable completion triggered by <c-x><c-o>
				buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

				-- Mappings.
				local opts = { noremap = true, silent = true }

				-- See `:help vim.lsp.*` for documentation on any of the below functions
				buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				buf_set_keymap('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
				buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
				buf_set_keymap('n', '<leader>D', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
				buf_set_keymap('n', 'g=', '<cmd>lua vim.lsp.buf.format({ async = true })<cr>', opts)
				buf_set_keymap('n', '<leader>oi', '<cmd>lua Organize_imports()<cr>', opts)
				buf_set_keymap('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				buf_set_keymap('n', '<leader>ih',
					'<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>', opts)
				-- buf_set_keymap('n', 'gm', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
				-- use telescope instead
				-- buf_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
			end

			-- floating windows
			vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
				vim.lsp.handlers.hover, {
					border = 'rounded'
				})
			vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
				vim.lsp.handlers.signature_help, {
					border = 'rounded'
				})
			-- diagnostics messages
			vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
				vim.lsp.diagnostic.on_publish_diagnostics, {
					virtual_text = { prefix = '' },
				})
			-- diagnostic signs
			local signs = { Error = '', Warn = '', Hint = '', Info = '' }
			for type, icon in pairs(signs) do
				local hl = 'DiagnosticSign' .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl })
			end

			-- this is where we install all the language servers
			local lsp_bins = vim.fn.stdpath('data') .. '/lsp'

			-- nvim-cmp
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion = require('cmp_nvim_lsp').default_capabilities().textDocument
				.completion

			-- go get github.com/mattn/efm-langserver
			-- npm install prettier
			-- pip install ruff isort
			-- npm i bash-language-server prettier-plugin-solidity
			local prettier_path = './node_modules/.bin/prettier' -- default to local
			local prettier_config = ' --config-precedence file-override --use-tabs --single-quote --print-width 120'
			-- use our own if project doesn't have
			if vim.fn.executable(prettier_path) ~= 1 then
				prettier_path = lsp_bins .. '/node_modules/.bin/prettier'
			end
			local prettier_cmd = prettier_path .. prettier_config
			nvim_lsp.efm.setup({
				on_attach = on_attach,
				capabilities = capabilities,
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
							{ formatCommand = lsp_bins .. '/venv/bin/isort --quiet -',       formatStdin = true },
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
			nvim_lsp.yamlls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/yaml-language-server', '--stdio' },
			})

			-- npm i typescript-language-server
			nvim_lsp.ts_ls.setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.document_formatting = false
					on_attach(client, bufnr)
				end,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/typescript-language-server', '--stdio' },
				init_options = {
					preferences = {
						includeInlayParameterNameHints = 'all',
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
						importModuleSpecifierPreference = 'non-relative'
					},
				},
			})

			-- json, css, html, eslint
			-- npm i vscode-langservers-extracted
			nvim_lsp.jsonls.setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.document_formatting = false
					on_attach(client, bufnr)
				end,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/vscode-json-language-server', '--stdio' },
			})
			nvim_lsp.html.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/vscode-html-language-server', '--stdio' },
			})
			nvim_lsp.cssls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/vscode-css-language-server', '--stdio' },
				settings = {
					css = {
						validate = false,
					}
				}
			})
			nvim_lsp.eslint.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/vscode-eslint-language-server', '--stdio' },
			})

			-- npm i stylelint-lsp
			nvim_lsp.stylelint_lsp.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/stylelint-lsp', '--stdio' },
				filetypes = { 'css', 'less', 'scss', 'vue' },
			})

			-- npm i bash-language-server
			nvim_lsp.bashls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/bash-language-server', 'start' },
			})

			-- lua https://github.com/LuaLS/lua-language-server/releases
			nvim_lsp.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/lua_ls/bin/lua-language-server' },
			})

			-- pip install basedpyright
			nvim_lsp.basedpyright.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/venv/bin/basedpyright-langserver', '--stdio' },
				settings = {
					basedpyright = {
						typeCheckingMode = 'standard',
					},
				}
			})

			-- go install -v golang.org/x/tools/gopls
			nvim_lsp.gopls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					gopls = {
						['ui.inlayhint.hints'] = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			})

			-- https://github.com/NomicFoundation/hardhat-vscode/blob/development/server/README.md
			-- npm i @nomicfoundation/solidity-language-server
			require('lspconfig.configs').solidity = {
				default_config = {
					cmd = { lsp_bins .. '/node_modules/.bin/nomicfoundation-solidity-language-server', '--stdio' },
					filetypes = { 'solidity' },
					single_file_support = true,
				},
			}
			nvim_lsp.solidity.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- npm i @vue/language-server typescript-language-server
			nvim_lsp.volar.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/vue-language-server', '--stdio' },
				init_options = {
					typescript = {
						tsdk = lsp_bins .. '/node_modules/typescript/lib',
					},
				},
			})

			-- https://github.com/razzmatazz/csharp-language-server
			nvim_lsp.csharp_ls.setup {}

			-- rustup component add rust-analyzer
			nvim_lsp.rust_analyzer.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					['rust-analyzer'] = {
						diagnostics = {
							enable = false,
						}
					}
				}
			})

			-- https://github.com/eclipse/eclipse.jdt.ls
			-- https://download.eclipse.org/jdtls/milestones/0.57.0/
			-- using v0.57 because newer versions require java 17
			nvim_lsp.jdtls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { 'java', '-jar', lsp_bins ..
				'/jdtls/plugins/org.eclipse.equinox.launcher_1.5.700.v20200207-2156.jar',
					'-Declipse.application=org.eclipse.jdt.ls.core.id1', '-Dosgi.bundles.defaultStartLevel=4',
					'-Declipse.product=org.eclipse.jdt.ls.core.product', '-Dlog.protocol=true', '-Dlog.level=ALL',
					'-Xms1g',
					'-Xmx2G', '--add-modules=ALL-SYSTEM', '--add-opens', 'java.base/java.util=ALL-UNNAMED', '--add-opens',
					'java.base/java.lang=ALL-UNNAMED', '-configuration', lsp_bins .. '/jdtls/config_win', '-data',
					lsp_bins .. '/jdtls/workspace' }
			})
		end
	},


	------------------------------------------------------------------------------
	-- UI
	------------------------------------------------------------------------------


	{
		'noib3/nvim-cokeline',
		tag = 'v0.4.0',
		event = 'BufRead',
		config = function()
			local mappings = require('cokeline/mappings')
			local is_picking_focus = mappings.is_picking_focus
			local is_picking_close = mappings.is_picking_close
			local get_hex = require('cokeline/utils').get_hex
			require('cokeline').setup({
				show_if_buffers_are_at_least = 0,
				pick = {
					-- customized for custom keyboard layout, excluding Q & Z
					letters = 'etahiscnodywkrgpjmbfulxv'
				},
				default_hl = {
					fg = function(buffer)
						return buffer.is_focused and get_hex('TabLineSel', 'fg') or get_hex('TabLine', 'fg')
					end,
					bg = function(buffer)
						return buffer.is_focused and get_hex('TabLineSel', 'bg') or get_hex('TabLine', 'bg')
					end
				},
				components = {
					-- anchor
					{
						text = ' ',
						bg = function(buffer)
							return buffer.is_focused and get_hex('Comment', 'fg') or get_hex('TabLine', 'bg')
						end,
					},
					-- icon, selector
					{
						text = function(buffer)
							return (is_picking_focus() or is_picking_close()) and ' ' .. buffer.pick_letter .. ' ' or
								' ' .. buffer.devicon.icon
						end,
						fg = function(buffer)
							return (is_picking_focus() and get_hex('DiffAdd', 'fg')) or
								(is_picking_close() and get_hex('Error', 'fg')) or buffer.devicon.color
						end,
					},
					-- path prefix
					{
						text = function(buffer) return buffer.unique_prefix end,
						style = 'italic',
					},
					-- filename
					{
						text = function(buffer) return buffer.filename .. ' ' end,
						fg = function(buffer)
							if buffer.is_modified then
								return get_hex('ModeMsg', 'fg')
							end
							if buffer.is_focused then
								return get_hex('TabLineSel', 'fg')
							end
							return get_hex('TabLine', 'fg')
						end,
					},
					-- close
					{
						text = '',
						delete_buffer_on_left_click = true,
					},
					-- padding
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
			map('n', '<leader><tab>', '<Plug>(cokeline-pick-focus)', { silent = true })
			vim.api.nvim_create_user_command('MoveTabRight', function()
				mappings.by_step('switch', 1)
			end, {})
			vim.api.nvim_create_user_command('MoveTabLeft', function()
				mappings.by_step('switch', -1)
			end, {})
		end
	},

	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' }, -- lsp must load first to enable lsp pickers
		cmd = { 'Telescope' },
		init = function()
			-- use git_files if available, else find_files
			-- vim.keymap.set('n', '<leader>f', function()
			-- 	local opts = {} -- add additional options here
			-- 	local ok = pcall(require('telescope.builtin').git_files, opts)
			-- 	if not ok then require('telescope.builtin').find_files(opts) end
			-- end, {noremap = true, silent = true})
			vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope find_files<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<leader>of', ':Telescope oldfiles<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<leader>ls', ':Telescope lsp_document_symbols<cr>',
				{ noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<leader>rf', ':Telescope lsp_references<cr>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', 'g/', ':Telescope current_buffer_fuzzy_find<cr>',
				{ noremap = true, silent = true })
		end,
		config = function()
			require('telescope').setup({
				defaults = {
					file_ignore_patterns = { '.git/', 'node_modules/', 'venv/', '%.jpeg$', '%.jpg$', '%.png$', '%.gif$' },
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
					lsp_references = {
						fname_width = 60
					}
				}
			})
		end
	},

	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v3.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
			'MunifTanjim/nui.nvim',
		},
		cmd = { 'Neotree' },
		init = function()
			vim.cmd('cabbrev NT Neotree reveal')
			vim.api.nvim_set_keymap('n', '<leader>nt', ':Neotree<cr>', { silent = true })
		end,
		config = function()
			require('neo-tree').setup({
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
					}
				},
				close_if_last_window = true,
			})
		end,
	},

	{
		'mbbill/undotree',
		cmd = 'UndotreeToggle',
		init = function()
			vim.cmd 'cabbrev UT UndotreeToggle'
		end
	},

	{
		'preservim/vimux',
		cmd = { 'VimuxPromptCommand', 'VimuxSendKeys', 'VimuxOpenRunner', 'VimuxRunCommand' },
		init = function()
			vim.g.VimuxOrientation = 'h'
			vim.g.VimuxCloseOnExit = 1
			local opts = { noremap = true, silent = true }
			vim.keymap.set('n', '<leader>tp', ':VimuxPromptCommand<cr>', opts)
			vim.keymap.set('n', '<leader>th', ':update | call VimuxSendKeys("c-c enter up enter")<cr>', opts)
			vim.keymap.set('n', '<leader>tt', ':VimuxOpenRunner<cr>', opts)
			vim.keymap.set('n', '<leader>tq', ':VimuxCloseRunner<cr>', opts)
			vim.keymap.set('n', '<leader>tg', function()
				vim.cmd('VimuxRunCommand("lazygit && exit")')
				vim.cmd('VimuxZoomRunner')
			end, opts)
			vim.keymap.set('n', '<leader>ts', function()
				vim.cmd('VimuxRunCommand(trim(getline(".")))')
			end, opts)
			vim.keymap.set('v', '<leader>ts', function()
				local vstart = vim.fn.getpos("'<")[2]
				local vend = vim.fn.getpos("'>")[2]
				local lstart = math.min(vstart, vend)
				local lend = math.max(vstart, vend)
				for i = lstart, lend, 1 do
					vim.cmd('VimuxRunCommand(trim(getline(' .. i .. ')))')
				end
			end, opts)
		end
	},

	{
		'christoomey/vim-tmux-navigator',
		setup = function()
			vim.g.tmux_navigator_no_mappings = 1
			vim.keymap.set('n', '<c-h>', ':<c-u>TmuxNavigateLeft<cr>', {})
			vim.keymap.set('n', '<c-l>', ':<c-u>TmuxNavigateRight<cr>', {})
			vim.keymap.set('n', '<c-j>', ':<c-u>TmuxNavigateDown<cr>', {})
			vim.keymap.set('n', '<c-k>', ':<c-u>TmuxNavigateUp<cr>', {})
		end
	},

	{
		'uga-rosa/ccc.nvim',
		ft = { 'css', 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vim' },
		config = function()
			local ccc = require("ccc")
			ccc.setup({
				highlighter = {
					auto_enable = true,
					lsp = true,
				},
				inputs = {
					ccc.input.okhsl,
					ccc.input.rgb,
					ccc.input.oklch,
				},
			})
		end
	},

	{
		'lewis6991/gitsigns.nvim',
		cmd = 'Gitsigns',
		config = function()
			require('gitsigns').setup()
		end
	},


	------------------------------------------------------------------------------
	-- Evaluating
	------------------------------------------------------------------------------


	{
	},

}, {
	lockfile = vim.env.ROOT .. '/lazy-lock.json',
	performance = {
		rtp = {
			-- lazy.nvim will reset the runtime path so we have to add it back
			paths = { vim.env.ROOT },
		}
	}
})
