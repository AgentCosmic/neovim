-----------------------------------------------------------------------------
-- Universal Vim Functionality
------------------------------------------------------------------------------

vim.pack.add({ { src = 'https://github.com/saghen/blink.cmp', version = 'v1' } })
local blink = require('blink.cmp')
blink.setup({
	keymap = {
		preset = 'default',
		['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
		['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
		['<CR>'] = { 'accept', 'fallback' },
		['<C-e>'] = {},
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
		},
		keyword = { range = 'prefix' },
		trigger = {
			show_on_keyword = true,
			show_on_trigger_character = true,
			show_in_snippet = false,
		},
		list = {
			selection = {
				preselect = false,
				auto_insert = true,
			}
		},
		menu = {
			max_height = 20,
		},
	},
	cmdline = {
		completion = {
			list = {
				selection = {
					preselect = false,
					auto_insert = true,
				}
			},
		}
	},
	signature = { enabled = true },
	sources = {
		default = { 'lsp', 'buffer', 'path', 'snippets' },
		providers = {
			lsp = {
				-- remove language keywords/constants (if, else, while, etc.) provided by the language server
				name = 'LSP',
				module = 'blink.cmp.sources.lsp',
				transform_items = function(_, items)
					return vim.tbl_filter(function(item)
						return item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
					end, items)
				end,
			},
			snippets = {
				opts = {
					search_paths = { vim.env.ROOT .. '/snippets' },
				},
			},
			cmdline = {
				enabled = true,
			}
		},
	},
})
vim.lsp.config('*', {
	capabilities = blink.get_lsp_capabilities({}, false),
})

----------

vim.pack.add({ 'https://github.com/rrethy/vim-illuminate' })
require('illuminate').configure({
	under_cursor = false,
})

----------

vim.pack.add({ 'https://github.com/smoka7/hop.nvim' })
vim.api.nvim_set_keymap('n', '<leader>h', ':HopChar1<cr>', { noremap = true, silent = true })
vim.api.nvim_create_autocmd('CmdlineEnter', {
	once = true,
	callback = function()
		require('hop').setup({
			-- customized for custom keyboard layout, excluding Q & Z
			keys = 'etahiscnodywkrgpjmbfulxv',
		})
	end
})

----------

vim.pack.add({ 'https://github.com/tpope/vim-abolish' })

----------

vim.pack.add({ 'https://github.com/Shatur/neovim-session-manager', 'https://github.com/nvim-lua/plenary.nvim' })
require('session_manager').setup({
	sessions_dir = require('plenary.path'):new(vim.fn.stdpath('data'), 'sessions'),
	autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
	autosave_last_session = true,
	autosave_only_in_session = true,
	autosave_ignore_filetypes = { 'gitcommit', 'gitrebase', 'neo-tree' },
})


------------------------------------------------------------------------------
-- Programming Related
------------------------------------------------------------------------------


vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

----------

vim.pack.add({
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter',             version = 'main' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' }
})
require('nvim-treesitter').install({ 'vim', 'vimdoc', 'lua', 'javascript', 'typescript', 'html', 'css',
	'python', 'markdown', 'tsx', 'vue', 'go' })
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.bo.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == 'nvim-treesitter' and kind == 'update' then
			if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
			vim.cmd('TSUpdate')
		end
	end
})

require('nvim-treesitter-textobjects').setup({
	select = {
		-- Automatically jump forward to textobj
		lookahead = true,
		-- Use linewise selection for some textobj
		selection_modes = {
			['@function.outer'] = 'V',
			['@class.outer'] = 'V',
			['@block.outer'] = 'V',
		},
	},
})

-- Disable entire built-in ftplugin mappings to avoid conflicts.
vim.g.no_plugin_maps = true

