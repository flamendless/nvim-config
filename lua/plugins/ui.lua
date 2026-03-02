return {
	"lewis6991/gitsigns.nvim",
	"nvim-lualine/lualine.nvim",
	"lukas-reineke/indent-blankline.nvim",
	"numToStr/Comment.nvim",
	"tpope/vim-sleuth",
	"gpanders/editorconfig.nvim",
	"f-person/git-blame.nvim",
	"backdround/neowords.nvim",
	"jdhao/whitespace.nvim",
	"luisiacc/gruvbox-baby",
	"p00f/alabaster.nvim",
	"norcalli/nvim-colorizer.lua",
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
					auto_unfold = {
						hovered = true,
					},
				},
			})
		end,
	},
	{
		"yamatsum/nvim-cursorline",
		config = function()
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
				},
			}
		end,
	},
	"nvim-tree/nvim-web-devicons",
	{
		"romgrk/barbar.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("bufferline").setup({
				animation = false,
				tabpages = false,
				clickable = false,
			})
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
