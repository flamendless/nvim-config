return {
	-- Gitsigns: signs + setup
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
			})
		end,
	},
	-- Lualine
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
					component_separators = "|",
					section_separators = "",
				},
			})
		end,
	},
	-- Indent blankline
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			local highlight = { "CursorColumn", "Whitespace" }
			require("ibl").setup({
				indent = { highlight = highlight, char = "┊" },
				whitespace = {
					highlight = highlight,
					remove_blankline_trail = true,
				},
				scope = {
					highlight = { "Function", "Label" },
					enabled = true,
				},
			})
		end,
	},
	-- Comment.nvim + templ commentstring
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
			local ft = require("Comment.ft")
			ft.set("templ", ft.get("html"))
		end,
	},
	"tpope/vim-sleuth",
	"gpanders/editorconfig.nvim",
	"f-person/git-blame.nvim",
	-- Neowords: load on VeryLazy and set w/e/b/ge keymaps
	{
		"backdround/neowords.nvim",
		event = "VeryLazy",
		config = function()
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
		end,
	},
	"jdhao/whitespace.nvim",
	"luisiacc/gruvbox-baby",
	"p00f/alabaster.nvim",
	-- Colorizer
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"m4xshen/autoclose.nvim",
		config = function()
			require("autoclose").setup({})
		end,
	},
	{
		"hedyhli/outline.nvim",
		config = function()
			vim.keymap.set("n", "<leader>a", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
			require("outline").setup({
				symbol_folding = {
					autofold_depth = 1,
					auto_unfold = { hovered = true },
				},
			})
		end,
	},
	{
		"yamatsum/nvim-cursorline",
		config = function()
			require("nvim-cursorline").setup({
				cursorline = { enable = false, timeout = 1000, number = false },
				cursorword = { enable = true, min_length = 3, hl = { underline = true } },
			})
		end,
	},
	"nvim-tree/nvim-web-devicons",
	-- Barbar: load at startup so tabline shows with a single buffer
	{
		"romgrk/barbar.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			animation = false,
			tabpages = false,
			clickable = false,
		},
		config = function(_, opts)
			require("barbar").setup(opts)
			vim.keymap.set("n", "<space>b", "<cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
			vim.keymap.set("n", "<space>n", "<cmd>BufferNext<CR>", { desc = "Next buffer" })
			vim.keymap.set("n", "<space>x", "<cmd>BufferClose<CR>", { desc = "Close buffer" })
		end,
	},
	{
		"m-demare/hlargs.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("hlargs").setup()
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup()
		end,
	},
}
