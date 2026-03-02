return {
	{
		"kosayoda/nvim-lightbulb",
		config = function()
			require("nvim-lightbulb").setup({
				autocmd = { enabled = true },
			})
		end,
	},
	{
		"hinell/lsp-timeout.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			vim.g["lspTimeoutConfig"] = {
				stopTimeout = 1000 * 60 * 5,
				startTimeout = 1000 * 10,
				silent = false,
				filetypes = {
					ignore = { "lua" },
				},
			}
		end,
	},
}
