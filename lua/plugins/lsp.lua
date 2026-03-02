local servers = {
	gopls = {
		hints = {
			assignVariableTypes = true,
			compositeLiteralFields = true,
			constantValues = true,
			functionTypeParameters = true,
			parameterNames = true,
			rangeVariableTypes = true,
		},
	},
	templ = {},
	lua_ls = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
		settings = {
			Lua = {
				workspace = { checkThirdParty = true },
				telemetry = { enable = false },
			},
		},
	},
	pyright = {
		settings = {
			pyright = { disableOrganizeImports = true },
			python = { analysis = { ignore = { "*" } } },
		},
	},
	ts_ls = {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},
	eslint = {},
}

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
			"folke/neodev.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local on_attach = function(_, bufnr)
				local nmap = function(keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				nmap("<leader>lgd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				nmap("<leader>lgr", function()
					require("telescope.builtin").lsp_references()
				end, "[G]oto [R]eferences")
				nmap("<leader>lgi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				nmap("K", vim.lsp.buf.hover, "Hover Documentation")
				nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

				vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
					vim.lsp.buf.format()
				end, { desc = "Format current buffer with LSP" })
				nmap("<leader>lf", ":Format<CR>", "Format")

				vim.diagnostic.config({
					virtual_text = true,
					virtual_lines = false,
					float = false,
				})
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			vim.lsp.config("*", {
				on_attach = on_attach,
				capabilities = capabilities,
			})

			require("mason").setup()
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_enable = false,
			})

			for server_name, server_config in pairs(servers) do
				local opts = {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = server_config.settings,
				}
				for k, v in pairs(server_config) do
					if k ~= "settings" and opts[k] == nil then
						opts[k] = v
					end
				end
				vim.lsp.config(server_name, opts)
				vim.lsp.enable(server_name)
			end

			require("neodev").setup()
			require("fidget").setup({})
		end,
	},
}
