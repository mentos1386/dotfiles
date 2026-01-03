-- Markdown
require("render-markdown").setup({
	file_types = {
		"markdown",
	},
})

-- Colors the code
require("nvim-treesitter").setup({
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
require("twilight").setup()

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
