vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = false
vim.opt.listchars = {
	tab = '» ',
	trail = '·',
	nbsp = '␣',
}

vim.opt.inccommand = 'split'

vim.opt.cursorline = true

vim.opt.scrolloff = 15

vim.opt.termguicolors = true -- worth making sure that your terminal supports this

vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>z', '<cmd>set wrap!<CR>', { desc = 'toggle line wrapping [ ][z]'})

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode.' })

vim.keymap.set('n', '<left>', '<cmd>echo "Arrow keys are unbound. Use hjkl to move."<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Arrow keys are unbound. Use hjkl to move."<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Arrow keys are unbound. Use hjkl to move."<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Arrow keys are unbound. Use hjkl to move."<CR>')

vim.keymap.set('n', '<leader>yfp', '<cmd>let @+ = expand("%")<CR><cmd>echo "Relative path to current buffer yanked."<CR>', { desc = '[ ] [y]ank [f]ile [p]ath' })
vim.keymap.set('n', '<leader>yffp', '<cmd>let @+ = expand("%:p")<CR><cmd>echo "Relative full path to current buffer yanked."<CR>', { desc = '[ ] [y]ank [f]ull [f]ile [p]ath' })

-- highlight on yank; see `:h vim.highlight.on_yank()`
local hlygroup = vim.api.nvim_create_augroup('-hl-yank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	group = hlygroup,
	pattern = '*',
	callback = function()
		vim.highlight.on_yank()
	end,
})

