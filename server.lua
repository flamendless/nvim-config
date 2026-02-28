-- INFO: (flam) this is minimal, suited for servers
-- Install packer
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
	vim.cmd [[packadd packer.nvim]]
end

local Love = {}

require("packer").startup(function(use)
	-- Package manager
	use "wbthomason/packer.nvim"

	use {
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update { with_sync = true })
		end,
	}

	use {
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	}

	use "lewis6991/gitsigns.nvim"
	use "nvim-lualine/lualine.nvim"        -- Fancier statusline
	use "lukas-reineke/indent-blankline.nvim" -- Add indentation guides even on blank lines
	use "tpope/vim-sleuth"                 -- Detect tabstop and shiftwidth automatically
	use "gpanders/editorconfig.nvim"
	use "f-person/git-blame.nvim"
	use "backdround/neowords.nvim" -- allow camelCase and snake_case movement
	use "jdhao/whitespace.nvim"
	use "luisiacc/gruvbox-baby"
	use "norcalli/nvim-colorizer.lua"

	use { "romgrk/barbar.nvim", wants = "nvim-web-devicons" }
	require("bufferline").setup({
		animation = false,
		tabpages = false,
		clickable = false,
	})

	use {
		"m-demare/hlargs.nvim",
		requires = { "nvim-treesitter/nvim-treesitter" }
	}
	require("hlargs").setup()

	use {
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup()
		end
	}

	use({ "stevearc/oil.nvim" })
	require("oil").setup({
		delete_to_trash = true,
		view_options = {
			show_hidden = true,
			natural_order = "fast",
			case_insensitive = false,
		},
	})

	use({
		"hinell/lsp-timeout.nvim",
		requires = { "neovim/nvim-lspconfig" },
		setup = function()
			vim.g["lspTimeoutConfig"] = {
				stopTimeout = 1000 * 60 * 5,
				startTimeout = 1000 * 10,
				silent = false,
				filetypes = {
					ignore = { "lua" },
				}
			}
		end
	})

	-- Fuzzy Finder (files, lsp, etc)
	use { "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { "nvim-lua/plenary.nvim" } }

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	use { "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable "make" == 1 }


	-- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
	local has_plugins, plugins = pcall(require, "custom.plugins")
	if has_plugins then
		plugins(use)
	end

	if is_bootstrap then
		require("packer").sync()
	end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
	print "=================================="
	print "	 Plugins are being installed"
	print "	 Wait until Packer completes,"
	print "		then restart nvim"
	print "=================================="
	return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | silent! LspStop | silent! LspStart | PackerCompile",
	group = packer_group,
	pattern = vim.fn.expand "$MYVIMRC",
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 200
vim.wo.signcolumn = "yes"

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme gruvbox-baby]]
-- vim.cmd [[colorscheme alabaster]]
require("colorizer").setup()

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.o.relativenumber = true
vim.o.expandtab = false
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.wrap = true
vim.o.list = true
vim.opt.listchars:append "eol:↴"
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "tab:⍿·"

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--	NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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
map("n", "<space>gg", "<cmd>lua require(\'telescope.builtin\').grep_string({search = vim.fn.expand('<cword>')})<cr>", {})
map("n", "<space>gr", "<cmd>lua require(\'telescope.builtin\').resume()<cr>", {})
map("n", "<C-a>", "ggVG", opts)
map("v", "<leader>y", "\"*y", opts)


local neowords = require("neowords")
local p = neowords.pattern_presets

local hops = neowords.get_word_hops(
	p.snake_case,
	p.camel_case,
	p.upper_case,
	p.number,
	p.hex_color,
	"\\v\\.+",
	"\\v,+"
)

vim.keymap.set({ "n", "x", "o" }, "w", hops.forward_start)
vim.keymap.set({ "n", "x", "o" }, "e", hops.forward_end)
vim.keymap.set({ "n", "x", "o" }, "b", hops.backward_start)
vim.keymap.set({ "n", "x", "o" }, "ge", hops.backward_end)

-- Set lualine as statusline
-- See `:help lualine.txt`
require("lualine").setup {
	options = {
		icons_enabled = false,
		theme = "auto",
		component_separators = "|",
		section_separators = "",
	},
}

local highlight = { "CursorColumn", "Whitespace" }

require("ibl").setup({
	indent = {
		highlight = highlight,
		char = "┊",
	},
	whitespace = {
		highlight = highlight,
		remove_blankline_trail = true,
	},
	scope = {
		highlight = { "Function", "Label" },
		enabled = true,
	},
})

-- Gitsigns
-- See `:help gitsigns.txt`
require("gitsigns").setup {
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup {
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
	extensions = {
		media_files = {
			filetypes = { "png", "webp", "jpg", "jpeg" },
			find_cmd = "rg",
		},
	},
}

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>fw", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "[S]earch [D]iagnostics" })
