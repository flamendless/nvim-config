return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"sindrets/diffview.nvim",
		},
		keys = {
			{ "<leader>t", "<cmd>lua require('neogit').open()<cr>", desc = "Open Neogit" },
		},
		config = function()
			require("neogit").setup({})
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
}