vim.keymap.set({ 'x', 'o' }, 'af', function()
	require 'nvim-treesitter-textobjects.select'.select_textobject('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'if', function()
	require 'nvim-treesitter-textobjects.select'.select_textobject('@function.inner', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
	require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
	require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ac', function()
	require 'nvim-treesitter-textobjects.select'.select_textobject('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ic', function()
	require 'nvim-treesitter-textobjects.select'.select_textobject('@class.inner', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']C', function()
	require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[C', function()
	require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ab', function()
	require 'nvim-treesitter-textobjects.select'.select_textobject('@block.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ib', function()
	require 'nvim-treesitter-textobjects.select'.select_textobject('@block.inner', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']b', function()
	require('nvim-treesitter-textobjects.move').goto_next_start('@block.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[b', function()
	require('nvim-treesitter-textobjects.move').goto_previous_start('@block.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']r', function()
	require('nvim-treesitter-textobjects.move').goto_next_start('@return.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[r', function()
	require('nvim-treesitter-textobjects.move').goto_previous_start('@return.outer', 'textobjects')
end)

local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'
-- Repeat movement with ; and ,
-- vim way: ; goes to the direction you were moving.
vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)
-- make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })

----------

vim.pack.add({ 'https://github.com/kylechui/nvim-surround' })

----------

vim.pack.add({ 'https://github.com/michaeljsmith/vim-indent-object' })

----------

vim.pack.add({ 'https://github.com/jeetsukumaran/vim-indentwise' })

----------

vim.pack.add({ { src = 'https://github.com/altermo/ultimate-autopair.nvim', version = 'v0.6' } })
vim.api.nvim_create_autocmd('InsertEnter', {
	once = true,
	callback = function()
		require('ultimate-autopair').setup({})
	end
})

----------

vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })

----------

vim.pack.add({ 'https://github.com/AndrewRadev/sideways.vim' })
vim.api.nvim_set_keymap('n', '<a-h>', ':SidewaysLeft<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<a-l>', ':SidewaysRight<cr>', { noremap = true, silent = true })

----------

vim.pack.add({ 'https://github.com/alvan/vim-closetag' })
vim.g.closetag_filetypes = 'html,typescript,typescriptreact,javascriptreact,svg,php,vue'

----------

vim.pack.add({ 'https://github.com/mattn/emmet-vim' })
vim.g.user_emmet_leader_key = '<c-y>'
vim.g.user_emmet_expandabbr_key = '<c-e>'
vim.g.user_emmet_settings = {
	typescriptreact = { extends = 'jsx' },
	javascript = { extends = 'jsx' },
	htmldjango = { extends = 'html' },
}

----------

vim.pack.add({ 'https://github.com/supermaven-inc/supermaven-nvim' })
require('supermaven-nvim').setup({
	keymaps = {
		accept_suggestion = '<c-b>',
	},
})
-- alternatives
-- Exafunction/windsurf.nvim
-- Exafunction/windsurf.vim
-- monkoose/neocodeium


------------------------------------------------------------------------------
-- UI
------------------------------------------------------------------------------


vim.pack.add({ 'https://github.com/willothy/nvim-cokeline' })
local cokeline_mappings = require('cokeline/mappings')
local is_picking_focus = cokeline_mappings.is_picking_focus
local is_picking_close = cokeline_mappings.is_picking_close
local get_hl_attr = require('cokeline.hlgroups').get_hl_attr
require('cokeline').setup({
	show_if_buffers_are_at_least = 0,
	pick = {
		-- customized for custom keyboard layout, excluding Q & Z
		letters = 'etahiscnodywkrgpjmbfulxv'
	},
	default_hl = {
		fg = function(buffer)
			return buffer.is_focused and get_hl_attr('TabLineSel', 'fg') or get_hl_attr('TabLine', 'fg')
		end,
		bg = function(buffer)
			return buffer.is_focused and get_hl_attr('TabLineSel', 'bg') or get_hl_attr('TabLine', 'bg')
		end
	},
	components = {
		-- anchor
		{
			text = ' ',
			bg = function(buffer)
				return buffer.is_focused and get_hl_attr('Comment', 'fg') or get_hl_attr('TabLine', 'bg')
			end,
		},
		-- icon, selector
		{
			text = function(buffer)
				return (is_picking_focus() or is_picking_close()) and ' ' .. buffer.pick_letter .. ' ' or
					' ' .. buffer.devicon.icon
			end,
			fg = function(buffer)
				return (is_picking_focus() and get_hl_attr('WarningMsg', 'fg')) or
					(is_picking_close() and get_hl_attr('Error', 'fg')) or buffer.devicon.color
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
					return get_hl_attr('ModeMsg', 'fg')
				end
				if buffer.is_focused then
					return get_hl_attr('TabLineSel', 'fg')
				end
				return get_hl_attr('TabLine', 'fg')
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

vim.api.nvim_set_keymap('n', '<tab>', '<Plug>(cokeline-focus-next)', { silent = true })
vim.api.nvim_set_keymap('n', '<s-tab>', '<Plug>(cokeline-focus-prev)', { silent = true })
vim.api.nvim_set_keymap('n', '<leader><tab>', '<Plug>(cokeline-pick-focus)', { silent = true })
vim.api.nvim_create_user_command('MoveTabRight', function()
	cokeline_mappings.by_step('switch', 1)
end, {})
vim.api.nvim_create_user_command('MoveTabLeft', function()
	cokeline_mappings.by_step('switch', -1)
end, {})

----------

vim.pack.add({ 'https://github.com/nvim-telescope/telescope.nvim', 'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/neovim/nvim-lspconfig' }) -- lsp must load first to enable lsp pickers
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
vim.api.nvim_create_autocmd('CmdlineEnter', {
	once = true,
	callback = function()
		require('telescope').setup({
			defaults = {
				file_ignore_patterns = { '.git/', 'node_modules/', '.venv/', 'venv/', '__pycache__/', '%.jpeg$', '%.jpg$', '%.png$', '%.gif$' },
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
})

----------

vim.pack.add(
	{
		{ src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',        version = 'v3.x' },
		{ src = 'https://github.com/nvim-lua/plenary.nvim' },
		{ src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- not strictly required, but recommended
		{ src = 'https://github.com/MunifTanjim/nui.nvim' },
		{ src = 'https://github.com/antosha417/nvim-lsp-file-operations' }
	}
)
vim.cmd('cabbrev NT Neotree reveal')
vim.api.nvim_set_keymap('n', '<leader>nt', ':Neotree<cr>', { silent = true })
vim.api.nvim_create_autocmd('CmdlineEnter', {
	once = true,
	callback = function()
		require('neo-tree').setup({
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
				}
			},
			close_if_last_window = true,
		})
		-- integrate file operations with lsp
		local lsp_file_operations = require('lsp-file-operations')
		lsp_file_operations.setup()
		local lspconfig = require('lspconfig')
		-- set global defaults for all servers
		lspconfig.util.default_config = vim.tbl_extend(
			'force',
			lspconfig.util.default_config,
			{
				capabilities = vim.tbl_deep_extend(
					'force',
					vim.lsp.protocol.make_client_capabilities(),
					lsp_file_operations.default_capabilities()
				)
			}
		)
	end
})

----------

vim.pack.add({ 'https://github.com/preservim/vimux' })
vim.g.VimuxOrientation = 'h'
vim.g.VimuxHeight = '33%'
-- vim.g.VimuxCloseOnExit = 1
vim.keymap.set('n', '<leader>tp', ':VimuxPromptCommand<cr>')
vim.keymap.set('n', '<leader>th', ':update | call VimuxSendKeys("c-c enter up enter")<cr>')
vim.keymap.set('n', '<leader>tt', ':VimuxOpenRunner<cr>')
vim.keymap.set('n', '<leader>tq', ':VimuxCloseRunner<cr>')
vim.keymap.set('n', '<leader>tg', function()
	vim.cmd('VimuxRunCommand("lazygit && exit")')
	vim.cmd('VimuxZoomRunner')
end)
vim.keymap.set('n', '<leader>ts', function()
	vim.cmd('VimuxRunCommand(trim(getline(".")))')
end)
vim.keymap.set('v', '<leader>ts', function()
	local vstart = vim.fn.getpos("'<")[2]
	local vend = vim.fn.getpos("'>")[2]
	local lstart = math.min(vstart, vend)
	local lend = math.max(vstart, vend)
	for i = lstart, lend, 1 do
		vim.cmd('VimuxRunCommand(trim(getline(' .. i .. ')))')
	end
end)

----------

vim.pack.add({ 'https://github.com/christoomey/vim-tmux-navigator' })
vim.g.tmux_navigator_no_mappings = 1
vim.keymap.set('n', '<c-h>', ':<c-u>TmuxNavigateLeft<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-l>', ':<c-u>TmuxNavigateRight<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-j>', ':<c-u>TmuxNavigateDown<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-k>', ':<c-u>TmuxNavigateUp<cr>', { noremap = true, silent = true })

----------

vim.pack.add({ 'https://github.com/uga-rosa/ccc.nvim' })
local ccc = require('ccc')
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

----------

vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })
require('gitsigns').setup({})

----------

vim.pack.add({ 'https://github.com/folke/trouble.nvim' })
vim.api.nvim_create_autocmd('CmdlineEnter', {
	once = true,
	callback = function()
		require('trouble').setup({ auto_preview = false })
	end
})


------------------------------------------------------------------------------
-- Evaluating
------------------------------------------------------------------------------

vim.pack.add({ 'https://github.com/robitx/gp.nvim' })
vim.api.nvim_create_autocmd('CmdlineEnter', {
	once = true,
	callback = function()
		require('gp').setup({
			providers = {
				googleai = {
					endpoint =
					'https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}',
					secret = os.getenv('GEMINI_API_KEY'),
				},
				openrouter = {
					endpoint = 'https://openrouter.ai/api/v1/chat/completions',
					secret = os.getenv('OPENROUTER_API_KEY'),
				},
				openai = {
					disable = true,
				}
			},
			agents = {
				{
					name = 'CodeGemini',
					provider = 'googleai',
					chat = false,
					command = true,
					model = { model = 'gemini-2.5-flash' },
					system_prompt = require('gp.defaults').code_system_prompt,
				},
				{
					name = 'ChatGeminiPro',
					provider = 'googleai',
					chat = false,
					command = true,
					model = { model = 'gemini-2.5-pro' },
					system_prompt = require('gp.defaults').code_system_prompt,
				},
				{
					name = 'ChatGemini',
					provider = 'googleai',
					chat = true,
					command = false,
					model = { model = 'gemini-2.5-flash' },
					system_prompt = require('gp.defaults').chat_system_prompt,
				},
				{
					name = 'CodeDeepSeek',
					provider = 'openrouter',
					chat = false,
					command = true,
					model = { model = 'deepseek/deepseek-chat-v3.1:free' },
					system_prompt = require('gp.defaults').code_system_prompt,
				},
				{
					name = 'CodeQwen',
					provider = 'openrouter',
					chat = false,
					command = true,
					model = { model = 'qwen/qwen3-235b-a22b:free' },
					system_prompt = require('gp.defaults').code_system_prompt,
				},
			},
		})
	end
})
