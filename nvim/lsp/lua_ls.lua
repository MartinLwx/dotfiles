-- src: https://github.com/LuaLS/vscode-lua/blob/master/setting/schema.json
return {
	cmd = "lua-language-server",
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
		},
	},
}
