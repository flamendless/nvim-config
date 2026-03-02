-- INFO: (flam) this is minimal, suited for servers
-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local Love = {}

-- Lazy requires these to be set before it loads
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Minimal plugin set for server use (Option B: inline spec list)
require("lazy").setup({
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			pcall(require("nvim-treesitter.install").update { with_sync = true })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	"nvim-lualine/lualine.nvim",
	"lukas-reineke/indent-blankline.nvim",
	"tpope/vim-sleuth",
	"gpanders/editorconfig.nvim",
	"f-person/git-blame.nvim",
	"backdround/neowords.nvim",
	"jdhao/whitespace.nvim",
	"luisiacc/gruvbox-baby",
	"norcalli/nvim-colorizer.lua",
	{
		"m-demare/hlargs.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("hlargs").setup()
		end,
	},
	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({
				delete_to_trash = true,
				view_options = {
					show_hidden = true,
					natural_order = "fast",
					case_insensitive = false,
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = vim.fn.executable("make") == 1,
	},
})

-- [[ Setting options ]]
-- See `:help vim.o`

vim.o.hlsearch = true
vim.wo.number = true
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 200
vim.wo.signcolumn = "yes"

-- Use system clipboard for yank/paste (macOS, Linux, WSL)
vim.opt.clipboard = "unnamedplus"
if vim.fn.has("wsl") == 1 then
	local win32yank = vim.fn.exepath("win32yank.exe")
	if win32yank and win32yank ~= "" then
		vim.g.clipboard = {
			name = "win32yank-wsl",
			copy = {
				["+"] = win32yank .. " -i --crlf",
				["*"] = win32yank .. " -i --crlf",
			},
			paste = {
				["+"] = win32yank .. " -o --crlf",
				["*"] = win32yank .. " -o --crlf",
			},
			cache_enabled = true,
		}
	end
end

vim.o.termguicolors = true
vim.cmd [[colorscheme gruvbox-baby]]
require("colorizer").setup()

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
-- Leader is set above, before Lazy loads

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
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
map("n", "<C-p>", function()
	require("telescope.builtin").find_files()
end, { desc = "Search files" })
map("n", "<space>gg", "<cmd>lua require('telescope.builtin').grep_string({search = vim.fn.expand('<cword>')})<cr>", {})
map("n", "<space>gr", "<cmd>lua require('telescope.builtin').resume()<cr>", {})
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

require("telescope").setup {
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
}
pcall(require("telescope").load_extension, "fzf")

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
