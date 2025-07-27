return {
	"Olical/conjure",
	ft = { "clojure", "python" },
	lazy = true,
	init = function()
		-- Set configuration options here
		-- Uncomment this to get verbose logging to help diagnose internal Conjure issues
		-- This is VERY helpful when reporting an issue with the project
		-- vim.g["conjure#debug"] = true
		vim.g["conjure#mapping#doc_word"] = "k" -- <LocalLeader>k
	end,
}
