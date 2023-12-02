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
		dependencies = {'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-nvim-lsp-signature-help', 'L3MON4D3/LuaSnip'},
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
		dependencies = {'saadparwaiz1/cmp_luasnip'},
		event = 'InsertEnter',
		config = function()
			-- luasnip needs to load snippets before nvim-cmp is loaded
			require('luasnip.loaders.from_vscode').lazy_load({paths = {vim.env.ROOT .. '/snippets'}})
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
		'phaazon/hop.nvim',
		cmd = 'HopChar1',
		init = function()
			vim.api.nvim_set_keymap('n', '<leader>w', ':HopChar1<cr>', {noremap = true, silent = true})
		end,
		config = function()
			require('hop').setup({
				-- customized for custom keyboard layout, excluding Q & Z
				keys = 'etahiscnodywkrgpjmbfulxv',
			})
		end
	},

	{
		'numtostr/BufOnly.nvim',
		cmd = {'BufOnly'},
	},

	{
		'tpope/vim-abolish',
		event = 'BufRead',
	},

	{
		'mbbill/undotree',
		cmd = 'UndotreeToggle',
		init = function()
			vim.cmd 'cabbrev UT UndotreeToggle'
		end
	},


	------------------------------------------------------------------------------
	-- Programming Related
	------------------------------------------------------------------------------


	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {'nvim-treesitter/nvim-treesitter-textobjects'},
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = {'javascript', 'typescript', 'html', 'css', 'python', 'lua', 'markdown', 'tsx', 'vue', 'go'},
				auto_install = false,
				indent = {
					enable = true
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
		event = {'InsertEnter','CmdlineEnter'},
		branch = 'v0.6',
	},

	{
		'numToStr/Comment.nvim',
		dependencies = {'nvim-treesitter/nvim-treesitter', 'JoosepAlviste/nvim-ts-context-commentstring'},
		event = 'BufRead',
		config = function()
			-- support correct comment string in files with multiple languages
			require'nvim-treesitter.configs'.setup({
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				}
			})
			require('Comment').setup({
				pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
			})
			vim.api.nvim_set_keymap('n', '<leader>c', ':normal gcc<cr>', {silent = true})
			vim.api.nvim_set_keymap('v', '<leader>c', ':normal gbc<cr>', {silent = true})
		end
	},

	{
		'AndrewRadev/sideways.vim',
		cmd = {'SidewaysLeft', 'SidewaysRight'},
		init = function()
			vim.api.nvim_set_keymap('n', '<a-h>', ':SidewaysLeft<cr>', {noremap = true, silent = true})
			vim.api.nvim_set_keymap('n', '<a-l>', ':SidewaysRight<cr>', {noremap = true, silent = true})
		end
	},

	{
		'alvan/vim-closetag',
		ft = {'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'htmldjango', 'svg', 'php', 'vue'},
		init = function()
			vim.g.closetag_filetypes = 'html,typescript,typescriptreact,javascriptreact,svg,php,vue'
		end
	},

	{
		'mattn/emmet-vim',
		ft = {'html', 'css', 'javascriptreact', 'typescriptreact', 'htmldjango', 'vue'},
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


	------------------------------------------------------------------------------
	-- LSP
	------------------------------------------------------------------------------


	{
		'neovim/nvim-lspconfig',
		dependencies = {'cmp-nvim-lsp'},
		ft = {'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'python', 'htmldjango', 'json', 'yaml', 'markdown', 'vue', 'java', 'solidity', 'go', 'rust'},
		-- event = 'BufRead',
		config = function()
			local nvim_lsp = require('lspconfig')

			function organize_imports()
				vim.lsp.buf.execute_command({
					command = '_typescript.organizeImports',
					arguments = {vim.api.nvim_buf_get_name(0)},
				})
			end

			-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
			local on_attach = function(client, bufnr)
				local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
				local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

				-- Enable completion triggered by <c-x><c-o>
				buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

				-- Mappings.
				local opts = { noremap=true, silent=true }

				-- See `:help vim.lsp.*` for documentation on any of the below functions
				buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				buf_set_keymap('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
				buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
				buf_set_keymap('n', '<leader>D', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
				buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({popup_opts = {border = "rounded"}})<cr>', opts)
				buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next({popup_opts = {border = "rounded"}})<cr>', opts)
				buf_set_keymap('n', 'g=', '<cmd>lua vim.lsp.buf.format({ async = true })<cr>', opts)
				buf_set_keymap('n', '<leader>oi', '<cmd>lua organize_imports()<cr>', opts)
				buf_set_keymap('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
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
			local signs = { Error = '', Warn = '', Hint = '', Info = '' }
			for type, icon in pairs(signs) do
				local hl = 'DiagnosticSign' .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl })
			end

			-- this is where we install all the language servers
			local lsp_bins = vim.fn.stdpath('config')

			-- nvim-cmp
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion = require('cmp_nvim_lsp').default_capabilities().textDocument.completion

			-- npm i typescript-language-server
			nvim_lsp.tsserver.setup{
				on_attach = function(client, bufnr)
					client.server_capabilities.document_formatting = false	
					on_attach(client, bufnr)
				end,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/typescript-language-server', '--stdio' }
			}

			-- css, html, json, eslint
			-- npm i vscode-langservers-extracted
			nvim_lsp.cssls.setup{
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/vscode-css-language-server', '--stdio' },
				settings = {
					css = {
						validate = false,
					}
				}
			}
			nvim_lsp.html.setup{
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/vscode-html-language-server', '--stdio' },
			}
			nvim_lsp.jsonls.setup{
				on_attach = function(client, bufnr)
					client.server_capabilities.document_formatting = false	
					on_attach(client, bufnr)
				end,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/vscode-json-language-server', '--stdio' },
			}
			nvim_lsp.eslint.setup{
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/vscode-eslint-language-server', '--stdio' },
				root_dir = nvim_lsp.util.find_git_ancestor,
			}

			-- go get github.com/mattn/efm-langserver
			-- npm install prettier
			-- pip install black isort
			-- npm i prettier-plugin-solidity
			local prettier_path = './node_modules/.bin/prettier' -- default to local
			local prettier_config = ' --config-precedence file-override --use-tabs --single-quote --print-width 120'
			-- use our own if project doesn't have
			if vim.fn.executable(prettier_path) ~= 1 then
				prettier_path = lsp_bins .. '/node_modules/.bin/prettier'
			end
			prettier_cmd = prettier_path .. prettier_config
			nvim_lsp.efm.setup{
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/efm-langserver' },
				init_options = {
					documentFormatting = true,
					hover = true,
					documentSymbol = true,
					codeAction = true,
				},
				filetypes = {'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'css', 'html', 'json', 'python', 'yaml', 'markdown', 'vue', 'solidity'},
				settings = {
					rootMarkers = {'.git/', 'node_modules/'},
					languages = {
						typescript = {
							{formatCommand = prettier_cmd .. ' --parser typescript', formatStdin = true},
						},
						typescriptreact = {
							{formatCommand = prettier_cmd .. ' --parser typescript', formatStdin = true},
						},
						javascript = {
							{formatCommand = prettier_cmd .. ' --parser babel', formatStdin = true},
						},
						javascriptreact = {
							{formatCommand = prettier_cmd .. ' --parser babel', formatStdin = true},
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
							{formatCommand = lsp_bins .. '/.venv/bin/black --quiet -', formatStdin = true},
							{formatCommand = lsp_bins .. '/.venv/bin/isort --quiet -', formatStdin = true},
						},
						yaml = {
							{formatCommand = prettier_cmd .. ' --parser yaml', formatStdin = true},
						},
						markdown = {
							{formatCommand = prettier_cmd .. ' --parser markdown', formatStdin = true},
						},
						vue = {
							{formatCommand = prettier_cmd .. ' --parser vue', formatStdin = true},
						},
						solidity = {
							{formatCommand = prettier_cmd .. ' --parser solidity-parse', formatStdin = true},
						},
					}
				}
			}

			-- npm i pyright
			nvim_lsp.pyright.setup{
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/pyright-langserver', '--stdio' }
			}

			-- npm i yaml-language-server
			nvim_lsp.yamlls.setup{
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/yaml-language-server', '--stdio' },
			}

			-- https://docs.soliditylang.org/en/latest/installing-solidity.html
			-- nvim_lsp.solc.setup{
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	cmd = { lsp_bins .. '/solc', '--lsp' },
			-- }

			-- https://github.com/NomicFoundation/hardhat-vscode/blob/development/server/README.md
			-- npm i @nomicfoundation/solidity-language-server
			require('lspconfig.configs').solidity = {
				default_config = {
					cmd = { lsp_bins .. '/node_modules/.bin/nomicfoundation-solidity-language-server', '--stdio' },
					filetypes = { 'solidity' },
					root_dir = nvim_lsp.util.find_git_ancestor,
					single_file_support = true,
				},
			}
			nvim_lsp.solidity.setup{
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- npm i @volar/vue-language-server typescript-language-server
			nvim_lsp.volar.setup{
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/vue-language-server', '--stdio' },
				init_options = {
					typescript = {
						tsdk = lsp_bins .. '/node_modules/typescript/lib',
					},
				},
			}

			-- go install -v golang.org/x/tools/gopls
			require'lspconfig'.gopls.setup{
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- rustup component add rust-analyzer
			nvim_lsp.rust_analyzer.setup{
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					['rust-analyzer'] = {
						diagnostics = {
							enable = false;
						}
					}
				}
			}

			-- https://github.com/eclipse/eclipse.jdt.ls
			-- using v0.57 because we're using java 8
			nvim_lsp.jdtls.setup{
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { 'java.exe', '-jar', lsp_bins .. '/jdtls/plugins/org.eclipse.equinox.launcher_1.5.700.v20200207-2156.jar',
					'-Declipse.application=org.eclipse.jdt.ls.core.id1', '-Dosgi.bundles.defaultStartLevel=4',
					'-Declipse.product=org.eclipse.jdt.ls.core.product', '-Dlog.protocol=true', '-Dlog.level=ALL', '-Xms1g',
					'-Xmx2G', '--add-modules=ALL-SYSTEM', '--add-opens', 'java.base/java.util=ALL-UNNAMED', '--add-opens',
					'java.base/java.lang=ALL-UNNAMED', '-configuration', lsp_bins .. '/jdtls/config_win', '-data',
				lsp_bins .. '/jdtls/workspace' }
			}
		end
	},


	------------------------------------------------------------------------------
	-- GUI
	------------------------------------------------------------------------------


	{
		'noib3/nvim-cokeline',
		event = 'BufRead',
		config = function()
			local is_picking_focus = require('cokeline/mappings').is_picking_focus
			local is_picking_close = require('cokeline/mappings').is_picking_close
			local get_hex = require('cokeline/utils').get_hex
			require('cokeline').setup({
				default_hl = {
					fg = function(buffer)
						return buffer.is_focused and get_hex('Search', 'fg') or get_hex('Comment', 'fg')
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
								return get_hex('Search', 'fg')
							end
							return get_hex('Comment', 'fg')
						end,
					},
					{
						text = '',
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
		end
	},

	{
		'nvim-telescope/telescope.nvim',
		dependencies = {'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig'}, -- lsp must load first to enable lsp pickers
		cmd = {'Telescope'},
		init = function()
			-- use git_files if available, else find_files
			vim.keymap.set('n', '<leader>f', function()
				-- vim.cmd(':PackerLoad telescope.nvim') -- we need to manually load it cos we're not calling :Telescope
				local opts = {} -- add additional options here
				local ok = pcall(require('telescope.builtin').git_files, opts)
				if not ok then require('telescope.builtin').find_files(opts) end
			end, {noremap = true, silent = true})
			vim.api.nvim_set_keymap('n', '<leader>of', ':Telescope oldfiles<cr>', {noremap = true, silent = true})
			vim.api.nvim_set_keymap('n', '<leader>ds', ':Telescope lsp_document_symbols<cr>', {noremap = true, silent = true})
			vim.api.nvim_set_keymap('n', '<leader>rf', ':Telescope lsp_references<cr>', {noremap = true, silent = true})
			vim.api.nvim_set_keymap('n', 'g/', ':Telescope current_buffer_fuzzy_find<cr>', {noremap = true, silent = true})
		end,
		config = function()
			require('telescope').setup({
				defaults = {
					file_ignore_patterns = {'%.jpg$', '%.png$', '%.gif$', '%.psd$', '%.ai$'},
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
		cmd = {'Neotree'},
		init = function()
			vim.cmd('cabbrev NTR Neotree reveal')
			vim.api.nvim_set_keymap('n', '<leader>nt', ':Neotree<cr>', {silent = true})
		end,
		config = function()
			require('neo-tree').setup({
				filesystem =  {
					filtered_items = {
						hide_dotfiles = false,
					}
				},
				window = {
					position = 'right'
				}
			})
		end,
	},

	{
		'preservim/vimux',
		cmd = {'VimuxPromptCommand', 'VimuxSendKeys', 'VimuxOpenRunner', 'VimuxRunCommand'},
		init = function ()
			vim.g.VimuxOrientation = 'h'
			vim.g.VimuxCloseOnExit = 1
			local opts = {noremap = true, silent = true}
			vim.keymap.set('n', '<leader>tp', ':VimuxPromptCommand<cr>', opts)
			vim.keymap.set('n', '<leader>th', ':update | call VimuxSendKeys("c-c enter up enter")<cr>', opts)
			vim.keymap.set('n', '<leader>tt', ':VimuxOpenRunner<cr>', opts)
			vim.keymap.set('n', '<leader>tq', ':VimuxCloseRunner<cr>', opts)
			vim.keymap.set('n', '<leader>tg', function ()
				vim.cmd('VimuxRunCommand("lazygit && exit")')
				vim.cmd('VimuxZoomRunner')
			end, opts)
			vim.keymap.set('n', '<leader>ts', function ()
				vim.cmd('VimuxRunCommand(trim(getline(".")))')
			end, opts)
			vim.keymap.set('v', '<leader>ts', function ()
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
		setup = function ()
			vim.g.tmux_navigator_no_mappings = 1
			vim.keymap.set('n', '<c-h>', ':<c-u>TmuxNavigateLeft<cr>', {})
			vim.keymap.set('n', '<c-l>', ':<c-u>TmuxNavigateRight<cr>', {})
			vim.keymap.set('n', '<c-j>', ':<c-u>TmuxNavigateDown<cr>', {})
			vim.keymap.set('n', '<c-k>', ':<c-u>TmuxNavigateUp<cr>', {})
		end
	},

	{
		'uga-rosa/ccc.nvim',
		ft = {'css', 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vim'},
		config = function ()
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
		'gabrielpoca/replacer.nvim',
		ft = {'qf'},
		config = function ()
			vim.keymap.set('n', '<leader>eq', function ()
				require('replacer').run()
			end, {})
		end
	},


	-- {
	-- 	'dyng/ctrlsf.vim',
	-- 	cmd = 'CtrlSF',
	-- 	config = function()
	-- 		vim.g.ctrlsf_ackprg = 'rg'
	-- 	end
	-- },

}, {
	lockfile = vim.env.ROOT .. '/lazy-lock.json',
	performance = {
		rtp = {
			-- lazy.nvim will reset the runtime path so we have to add it back
			paths = { vim.env.ROOT },
		}	
	}
})