local lazypath = vim.fn.stdpath('data') .. 'lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	local repo = 'https://github.com/folke/lazy.nvim.git'
	vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', repo, lazypath })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
	-- theming
	{ 'catppuccin/nvim',
		priority = 1000,
		lazy = false,
		config = function()
			require('catppuccin').setup({
				flavour = 'macchiato',
				transparent_background = true,
				color_overrides = {
					macchiato = {
						maroon = "#ed8796",
					},
				},
			})
			require('catppuccin').load()
		end,
	},

	-- lualine for simple status
	{ 'nvim-lualine/lualine.nvim', -- see `:h lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				theme = 'auto',
				component_separators = '|',
				section_separators = '',
			},
		},
	},

	{ 'tpope/vim-sleuth' }, -- detect tabstop and shiftwidth automagically
	{ 'numToStr/Comment.nvim', opts = {} }, -- "gc" to comment visual regions/lines
	{ 'kdheepak/lazygit.nvim',
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<CR>", desc = "[ ] [l]azy [g]it" },
		},
	},
	{ 'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local keymap = function(mode, keys, func, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, keys, func, opts)
				end

				-- Navigation
				keymap({ 'n', 'v' }, ']gc', function()
					if vim.wo.diff then
						return ']gc'
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return '<Ignore>'
				end, { expr = true, desc = '[]] next [g]it [c]hange' })

				keymap({ 'n', 'v' }, '[gc', function()
					if vim.wo.diff then
						return '[gc'
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return '<Ignore>'
				end, { expr = true, desc = '[[] previous [g]it [c]hange' })

				-- visual mappings
				keymap('v', '<leader>ghs', function()
					gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
				end, { desc = '[g]it [h]unk [s]tage (visually selected)' })
				keymap('v', '<leader>ghs', function()
					gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
				end, { desc = '[g]it [h]unk [r]eset (visually selected)' })

				-- normal mappings
				keymap('n', '<leader>ghs', gs.stage_hunk, { desc = '[g]it [h]unk [s]tage' })
				keymap('n', '<leader>ghR', gs.reset_hunk, { desc = '[g]it [h]unk [R]eset' })
				keymap('n', '<leader>gbs', gs.stage_buffer, { desc = '[g]it [b]uffer [s]tage' })
				keymap('n', '<leader>ghu', gs.undo_stage_hunk, { desc = '[g]it [h]unk [u]ndo stage' })
				keymap('n', '<leader>ghR', gs.reset_buffer, { desc = '[g]it [b]uffer [R]eset' })
				keymap('n', '<leader>ghp', gs.preview_hunk, { desc = '[g]it [h]unk [p]review' })
				keymap('n', '<leader>gb', function()
					gs.blame_line({ full = false })
				end, { desc = '[g]it [b]lame line' })
				keymap('n', '<leader>gB', '<cmd>:Git blame<CR>', { desc = '[g]it [B]lame whole file in buffer' })
				keymap('n', '<leader>gd', gs.diffthis, { desc = '[g]it [d]iff against index' })
				keymap('n', '<leader>gD', function()
					gs.diffthis('~')
				end, { desc = '[g]it [D]iff against last commit' })

				-- Toggles
				keymap('n', '<leader>gtb', gs.toggle_current_line_blame, { desc = '[g]it [t]oggle [b]lame line' })
				keymap('n', '<leader>gtd', gs.toggle_deleted, { desc = '[g]it [t]oggle [d]eleted' })
			end,
		},
	},

	-- some basic git tooling
	{ 'tpope/vim-fugitive' },
	{ 'tpope/vim-rhubarb' },

	-- add indent guides even on blank lines
	{ 'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		opts = {
			indent = { char = '▏' },
		},
	},

	-- allows for scrolling past the end of the file with the vim.opt.scrolloff setting
	{ 'Aasim-A/scrollEOF.nvim',
		event = { 'CursorMoved', 'WinScrolled' },
		opts = {
			insert_mode = false,
			floating = true,
		},
	},

	-- telescope fuzzystuff
	{ 'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		branch = '0.1.x',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function()
					return vim.fn.executable('make') == 1
				end,
			},
			{ 'nvim-telescope/telescope-ui-select.nvim' },
			{ 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
		},
		config = function()
			require('telescope').setup({
				extensions = {
					['ui-select'] = {
						require('telescope.themes').get_dropdown(),
					},
				},
				defaults = {
					hidden = true,
				},
				pickers = {
					find_files = {
						hidden = true,
						find_command = {
							"rg",
							"--files",
							"--follow",        -- Follow symbolic links
							"--hidden",        -- Search for hidden files
							"--no-heading",    -- Don't group matches by each file
							"--with-filename", -- Print the file path with the matched lines
							"--line-number",   -- Show line numbers
							"--column",        -- Show column numbers
							"--smart-case",    -- Smart case search
							-- Exclude some patterns from search
							"--glob=!**/.git/*",
						},
					},
					live_grep = {
						hidden = true,
						additional_args = {
							"--hidden",
						},
					},
				},
			})

			-- enable telescope extensions if they are installed
			pcall(require('telescope').load_extension, 'fzf')
			pcall(require('telescope').load_extension, 'ui-select')

			-- see `:h telescope.builtin`
			local ts = require('telescope.builtin')
			vim.keymap.set('n', '<leader>fh', ts.help_tags, { desc = '[f]ind [h]elp' })
			vim.keymap.set('n', '<leader>fk', ts.keymaps, { desc = '[f]ind [k]eymap' })
			vim.keymap.set('n', '<leader>ff', ts.find_files, { desc = '[f]ind [f]ile' })
			vim.keymap.set('n', '<leader>ft', ts.builtin, { desc = '[f]ind [t]elescope builtins' })
			vim.keymap.set('n', '<leader>fw', ts.grep_string, { desc = '[f]ind [w]ord (current)' })
			vim.keymap.set('n', '<leader>fg', ts.live_grep, { desc = '[f]ind by [g]rep' })
			vim.keymap.set('n', '<leader>fd', ts.diagnostics, { desc = '[f]ind [d]iagnostics' })
			vim.keymap.set('n', '<leader>fr', ts.resume, { desc = '[f]ind [r]esume' })
			vim.keymap.set('n', '<leader>f.', ts.oldfiles, { desc = '[f]ind recent files (. for repeat)' })
			vim.keymap.set('n', '<leader><leader>', ts.buffers, { desc = '[ ] find buffer' })

			vim.keymap.set('n', '<leader>/',
				function()
					ts.current_buffer_fuzzy_find(
						require('telescope.themes').get_dropdown({
							winblend = 10,
							previewer = false,
						})
					)
				end,
				{ desc = '[/] fuzzy search current buffer' }
			)

			vim.keymap.set('n', '<leader>f/',
				function()
					ts.livegrep({
						grep_open_files = true,
						prompt_title = 'live grep on open files',
					})
				end,
				{ desc = '[f]ind [/] fuzzily in open files' }
			)

			vim.keymap.set('n', '<leader>fn',
				function()
					ts.find_files({ cwd = vim.fn.stdpath('config') })
				end,
				{ desc = '[f]ind [n]eovim config files' }
			)
		end,
	},

	-- lsp config and plugins
	{ 'neovim/nvim-lspconfig',
		dependencies = {
			-- automatically install lsp and related tooling to nvim stdpath
			{ 'williamboman/mason.nvim', config = true },
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'WhoIsSethDaniel/mason-tool-installer.nvim' },

			-- useful status updates for lsp
			{ 'j-hui/fidget.nvim', opts = {} },

			-- neodev configures lua lsp for the nvim config, runtime, and plugins -> adds nvim completion and api signatures
			{ 'folke/neodev.nvim', opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('-lsp-attach', { clear = true }),
				callback = function(event)
					local ts = require('telescope.builtin')

					local mapkey = function(mode, keys, func, desc)
						pcall(vim.keymap.del, mode, keys, { buffer = event.buf })
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'lsp: ' .. desc })
					end

					mapkey('n', 'gd', ts.lsp_definitions, '[g]oto [d]efinition')
					mapkey('n', 'gr', ts.lsp_references, '[g]oto [r]eferences')
					mapkey('n', 'gi', ts.lsp_implementations, '[g]oto [I]mplementation')
					mapkey('n', 'gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
					mapkey('n', '<leader>gd', ts.lsp_type_definitions, '[ ] [g]oto type [d]efinition')

					mapkey('n', '<leader>ds', ts.lsp_document_symbols, 'find [d]ocument [s]ymbols')
					mapkey('n', '<leader>ws', ts.lsp_dynamic_workspace_symbols, 'find [w]orkspace [s]ymbols')

					mapkey('n', '<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame symbol under cursor')
					mapkey('n', '<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction under cursor')

					mapkey('n', 'K', vim.lsp.buf.hover, '[K] show hover documentation under cursor')
					mapkey('n', 'KK', vim.diagnostic.open_float, '[KK] show hover documentation for errors or diagnostic messages')

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- highlight references of word under cursor after hover
					if client and client.server_capabilities.documentHighlightProvider then
						local hl_augroup = vim.api.nvim_create_augroup('-lsp-highlight', { clear = false })

						vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
							buffer = event.buf,
							group = hl_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
							buffer = event.buf,
							group = hl_augroup,
							callback = vim.lsp.buf.clear_references,
						})
					end

					-- inlay hints in your code if the lsp supports it
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						vim.lsp.inlay_hint.enable(false)

						mapkey(
							'n',
							'<leader>ih',
							function()
								vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
							end,
							'toggle lsp [i]nlay [h]ints'
						)
					end
				end,
			})

			vim.api.nvim_create_autocmd('LspDetach', {
				group = vim.api.nvim_create_augroup('-lsp-detach', { clear = true }),
				callback = function(event)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = '-lsp-highlight', buffer = event.buf })
				end,
			})

			-- by default neovim doesnt support all lsp functions, nvim-cmp and luasnip tries to add support for the neovim features
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

			-- lets pre-install some language servers; see `:help lspconfig-all` for a list of preconfigured lsps
			local servers = {
				ts_ls = {
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = 'all',
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							}
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = 'all',
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							}
						},
					},
				},
				gopls = {
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			}

			-- ensure mason servers are installed, you can check with `:Mason` and use `g?` in its menu for help
			require('mason').setup()

			-- install language servers and anything else you might want to add
			local ensure_installed = vim.tbl_keys(servers or {})
			-- vim.list_extend(ensureInstalled, {})
			require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

			require('mason-lspconfig').setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- override only values explicitly passed by above server config
						server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
						require('lspconfig')[server_name].setup(server)
					end,
				},
			})
		end,
	},

	-- treesitter completion, highlighting, and navigating goodness
	{ 'nvim-treesitter/nvim-treesitter',
		dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
		build = ':TSUpdate',
		opts = {
			-- auto install language support that isn't installed
			ensure_installed = {
				'bash',
				'c',
				'javascript',
				'jsdoc',
				'typescript',
				'go',
				'html',
				'css',
				'yaml',
				'json',
				'lua',
				'luadoc',
				'markdown',
				'vim',
				'vimdoc',
				'ssh_config',
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { 'ruby' },
			},
			indent = {
				enable = true,
				disable = { 'ruby' },
			},
		},
	},

	-- file browser in a buffer
	{ 'stevearc/oil.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		config = function()
			require('oil').setup({
				default_file_explorer = true,
				columns = { "icon" },
				view_options = {
					show_hidden = true,
				},
			})

			vim.keymap.set('n', '<leader>fb', "<CMD>Oil --float<CR>", { desc = '[f]ile [b]rowser (Oil)' })
			vim.keymap.set('n', '<leader>FF', "<CMD>Oil --float<CR>", { desc = '[F]ile [F] browser (Oil)' })
			vim.keymap.set('n', '<S-leader>FF', "<CMD>Oil --float<CR>", { desc = '[F]ile [F] browser (Oil)' })
		end,
	},

	-- auto formatting config
	{ 'stevearc/conform.nvim',
		lazy = false,
		keys = {
			{
				'<leader>c',
				function()
					require('conform').format({ async = true, lsp_fallback = true })
				end,
				mode = '',
				desc = '[c]onform to the formatting gods',
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = true,
			formatters_by_ft = {
				go = { 'goimports', 'gofmt' },
				typescript = { 'eslint', 'prettierd', 'prettier', stop_after_first = true },
				javascript = { 'eslint', 'prettierd', 'prettier', stop_after_first = true },
				['*'] = { 'trim_whitespace' },
			},
		},
	},

	-- autocomplete by nvim-cmp
	{ 'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{ 'L3MON4D3/LuaSnip',
				build = 'make install_jsregexp',
				dependencies = {
					{ 'rafamadriz/friendly-snippets', -- friendly-snippets contain some useful premade snippets for a couple of langs
						config = function()
							require('luasnip.loaders.from_vscode').lazy_load()
						end,
					},
				},
			},
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-path' },
		},
		config = function()
			local cmp = require('cmp')
			local snip = require('luasnip')

			snip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						snip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = 'menu,menuone,noinsert' },
				mapping = cmp.mapping.preset.insert({ -- see: `:help ins-completion` for why these mappings were chosen
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-n>'] = cmp.mapping.select_next_item(), -- [n]ext item
          ['<Tab>'] = cmp.mapping.select_next_item(),

					['<C-p>'] = cmp.mapping.select_prev_item(), -- [p]revious item
					['<S-Tab>'] = cmp.mapping.select_prev_item(),

          				['<C-f>'] = cmp.mapping.scroll_docs(4), -- scroll the docs withdow [f]orward
					['<C-b>'] = cmp.mapping.scroll_docs(-4), -- scroll the docs window [b]ackward

					['<C-y>'] = cmp.mapping.confirm({ select = true }), -- accept the current snippet/import/completion
					['<CR>'] = cmp.mapping.confirm({ select = true }),

					-- jump to next placeholder in snippet, think of Ctrl+Right(l), and Ctrl+Left(h) as moving right (fwd) and left (bwd) through the snippet
					['<C-l>'] = cmp.mapping(
						function()
          						if luasnip.expand_or_locally_jumpable() then
          							luasnip.expand_or_jump()
          						end
          					end,
						{ 'i', 's' }
					),
					['<C-h>'] = cmp.mapping(
						function()
          						if luasnip.locally_jumpable(-1) then
          							luasnip.jump(-1)
          						end
          					end,
						{ 'i', 's' }
					),

					-- for more snippets, see https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
				},
			})
		end,
	},

	-- highlight todos, notes, etc in comments
	{ 'folke/todo-comments.nvim',
		event = 'VimEnter',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = { signs = false },
	},
})

