require("commander").setup({
	prompt_title = "Help | Keybindings",
	components = {
		"DESC",
		"KEYS",
	},
	integration = {
		telescope = {
			enable = true,
			theme = require("telescope.themes").commander,
		},
	},
})

local lspconfig = require("lspconfig")

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
local lsp_antach_done = false
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }

		require("commander").add({
			{ desc = "Notification History", cmd = Snacks.notifier.show_history, keys = { "n", "<leader>snh", opts } },
			{ desc = "Rust Debug", cmd = "<CMD>RustLsp debug<CR>", keys = { "n", "<leader>rdbg", opts } },
			{
				desc = "LSP Quickfix",
				cmd = function()
					vim.lsp.buf.code_action({
						filter = function(a)
							return a.kind ~= "quickfix" or a.isPreferred
						end,
						apply = true,
					})
				end,
				keys = { "n", "qf", opts },
			},
			{ desc = "LSP Declaration", cmd = vim.lsp.buf.declaration, keys = { "n", "gD", opts } },
			{ desc = "LSP Definition", cmd = vim.lsp.buf.definition, keys = { "n", "gd", opts } },
			{ desc = "LSP Hover", cmd = vim.lsp.buf.hover, keys = { "n", "K", opts } },
			{ desc = "LSP Rename", cmd = vim.lsp.buf.rename, keys = { "n", "rn", opts } },
			{ desc = "LSP Implementation", cmd = vim.lsp.buf.implementation, keys = { "n", "gi", opts } },
			{ desc = "LSP Signature Help", cmd = vim.lsp.buf.signature_help, keys = { "n", "<C-k>", opts } },
			{ desc = "LSP Code Action", cmd = vim.lsp.buf.code_action, keys = { "n", "<leader>ca", opts } },
			{
				desc = "LSP Format",
				cmd = function()
					vim.lsp.buf.format({ async = true })
				end,
				keys = { "n", "<leader>f", opts },
			},
			{
				desc = "LSP Diagnostics Buffer",
				cmd = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				keys = { "n", "<leader>d" },
			},
			{
				desc = "LSP Diagnostics workspace",
				cmd = "<cmd>Trouble diagnostics toggle<cr>",
				keys = { "n", "<leader>dw" },
			},
			{ desc = "LSP References", cmd = "<CMD>Telescope lsp_references<CR>", keys = { "n", "<leader>gr" } },

			{ desc = "LSP Definitions", cmd = "<CMD>Telescope lsp_definitions<CR>", keys = { "n", "<leader>fcde" } },
			{
				desc = "LSP Document Symbols",
				cmd = "<CMD>Telescope lsp_document_symbols<CR>",
				keys = { "n", "<leader>fcds" },
			},
			{
				desc = "LSP Workspace Symbols",
				cmd = "<CMD>Telescope lsp_workspace_symbols<CR>",
				keys = { "n", "<leader>fcws" },
			},
		}, { show = not lsp_attach_done })

		lsp_attach_done = true
	end,
})

require("commander").add({
	{
		desc = "Open Help",
		cmd = require("commander").show,
		keys = { "n", "<Leader>h" },
	},
	{
		desc = "Search for files in git",
		cmd = "<CMD>Telescope git_files<CR>",
		keys = { "n", "<c-p>" },
	},
	{ desc = "Search for files", cmd = "<CMD>Telescope find_files<CR>", keys = { "n", "<leader>ff" } },
	{ desc = "Search for string", cmd = "<CMD>Telescope live_grep<CR>", keys = { "n", "<leader>fg" } },
	{ desc = "Git Commits", cmd = "<CMD>Telescope git_commits<CR>", keys = { "n", "<leader>fgc" } },
	{ desc = "Git Branches", cmd = "<CMD>Telescope git_branches<CR>", keys = { "n", "<leader>fgb" } },
	{ desc = "Git Status", cmd = "<CMD>Telescope git_status<CR>", keys = { "n", "<leader>fgs" } },
	{ desc = "Terraform Doc", cmd = "<CMD>Telescope terraform_doc<CR>", keys = { "n", "<leader>ftf" } },
	{ desc = "Terraform Modules", cmd = "<CMD>Telescope terraform_doc modules<CR>", keys = { "n", "<leader>ftm" } },
	{
		desc = "Terraform AWS",
		cmd = "<CMD>Telescope terraform_doc full_name=hashicorp/aws<CR>",
		keys = { "n", "<leader>ftfa" },
	},
	{
		desc = "Terraform Kubernetes",
		cmd = "<CMD>Telescope terraform_doc full_name=hashicorp/kubernetes<CR>",
		keys = { "n", "<leader>ftfk" },
	},
	{
		desc = "Twilight Toggle",
		cmd = function()
			require("twilight").toggle()
		end,
		keys = { "n", "<leader>tt" },
	},
})
