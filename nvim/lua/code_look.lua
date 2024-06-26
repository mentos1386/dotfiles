-- Colors the code
require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	ignore_install = { "yaml" }, -- Issues with libstdc++6 and nix.
	-- Install languages synchronously (only applied to `ensure_installed`)
	sync_install = false,
	highlight = {
		enable = true,
		disable = { "yaml" }, -- Issues with libstdc++6 and nix.
	},
	indent = {
		-- dont enable this, messes up python indentation
		enable = false,
		disable = {},
	},
})

-- Only colorizes the function/class/codeblock that the cursor is in
require("peepsight").setup({
	-- typescript
	"arrow_function",
	"function_declaration",
	"generator_function_declaration",
	"method_definition",
})
require("peepsight").enable()

-- Transforms hex colors to their respective color
require("colorizer").setup()

-- Git blame line
require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 500,
		virt_text_pos = "eol",
	},
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "-" },
		topdelete = { text = "-" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
})
