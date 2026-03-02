return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master", -- use master; main removed ft_to_lang and breaks telescope preview + syntax
		build = function()
			pcall(require("nvim-treesitter.install").update { with_sync = true })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
