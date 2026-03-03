return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = function()
			pcall(require("nvim-treesitter.install").update, { with_sync = true })
		end,
		config = function()
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if not ok or not configs then
				return
			end
			configs.setup({
				ensure_installed = {
					"lua", "python", "vim", "go", "proto", "templ",
					"typescript", "tsx", "javascript", "jsdoc",
					"html", "css", "json", "jsonc", "bash",
					"markdown", "markdown_inline", "regex", "yaml", "toml",
				},
				highlight = { enable = true },
				indent = { enable = true, disable = {} },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aC"] = "@call.outer",
							["iC"] = "@call.inner",
							["ap"] = "@parameter.outer",
							["ip"] = "@parameter.inner",
							["as"] = "@statement.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
						goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
						goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
						goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
					},
					swap = {
						enable = true,
						swap_next = { ["<leader>a"] = "@parameter.inner" },
						swap_previous = { ["<leader>A"] = "@parameter.inner" },
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			-- Set plugin config and register keymaps (main treesitter doesn't forward to this plugin).
			local ok_config, textobjects_config = pcall(require, "nvim-treesitter-textobjects.config")
			if ok_config and textobjects_config then
				textobjects_config.update({
					select = {
						lookahead = true,
						include_surrounding_whitespace = false,
					},
					move = { set_jumps = true },
				})
			end
			local ok_select, select_api = pcall(require, "nvim-treesitter-textobjects.select")
			if ok_select and select_api then
				local query_group = "textobjects"
				local function set_select(key, query)
					vim.keymap.set({ "x", "o" }, key, function()
						select_api.select_textobject(query, query_group)
					end, { desc = "Select: " .. query })
				end
				set_select("af", "@function.outer")
				set_select("if", "@function.inner")
				set_select("ac", "@class.outer")
				set_select("ic", "@class.inner")
				set_select("aC", "@call.outer")
				set_select("iC", "@call.inner")
				set_select("ap", "@parameter.outer")
				set_select("ip", "@parameter.inner")
				set_select("as", "@statement.outer")
			end
			-- Move keymaps: next/prev function via move API (works in Go, Lua, etc.)
			local ok_move, move_api = pcall(require, "nvim-treesitter-textobjects.move")
			if ok_move and move_api then
				local query_group = "textobjects"
				vim.keymap.set("n", "<leader>gn", function()
					move_api.goto_next_start("@function.outer", query_group)
				end, { desc = "Next function" })
				vim.keymap.set("n", "<leader>gp", function()
					move_api.goto_previous_start("@function.outer", query_group)
				end, { desc = "Previous function" })
			end
		end,
	},
}
