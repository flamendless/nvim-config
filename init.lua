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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Shim deprecated vim.tbl_islist so plugins using it don't warn (use vim.islist)
if vim.islist then
	vim.tbl_islist = vim.islist
end

require("lazy").setup("plugins")

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

-- Defer plugin-dependent setup so Lazy has loaded plugins first
vim.schedule(function()
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
-- See `:help mapleader` (leader is set above, before Lazy loads)

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

vim.filetype.add({
	extension = {
		templ = "templ",
		lua2p = function() Love.SetLua2p() end,
	}
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = "*.kage",
	command = "set filetype=go",
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


-- local win32yank = "/mnt/c/Users/user/Documents/win32yank/win32yank.exe"
-- vim.g.clipboard = {
-- 	name = "win3yank-wsl",
-- 	copy = {
-- 		["+"] = win32yank .. " -i --crlf",
-- 		["*"] = win32yank .. " -i --crlf"
-- 	},
-- 	paste = {
-- 		["+"] = win32yank .. " -o --crlf",
-- 		["*"] = win32yank .. " -o --crlf"
-- 	},
-- 	cache_enable = 0,
-- }


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

-- Enable Comment.nvim
require("Comment").setup()

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
require("telescope").load_extension("media_files")

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

vim.keymap.set("n", "<leader>t", require("neogit").open, { desc = "Open Neogit" })
vim.keymap.set("n", "<leader>qt", function() require("qf").toggle("c", true) end, { desc = "" })
vim.keymap.set("n", "<leader>qb", function() require("qf").above("c") end, { desc = "" })
vim.keymap.set("n", "<leader>qn", function() require("qf").below("c") end, { desc = "" })

-- [[ Configure Treesitter ]] (deferred so Lazy can load the plugin first)
require("lazy").load({ plugins = { "nvim-treesitter" } })
vim.defer_fn(function()
	local ok, configs = pcall(require, "nvim-treesitter.configs")
	if ok and configs then
		configs.setup {
			-- Parsers in this list are auto-installed when missing (run :TSInstall to install manually)
			ensure_installed = {
				"lua",
				"python",
				"vim",
				"go",
				"proto",
				"templ",
				"typescript",
				"tsx",
				"javascript",
				"jsdoc",
				"html",
				"css",
				"json",
				"jsonc",
				"bash",
				"markdown",
				"markdown_inline",
				"regex",
				"yaml",
				"toml",
			},
			highlight = { enable = true },
			indent = { enable = true, disable = {} },
			incremental_selection = {
				enable = false,
				keymaps = {},
			},
			textobjects = {
				select = {
					enable = false,
					lookahead = false,
					keymaps = {},
				},
				move = {
					enable = false,
					set_jumps = false,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = false,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		}
	end
end, 100)

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
			desc = "LSP: " .. desc
		end
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("<leader>lgd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("<leader>lgr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("<leader>lgi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	-- nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	-- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	-- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	-- nmap('<leader>wl', function()
	-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- 	end, '[W]orkspace [L]ist Folders'
	-- )

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(
		bufnr,
		"Format",
		function(_) vim.lsp.buf.format() end,
		{ desc = "Format current buffer with LSP" }
	)
	nmap("<leader>lf", ":Format<CR>", "")

	vim.diagnostic.config({
		virtual_text = true,
		virtual_lines = false,
		float = false,
	})
end

-- Enable the following language servers
--	Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--	Add any additional override configuration in the following tables. They will be passed to
--	the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	gopls = {
		hints = {
			assignVariableTypes = true,
			compositeLiteralFields = true,
			constantValues = true,
			functionTypeParameters = true,
			parameterNames = true,
			rangeVariableTypes = true
		}
	},
	templ = {},
	lua_ls = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
		settings = {
			Lua = {
				workspace = { checkThirdParty = true },
				telemetry = { enable = false },
			},
		},
	},
	pyright = {
		settings = {
			pyright = {
				disableOrganizeImports = true,
			},
			python = {
				analysis = {
					ignore = { "*" },
				}
			}
		}
	},
	ts_ls = {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},
	eslint = {},
}

--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.lsp.config("*", {
	on_attach = on_attach,
	capabilities = capabilities,
})

require("mason").setup()
local mason_lspconfig = require "mason-lspconfig"
mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
	automatic_enable = false,
}

for server_name, server_config in pairs(servers) do
	vim.lsp.config(server_name, {
		capabilities = capabilities,
		on_attach = on_attach,
		settings = server_config.settings,
	})
	vim.lsp.enable(server_name)
end

-- Setup neovim lua configuration
require("neodev").setup()

-- Turn on lsp status information
require("fidget").setup({})

-- nvim-cmp setup
local cmp = require "cmp"
local luasnip = require "luasnip"

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
}

local ft = require("Comment.ft")
ft.set("templ", ft.get("html"))

function Love.SetLua2p()
	-- vim.bo.syntax = "lua"
	vim.cmd [[set syntax=lua]]
	vim.bo.commentstring = "--%s"
	vim.cmd [[syn match luaFunc "self"]]
	vim.cmd [[syn match luaOperator "\:"]]
	vim.cmd [[syn match luaOperator "\."]]
	vim.cmd [[syn match luaOperator "\["]]
	vim.cmd [[syn match luaOperator "\]"]]
	vim.cmd [[syn match luaOperator "("]]
	vim.cmd [[syn match luaOperator ")"]]
	vim.cmd [[syn match luaOperator ","]]
	vim.cmd [[syn match luaOperator "+"]]
	vim.cmd [[syn match luaOperator "-"]]
	vim.cmd [[syn match luaOperator "="]]
	vim.cmd [[syn match luaConstant "\$\<\w*\>"]]
	vim.cmd [[syn match luaComment "!"]]
	vim.cmd [[syn match luaComment "@"]]
	vim.cmd [[syn match luaStatement "love.[a-z]*.[a-zA-Z]*"]]
	-- vim.cmd([[set filetype=lua]])
end
end)
