return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "<C-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Search files" },
			{ "<space>gg", "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') })<cr>", desc = "Grep word under cursor" },
			{ "<space>gr", "<cmd>lua require('telescope.builtin').resume()<cr>", desc = "Resume last picker" },
			{ "<leader>fo", "<cmd>lua require('telescope.builtin').oldfiles()<cr>", desc = "[?] Find recently opened files" },
			{ "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", desc = "[ ] Find existing buffers" },
			{
				"<leader>/",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ winblend = 10, previewer = false }))
				end,
				desc = "[/] Fuzzily search in current buffer",
			},
			{ "<leader>fw", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "[S]earch by [G]rep" },
			{ "<leader>fd", "<cmd>lua require('telescope.builtin').diagnostics()<cr>", desc = "[S]earch [D]iagnostics" },
			{ "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "[F]ind [T]odos" },
		},
		config = function()
			require("telescope").setup({
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
			})
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "media_files")
		end,
	},
	"nvim-telescope/telescope-media-files.nvim",
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = vim.fn.executable("make") == 1,
	},
}
