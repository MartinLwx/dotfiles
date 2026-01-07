return {
	"olimorris/codecompanion.nvim",
	opts = {
		display = {
			inline = {
                -- Show diff info in vertical
				layout = "vertical", -- vertical|horizontal|buffer
			},
		},
		interactions = {
			-- Chat Buffer triggered by <Leader>aa
			chat = {
				adapter = "ollama",
				variables = {
					["buffer"] = {
						opts = {
							-- Always sync the buffer by sharing its "diff"
							-- Or choose "all" to share the entire buffer
							default_params = "diff",
						},
					},
				},
			},
			-- Inline assistant by tying :Codecompanion
			inline = { adapter = "ollama" },
			-- Neovim commands
			cmd = { adapter = "ollama" },
			-- Run task in the background
			background = { adapter = "ollama" },
		},
		adapters = {
			-- A http adapter connects you to an LLM
			http = {
				-- Use .extend to customize more
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								default = "qwen3:0.6b",
							},
							num_ctx = {
								default = 20000,
							},
						},
					})
				end,
				opts = {
					-- Do not show preset adapters
					show_presets = false,
				},
			},
		},
		language = "Chinese",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
}
