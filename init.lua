-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
	vim.cmd [[packadd packer.nvim]]
end

local Love = {}

require('packer').startup(function(use)
	-- Package manager
	use 'wbthomason/packer.nvim'

	use { -- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		requires = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'j-hui/fidget.nvim',
			'folke/neodev.nvim',
		},
	}

	use {
		'hrsh7th/nvim-cmp',
		requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
		  pcall(require('nvim-treesitter.install').update { with_sync = true })
		end,
	}

	use {
		'nvim-treesitter/nvim-treesitter-textobjects',
		after = 'nvim-treesitter',
	}

	-- Git related plugins
	use 'tpope/vim-fugitive'
	use 'tpope/vim-rhubarb'
	use 'lewis6991/gitsigns.nvim'

	use 'navarasu/onedark.nvim' -- Theme inspired by Atom
	use 'nvim-lualine/lualine.nvim' -- Fancier statusline
	use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
	use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
	use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
	use "gpanders/editorconfig.nvim"
	use "f-person/git-blame.nvim"
	use "simnalamburt/vim-mundo"
	-- use "bkad/CamelCaseMotion"
	use {"chrisgrieser/nvim-spider"}
	use "jdhao/whitespace.nvim"
	use "luisiacc/gruvbox-baby"

	use 'm4xshen/autoclose.nvim'
	require("autoclose").setup({})

	use "yamatsum/nvim-cursorline"
	require('nvim-cursorline').setup {
		cursorline = {
			enable = false,
			timeout = 1000,
			number = false,
		},
		cursorword = {
			enable = true,
			min_length = 3,
			hl = { underline = true },
		}
	}

	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		}
	})

	use 'nvim-tree/nvim-web-devicons'

	use {'romgrk/barbar.nvim', wants = 'nvim-web-devicons'}
	require("bufferline").setup({
		animation = false,
		tabpages = false,
		-- closable = false,
		clickable = false,
	})

	use {
		'm-demare/hlargs.nvim',
		requires = { 'nvim-treesitter/nvim-treesitter' }
	}
	require('hlargs').setup()

	use({
		"utilyre/barbecue.nvim",
		requires = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		after = "nvim-web-devicons", -- keep this if you're using NvChad
		config = function()
			require("barbecue").setup({
				symbols = {
					modified = "●",
					ellipsis = "…",
					separator = " | ",
				},
				kinds = {
					File = "", Module = "", Namespace = "",
					Package = "", Class = "", Method = "",
					Property = "", Field = "", Constructor = "",
					Enum = "", Interface = "", Function = "",
					Variable = "", Constant = "", String = "",
					Number = "", Boolean = "", Array = "",
					Object = "", Key = "", Null = "",
					EnumMember = "", Struct = "", Event = "",
					Operator = "", TypeParameter = "",
				},
			})
		end,
	})

	use {
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup()
		end
	}

	use "tikhomirov/vim-glsl"

	use {
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
	}

	use({
		'Wansmer/treesj',
		requires = { 'nvim-treesitter' },
		config = function()
			require('treesj').setup({})
		end,
	})

	use({
		"NeogitOrg/neogit",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"sindrets/diffview.nvim",
		},
		config = function()
			require("neogit").setup({})
		end,
	})

	-- Fuzzy Finder (files, lsp, etc)
	use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

	-- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
	local has_plugins, plugins = pcall(require, 'custom.plugins')
	if has_plugins then
		plugins(use)
	end

	if is_bootstrap then
		require('packer').sync()
	end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
	print '=================================='
	print '	 Plugins are being installed'
	print '	 Wait until Packer completes,'
	print '		then restart nvim'
	print '=================================='
	return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
	command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
	group = packer_group,
	pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 200
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme gruvbox-baby]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.relativenumber = true
vim.o.expandtab = false
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.wrap = true
vim.o.list = true
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "space:⋅"

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--	NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


local opts = { noremap = true, silent = true }
local map = vim.keymap.set
map("n", "<ESC>", "<cmd>nohlsearch<CR>", opts)
map("n", "ss", "ciw", opts)
map("n", "<leader><space>", "<C-w>w", opts)
map("n", "H", "^", opts)
map("n", "L", "$", opts)
map("n", "<space>o", "<C-w>o", opts)
map("n", "<space>b", "<cmd>BufferPrevious<CR>", opts)
map("n", "<space>n", "<cmd>BufferNext<CR>", opts)
map("n", "<space>x", "<cmd>BufferClose<CR>", opts)
map("n", "<C-p>", function() require("telescope.builtin").find_files() end, { desc = "Search files" })
map("n", "<space>g", "<cmd>lua require(\'telescope.builtin\').grep_string({search = vim.fn.expand('<cword>')})<cr>",
	{})
map("n", "<F5>", "<cmd>MundoToggle<cr>", opts)
map("n", "<C-a>", "ggVG", opts)
map("n", "<leader>e", "<cmd>NeoTreeShowToggle<CR>", opts)
map("n", "<F4>", "<cmd>TroubleToggle<CR>", opts)


-- vim.cmd [[
-- 	map <silent> w <Plug>CamelCaseMotion_w
-- 	map <silent> b <Plug>CamelCaseMotion_b
-- 	map <silent> e <Plug>CamelCaseMotion_e
-- 	sunmap w
-- 	sunmap b
-- 	sunmap e
-- ]]

vim.keymap.set({"n", "o", "x"}, "w", function() require("spider").motion("w") end, { desc = "Spider-w" })
vim.keymap.set({"n", "o", "x"}, "e", function() require("spider").motion("e") end, { desc = "Spider-e" })
vim.keymap.set({"n", "o", "x"}, "b", function() require("spider").motion("b") end, { desc = "Spider-b" })
vim.keymap.set({"n", "o", "x"}, "ge", function() require("spider").motion("ge") end, { desc = "Spider-ge" })

