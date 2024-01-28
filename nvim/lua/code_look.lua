-- Colors the code
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"python",
		"bash",
		"dockerfile",
		"go",
		"graphql",
		"hcl",
		"terraform",
		"javascript",
		"json",
		"make",
		"markdown",
		"prisma",
		"proto",
		"rust",
		"typescript",
		"vim",
		"yaml",
		"glsl",
		"glimmer",
		"jsonc",
		"lua",
		"blueprint",
	},
	-- Install languages synchronously (only applied to `ensure_installed`)
	sync_install = false,
	highlight = {
		-- `false` will disable the whole extension
		enable = true,
		-- list of language that will be disabled
		disable = { "" },
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
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
