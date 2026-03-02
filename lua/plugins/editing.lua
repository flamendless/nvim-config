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
		keys = {
			{ "<leader>qt", "<cmd>lua require('qf').toggle('c', true)<cr>", desc = "Toggle quickfix" },
			{ "<leader>qb", "<cmd>lua require('qf').above('c')<cr>", desc = "Quickfix above" },
			{ "<leader>qn", "<cmd>lua require('qf').below('c')<cr>", desc = "Quickfix below" },
		},
		config = function()
			require("qf").setup({})
		end,
	},
}
