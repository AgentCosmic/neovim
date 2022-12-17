-- auto compile when saving this file
vim.cmd([[
	augroup PackerUserConfig
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerCompile
	augroup end
]])

local packer = require('packer')

packer.startup({function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'


	------------------------------------------------------------------------------
	-- Universal Vim Functionality
	------------------------------------------------------------------------------


	use {
		'wellle/targets.vim',
		event = 'BufRead',
	}

	use {
		'hrsh7th/nvim-cmp',
		requires = {'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'L3MON4D3/LuaSnip'},
		events = 'InsertEnter',
		config = function()
			vim.opt.completeopt = 'menu,menuone,noselect'
			local cmp = require('cmp')
			local cmp_buffer = require('cmp_buffer')
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
				},
				window = {
					documentation = {
						border = 'single'
					},
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
				},
				snippet = {
					expand = function(args)
						-- required even if not used
						require'luasnip'.lsp_expand(args.body)
					end,
				},
			})
		end
	}

	use {
		'rrethy/vim-illuminate',
		event = 'BufRead',
		config = function()
			require('illuminate').configure({
				under_cursor = false,
			})
		end
	}

	use {
		'phaazon/hop.nvim',
		cmd = 'HopWord',
		setup = function()
			vim.api.nvim_set_keymap('n', '<leader>w', ':HopWord<cr>', {noremap = true, silent = true})
		end,
		config = function()
			require('hop').setup()
		end
	}

	use {
		'unblevable/quick-scope',
		event = 'BufRead',
		setup = function()
			vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}
			vim.g.qs_max_chars = 160
		end
	}

	use {
		'numtostr/BufOnly.nvim',
		cmd = {'BufOnly'},
	}

	use {
		'tpope/vim-abolish',
		events = 'CmdwinEnter',
	}

	use {
		'dyng/ctrlsf.vim',
		cmd = 'CtrlSF',
		config = function()
			vim.g.ctrlsf_ackprg = 'rg'
		end
	}

	use {
		'mbbill/undotree',
		cmd = 'UndotreeToggle',
		setup = function()
			vim.cmd 'cabbrev UT UndotreeToggle'
		end
	}


	------------------------------------------------------------------------------
	-- Programming Related
	------------------------------------------------------------------------------


	use {
		'kylechui/nvim-surround',
		config = function()
			require('nvim-surround').setup({})
		end
	}

	use {
		'sickill/vim-pasta',
		event = 'VimEnter',
	}

	use {
		'sheerun/vim-polyglot',
		event = 'BufRead',
	}

	use {
		'michaeljsmith/vim-indent-object',
		event = 'BufRead',
	}

	use {
		'jeetsukumaran/vim-indentwise',
		event = 'BufRead',
	}

	use {
		'jiangmiao/auto-pairs',
		-- TODO can't lazy load
		config = function()
			vim.cmd([[
				augroup AutoPairs
					autocmd!
					autocmd FileType html,vue let b:AutoPairs = AutoPairsDefine({'<!--' : '-->'})
					autocmd FileType css,vue let b:AutoPairs = AutoPairsDefine({'/**' : '*/', '/*' : '*/'})
					autocmd FileType html,htmldjango let b:AutoPairs = AutoPairsDefine({'{%' : '%}'})
					autocmd FileType php let b:AutoPairs = AutoPairsDefine({'<?php' : '?>'})
				augroup end
			]])
		end
	}

	use {
		'numToStr/Comment.nvim',
		event = 'BufRead',
		config = function()
			require('Comment').setup()
			vim.api.nvim_set_keymap('n', '<leader>c', ':normal gcc<cr>', {silent = true})
			vim.api.nvim_set_keymap('v', '<leader>c', ':normal gbc<cr>', {silent = true})
		end
	}

	use {
		'AndrewRadev/sideways.vim',
		cmd = {'SidewaysLeft', 'SidewaysRight'},
		setup = function()
			vim.api.nvim_set_keymap('n', '<c-h>', ':SidewaysLeft<cr>', {noremap = true, silent = true})
			vim.api.nvim_set_keymap('n', '<c-l>', ':SidewaysRight<cr>', {noremap = true, silent = true})
		end
	}

	use {
		'norcalli/nvim-colorizer.lua',
		ft = {'css', 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vim'},
		config = function()
			require('colorizer').setup({
					'css',
					'html',
					'javascript',
					'typescript',
					'javascriptreact',
					'typescriptreact',
					'vim',
				}, { no_names = true })
		end
	}

	use {
		'alvan/vim-closetag',
		ft = {'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'htmldjango', 'php', 'vue'},
		setup = function()
			vim.g.closetag_filetypes = 'html,typescript,typescriptreact,javascriptreact,php,vue'
		end
	}

	use {
		'mattn/emmet-vim',
		ft = {'html', 'css', 'javascriptreact', 'typescriptreact', 'htmldjango'},
		setup = function()
			vim.g.user_emmet_leader_key = '<c-y>'
			vim.g.user_emmet_expandabbr_key = '<c-e>'
			vim.g.user_emmet_settings = {
				typescriptreact = { extends = 'jsx' },
				javascript = { extends = 'jsx' },
				htmldjango = { extends = 'html' },
			}
		end
	}


	------------------------------------------------------------------------------
	-- IDE
	------------------------------------------------------------------------------


	use {
		'ray-x/lsp_signature.nvim',
		event = 'BufRead',
	}

	use {
		'RishabhRD/nvim-lsputils',
		requires = {'RishabhRD/popfix'},
		event = 'BufRead',
	}

	use {
		'neovim/nvim-lspconfig',
		after = {'cmp-nvim-lsp', 'nvim-lsputils', 'lsp_signature.nvim'},
		event = 'BufRead',
		config = function()
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
				vim.cmd('normal zz')
			end

			-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
			local on_attach = function(client, bufnr)
				local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
				local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

				-- Enable completion triggered by <c-x><c-o>
				buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
				-- show signature
				require('lsp_signature').on_attach({}, bufnr)

				-- Mappings.
				local opts = { noremap=true, silent=true }

				-- See `:help vim.lsp.*` for documentation on any of the below functions
				buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				buf_set_keymap('n', '<leader>ac', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
				buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false, border = "rounded"})<cr>', opts)
				buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', opts)
				buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({popup_opts = {border = "rounded"}})<cr>', opts)
				buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next({popup_opts = {border = "rounded"}})<cr>', opts)
				buf_set_keymap('n', 'g=', '<cmd>lua vim.lsp.buf.format({ async = true })<cr>', opts)
				buf_set_keymap('n', '<leader>oi', '<cmd>lua organize_imports()<cr>', opts)
				buf_set_keymap('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				-- buf_set_keymap('n', 'gm', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
				-- use telescope instead
				-- buf_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.references()<cr>', opts)

				-- floating windows
				vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'})
				vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'rounded'})
				-- diagnostics options
				vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					virtual_text = { prefix = '❱' },
				})

				-- lsputils
				vim.lsp.handlers['textDocument/codeAction'] = require('lsputil.codeAction').code_action_handler
				vim.lsp.handlers['textDocument/references'] = require('lsputil.locations').references_handler
				vim.lsp.handlers['textDocument/definition'] = require('lsputil.locations').definition_handler
				vim.lsp.handlers['textDocument/declaration'] = require('lsputil.locations').declaration_handler
				vim.lsp.handlers['textDocument/typeDefinition'] = require('lsputil.locations').typeDefinition_handler
				vim.lsp.handlers['textDocument/implementation'] = require('lsputil.locations').implementation_handler
				vim.lsp.handlers['textDocument/documentSymbol'] = require('lsputil.symbols').document_handler
				vim.lsp.handlers['workspace/symbol'] = require('lsputil.symbols').workspace_handler

				-- auto format
				-- if client.server_capabilities.document_formatting then
				-- 	vim.cmd [[augroup AutoFormat]]
				-- 	vim.cmd [[autocmd! * <buffer>]]
				-- 	vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
				-- 	vim.cmd [[augroup END]]
				-- end
			end

			-- this is where we install all the language servers
			local lsp_bins = vim.fn.stdpath('config')

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
				cmd = { lsp_bins .. '/node_modules/.bin/typescript-language-server', '--stdio' }
			}

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

			-- go get github.com/mattn/efm-langserver
			-- npm install eslint_d prettier
			-- pip install black isort
			local eslint = {
				lintCommand = lsp_bins .. '/node_modules/.bin/eslint_d -f unix --stdin --stdin-filename ${INPUT}',
				lintStdin = true,
				lintFormats = {'%f:%l:%c: %m'},
				lintIgnoreExitCode = true,
				formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
				formatStdin = true
			}
			local prettier_path = './node_modules/.bin/prettier' -- default to local
			local prettier_config = ' --config-precedence file-override --use-tabs --single-quote --print-width 120'
			-- use our own if project doesn't have
			if vim.fn.executable(prettier_path) ~= 1 then
				prettier_path = lsp_bins .. '/node_modules/.bin/prettier'
			end
			prettier_cmd = prettier_path .. prettier_config
			nvim_lsp.efm.setup {
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/efm-langserver' },
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
							{formatCommand = lsp_bins .. '/.venv/bin/black --quiet -', formatStdin = true},
							{formatCommand = lsp_bins .. '/.venv/bin/isort --quiet -', formatStdin = true},
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
				cmd = { lsp_bins .. '/node_modules/.bin/pyright-langserver', '--stdio' }
			}

			-- npm i yaml-language-server
			nvim_lsp.yamlls.setup{
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/node_modules/.bin/yaml-language-server', '--stdio' },
			}

			-- https://docs.soliditylang.org/en/latest/installing-solidity.html
			nvim_lsp.solc.setup{
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { lsp_bins .. '/solc.exe', '--lsp' },
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
	}


	------------------------------------------------------------------------------
	-- GUI
	------------------------------------------------------------------------------


	use {
		'lukas-reineke/indent-blankline.nvim', -- indent guides for spaces
		event = 'BufRead',
	}

	use {
		'noib3/nvim-cokeline',
		event = 'BufRead',
		config = function()
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
		end
	}

	use {
		'nvim-telescope/telescope.nvim',
		requires = {'nvim-lua/plenary.nvim'},
		cmd = {'Telescope'},
		setup = function()
			vim.keymap.set('n', '\\', function()
				vim.cmd(':PackerLoad telescope.nvim') -- we need to manually load it cos we're not calling :Telescope
				local opts = {} -- add additional options here
				local ok = pcall(require('telescope.builtin').git_files, opts)
				if not ok then require('telescope.builtin').find_files(opts) end
			end, {noremap = true, silent = true})
			vim.api.nvim_set_keymap('n', 'gh', ':Telescope oldfiles<cr>', {noremap = true, silent = true})
			vim.api.nvim_set_keymap('n', 'gt', ':Telescope lsp_document_symbols<cr>', {noremap = true, silent = true})
			vim.api.nvim_set_keymap('n', '<leader>rf', ':Telescope lsp_references<cr>', {noremap = true, silent = true})
		end,
		config = function()
			require('telescope').setup({
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
			})
		end
	}

	use {
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v2.x',
		requires = { 
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
			'MunifTanjim/nui.nvim',
		},
		cmd = {'Neotree', 'NeoTreeReveal'},
		setup = function()
			vim.cmd('cabbrev NTR NeoTreeReveal')
			vim.api.nvim_set_keymap('n', '<leader>nt', ':Neotree<cr>', {silent = true})
		end,
		config = function()
			require('neo-tree').setup({
				filesystem =  {
					filtered_items = {
						hide_dotfiles = false,
					}
				}
			})
		end,
	}


	------------------------------------------------------------------------------
	-- Evaluating
	------------------------------------------------------------------------------


	use {
		'perost/modelica-vim',
		ft = {'modelica'},
		config = function()
			vim.cmd('au BufRead,BufNewFile *.mo set filetype=modelica')
		end
	}

	use {
		'voldikss/vim-floaterm',
		cmd = 'FloatermNew',
		config = function()
			vim.g.floaterm_width = 0.9
			vim.g.floaterm_height = 0.9
		end
	}

	use {
		'lewis6991/gitsigns.nvim',
		-- events = 'BufRead',
		cmd = 'Gitsigns',
		config = function()
			require('gitsigns').setup()
		end
	}

end,
config = {
	compile_path = vim.fn.stdpath('config')  .. '/plugin/packer_compiled.vim', -- put in /plugin so it autoloads
	-- :PackerCompile profile=true
	-- restart then :PackerProfile
	-- profile = {
	-- 	enable = true,
	-- 	threshold = 1 -- the amount in ms that a plugin's load time must be over for it to be included in the profile
	-- }
}
})
