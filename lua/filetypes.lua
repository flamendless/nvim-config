local Love = {}

function Love.SetLua2p()
	vim.cmd [[set syntax=lua]]
	vim.bo.commentstring = "--%s"
	vim.cmd [[syn match luaFunc "self"]]
	vim.cmd [[syn match luaOperator "\:"]]
	vim.cmd [[syn match luaOperator "\."]]
	vim.cmd [[syn match luaOperator "\["]]
	vim.cmd [[syn match luaOperator "\]"]]
	vim.cmd [[syn match luaOperator "("]]
	vim.cmd [[syn match luaOperator ")"]]
	vim.cmd [[syn match luaOperator ","]]
	vim.cmd [[syn match luaOperator "+"]]
	vim.cmd [[syn match luaOperator "-"]]
	vim.cmd [[syn match luaOperator "="]]
	vim.cmd [[syn match luaConstant "\$\<\w*\>"]]
	vim.cmd [[syn match luaComment "!"]]
	vim.cmd [[syn match luaComment "@"]]
	vim.cmd [[syn match luaStatement "love.[a-z]*.[a-zA-Z]*"]]
end

vim.filetype.add({
	extension = {
		templ = "templ",
		lua2p = function()
			Love.SetLua2p()
		end,
	},
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = "*.kage",
	command = "set filetype=go",
})

return Love
