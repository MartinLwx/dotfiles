return {
	"yetone/avante.nvim",
	build = function()
		-- conditionally use the correct build system for the current OS
		if vim.fn.has("win32") == 1 then
			return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		else
			return "make"
		end
	end,
	event = "VeryLazy",
	opts = {
		-- src: https://github.com/yetone/avante.nvim/issues/2127
		provider = "ollamalocal",
		providers = {
			deepseek = {
				__inherited_from = "openai",
				api_key_name = "DEEPSEEK_API_KEY",
				endpoint = "https://api.deepseek.com",
				model = "deepseek-chat",
			},
			ollamalocal = {
				__inherited_from = "openai",
				api_key_name = "",
				endpoint = "http://localhost:11434/v1",
				model = "gemma3:e2b",
				mode = "legacy",
				--disable_tools = true, -- Open-source models often do not support tools.
			},
		},
	},
}
