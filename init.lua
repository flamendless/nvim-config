-- Install packer
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
	vim.cmd [[packadd packer.nvim]]
end

require("packer").startup(function(use)
	-- Package manager
	use "wbthomason/packer.nvim"

	use { -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		requires = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
			"folke/neodev.nvim",
		},
	}

	use {
		"hrsh7th/nvim-cmp",
		requires = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
	}

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
	use "numToStr/Comment.nvim"            -- "gc" to comment visual regions/lines
	use "tpope/vim-sleuth"                 -- Detect tabstop and shiftwidth automatically
	use "gpanders/editorconfig.nvim"
	use "f-person/git-blame.nvim"
	use "backdround/neowords.nvim" -- allow camelCase and snake_case movement
	use "jdhao/whitespace.nvim"
	use "luisiacc/gruvbox-baby"
	use "p00f/alabaster.nvim"
	use "norcalli/nvim-colorizer.lua"

	use "m4xshen/autoclose.nvim"
	require("autoclose").setup({})

	use({
		"hedyhli/outline.nvim",
		config = function()
			vim.keymap.set("n", "<leader>a", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

			require("outline").setup({
				symbol_folding = {
					autofold_depth = 1,
					auto_unfold = {
						hovered = true,
					},
				},
			})
		end,
	})

	use "yamatsum/nvim-cursorline"
	require("nvim-cursorline").setup {
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

	use "nvim-tree/nvim-web-devicons"
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

	use({
		"Bekaboo/dropbar.nvim",
		requires = {
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make"
		},
		config = function()
			-- local dropbar_api = require("dropbar.api")
		end
	})

	use "tikhomirov/vim-glsl"

	use {
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
	}

	use({
		"Wansmer/treesj",
		requires = { "nvim-treesitter" },
		config = function()
			require("treesj").setup({})
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

	use({
		"ten3roberts/qf.nvim",
		config = function() require("qf").setup({}) end
	})

	use({ "stevearc/oil.nvim" })
	require("oil").setup({
		delete_to_trash = true,
		view_options = {
			show_hidden = true,
			natural_order = "fast",
			case_insensitive = false,
		},
	})

	use { "kosayoda/nvim-lightbulb" }
	require("nvim-lightbulb").setup({
		autocmd = { enabled = true }
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
	use { "nvim-telescope/telescope-media-files.nvim" }

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	use { "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable "make" == 1 }


	use "mfussenegger/nvim-dap"
	use "leoluz/nvim-dap-go"
	require("dap-go").setup()
	use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } }
	require("dapui").setup()

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
-- vim.cmd [[colorscheme gruvbox-baby]]
vim.cmd [[colorscheme alabaster]]
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

vim.filetype.add({
	extension = {
		templ = "templ",
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

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup {
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = { "lua", "python", "vim", "go", "proto", "templ" },

	highlight = { enable = true },
	indent = { enable = true, disable = {} },
	incremental_selection = {
		enable = false,
		keymaps = {
		},
	},
	textobjects = {
		select = {
			enable = false,
			lookahead = false, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
			},
		},
		move = {
			enable = false,
			set_jumps = false, -- whether to set jumps in the jumplist
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

	nmap("<leader>dd", ":DapNew<CR>", "")
	nmap("<leader>db", ":lua require('dap').toggle_breakpoint()<CR>", "")
	nmap("<leader>dc", ":lua require('dap').continue()<CR>", "")
	nmap("<leader>ds", ":lua require'dap'.step_over()<CR>", "")
	nmap("<leader>dq", ":lua require'dap'.terminate()<CR>", "")
	nmap("<leader>dq", ":lua require'dap'.terminate()<CR>", "")
	nmap("<leader>dt", ":lua require('dap-go').debug_test()<CR>", "")
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
		Lua = {
			workspace = { checkThirdParty = true },
			telemetry = { enable = false },
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
}

vim.lsp.config("*", {
	on_attach = on_attach,
	capabilities = capabilities,
})
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("mason").setup()
local mason_lspconfig = require "mason-lspconfig"
mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
	automatic_enable = false,
}

for server_name, _ in pairs(servers) do
	vim.lsp.config(server_name, {
		capabilities = capabilities,
		on_attach = on_attach,
	})
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

local trim_spaces = true
vim.keymap.set("v", "<space>s", function()
	require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
end)

local ft = require("Comment.ft")
ft.set("templ", ft.get("html"))

local dap, dapui = require("dap"), require("dapui")
dap.set_log_level("TRACE")
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
