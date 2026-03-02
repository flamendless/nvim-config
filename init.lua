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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set termguicolors before any plugin loads (required by colorschemes / UI)
vim.o.termguicolors = true

if vim.islist then
	vim.tbl_islist = vim.islist
end

require("lazy").setup("plugins")

-- [[ Options ]]
vim.o.hlsearch = true
vim.wo.number = true
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 200
vim.wo.signcolumn = "yes"

-- [[ Clipboard: system clipboard for yank/paste (macOS, Linux, WSL) ]]
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

-- [[ Colorscheme ]]
vim.cmd [[colorscheme gruvbox-baby]]

vim.o.completeopt = "menuone,noselect"
vim.o.relativenumber = true
vim.o.expandtab = false
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.wrap = true
vim.o.list = true
vim.opt.listchars:append("eol:↴")
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("tab:⍿·")

-- [[ Filetypes (templ, lua2p, kage) ]]
require("filetypes")

-- [[ Core keymaps (no plugin dependency) ]]
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
map("n", "<C-a>", "ggVG", opts)
map("v", "<leader>y", "\"*y", opts)
