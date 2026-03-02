return {
	{
		"Bekaboo/dropbar.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			-- local dropbar_api = require("dropbar.api")
		end,
	},
	"tikhomirov/vim-glsl",
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({})
		end,
	},
	{
		"ten3roberts/qf.nvim",
		config = function()
			require("qf").setup({})
		end,
	},
}
