-- Markdown
require("render-markdown").setup({
	file_types = {
		"markdown",
	},
})

-- Colors the code
require("nvim-treesitter").setup({
	highlight = {
		enable = true,
	},
	indent = {
		-- dont enable this, messes up python indentation
		enable = false,
		disable = {},
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "yaml" },
	callback = function()
		vim.treesitter.start()
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function()
		vim.opt.filetype = "jsonc"
	end,
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