vim.filetype.add({
	extension = {
		lua = function()
			Love.SetLove()
			return "lua"
		end,
		lua2p = function()
			Love.SetLua2p()
		end,
		norg = function()
			vim.opt_local.expandtab = true
		end
	}
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
-- local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
-- vim.api.nvim_create_autocmd('TextYankPost', {
-- 	callback = function()
-- 		vim.highlight.on_yank()
-- 	end,
-- 	group = highlight_group,
-- 	pattern = '*',
-- })


local win32yank = "/mnt/c/Users/user/Documents/win32yank/win32yank.exe"
vim.g.clipboard = {
	name = "win3yank-wsl",
	copy = {
		["+"] = win32yank .. " -i --crlf",
		["*"] = win32yank .. " -i --crlf"
	},
	paste = {
		["+"] = win32yank .. " -o --crlf",
		["*"] = win32yank .. " -o --crlf"
	},
	cache_enable = 0,
}


-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
	options = {
		icons_enabled = false,
		theme = 'auto',
		component_separators = '|',
		section_separators = '',
	},
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
	char = '┊',
	show_trailing_blankline_indent = true,
	show_end_of_line = true,
	space_char_blankline = " ",
	show_current_context = true,
	show_current_context_start = true,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
	signs = {
		add = { text = '+' },
		change = { text = '~' },
		delete = { text = '_' },
		topdelete = { text = '‾' },
		changedelete = { text = '~' },
	},
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
	defaults = {
		mappings = {
		  i = {
			['<C-u>'] = false,
			['<C-d>'] = false,
		  },
		},
	},
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>fo', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer]' })

-- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>ft', "<cmd>TodoTelescope<CR>", { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>t', require("neogit").open, { desc = "Open Neogit" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = { 'lua', 'python', 'help', 'vim' },

	highlight = { enable = true },
	indent = { enable = true, disable = {} },
	incremental_selection = {
		enable = false,
		keymaps = {
			-- init_selection = '<c-space>',
			-- node_incremental = '<c-space>',
			-- scope_incremental = '<c-s>',
			-- node_decremental = '<c-backspace>',
		},
	},
	textobjects = {
		select = {
			enable = false,
			lookahead = false, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
			-- You can use the capture groups defined in textobjects.scm
				-- ['aa'] = '@parameter.outer',
				-- ['ia'] = '@parameter.inner',
				-- ['af'] = '@function.outer',
				-- ['if'] = '@function.inner',
				-- ['ac'] = '@class.outer',
				-- ['ic'] = '@class.inner',
			},
		},
		move = {
			enable = false,
			set_jumps = false, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']m'] = '@function.outer',
				[']]'] = '@class.outer',
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']['] = '@class.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[['] = '@class.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[]'] = '@class.outer',
			},
		},
		swap = {
			enable = false,
			swap_next = {
				['<leader>a'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>A'] = '@parameter.inner',
			},
		},
	},
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--	This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end
		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, '[W]orkspace [L]ist Folders'
	)

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
		end, { desc = 'Format current buffer with LSP' }
	)
end

-- Enable the following language servers
--	Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--	Add any additional override configuration in the following tables. They will be passed to
--	the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},

	-- Install these as well
	-- tsserver = {},
	-- ruff_lsp = {},
	lua_ls = {
		Lua = {
		  workspace = { checkThirdParty = true },
		  telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		}
	end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}

function Love.RunAndCheckLua(ext, mode)
	if ext == "py" then
		vim.cmd("!python3 build.py -b -r " .. (mode or ""))
	else
		local a = vim.fn.expand("%:p:h:t")
		local b = vim.fn.expand("%:t:r")
		local filename = string.format("%s/%s.lua", a, b)
		vim.cmd("!sh build.sh run && sh build.sh check vim " .. filename)
	end
end

function Love.SetLove()
	if vim.loop.fs_stat("build.sh") then
		map("n", "<space>rl", function() Love.RunAndCheckLua() end, opts)
		map("n", "<space>rp", "<cmd>!sh build.sh profile<CR>", opts)
	elseif vim.loop.fs_stat("build.py") then
		map("n", "<space>rl", function() Love.RunAndCheckLua("py", "-d") end, opts)
		map("n", "<space>rp", function() Love.RunAndCheckLua("py", "-p") end, opts)
		map("n", "<space>rb", function() Love.RunAndCheckLua("py", "-d -p") end, opts)
	else
		map("n", "<space>rl", "<cmd>!love . &&<CR>", opts)
	end
end

function Love.SetLua2p()
	-- vim.bo.syntax = "lua"
	vim.cmd[[set syntax=lua]]
	vim.bo.commentstring = "--%s"
	vim.cmd[[syn match luaFunc "self"]]
	vim.cmd[[syn match luaOperator "\:"]]
	vim.cmd[[syn match luaOperator "\."]]
	vim.cmd[[syn match luaOperator "\["]]
	vim.cmd[[syn match luaOperator "\]"]]
	vim.cmd[[syn match luaOperator "("]]
	vim.cmd[[syn match luaOperator ")"]]
	vim.cmd[[syn match luaOperator ","]]
	vim.cmd[[syn match luaOperator "+"]]
	vim.cmd[[syn match luaOperator "-"]]
	vim.cmd[[syn match luaOperator "="]]
	vim.cmd[[syn match luaConstant "\$\<\w*\>"]]
	vim.cmd[[syn match luaComment "!"]]
	vim.cmd[[syn match luaComment "@"]]
	vim.cmd[[syn match luaStatement "love.[a-z]*.[a-zA-Z]*"]]
	-- vim.cmd([[set filetype=lua]])
	Love.SetLove()
end
