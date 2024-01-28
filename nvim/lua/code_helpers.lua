-- Copilot provider
require("copilot").setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
	filetypes = {
		javascript = true,
		typescript = true,
		rust = true,
	},
})
require("copilot_cmp").setup()

-- Codeium provider
require("codeium").setup({})

-- Git providers
require("cmp_git").setup()

local cmp = require("cmp")
local lspkind = require("lspkind")
lspkind.init({
	symbol_map = { Copilot = "", Codeium = "" },
})
vim.opt.completeopt = "menu,menuone,noselect"
cmp.setup({
	formatting = {
		fields = { "abbr", "kind" },
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = function()
				return math.min(40, math.floor(vim.o.columns * 0.4))
			end,
			ellipsis_char = "...",
			before = function(entry, item)
				item.menu = ""
				return item
			end,
		}),
	},
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			local col = vim.fn.col(".") - 1

			if cmp.visible() then
				cmp.select_next_item(select_opts)
			elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
				fallback()
			else
				cmp.complete()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "copilot" },
		{ name = "codeium" },
		{ name = "nvim_lsp" },
		{ name = "git" },
		-- { name = 'vsnip' }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = "buffer" },
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- LSP
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
require("mason-lspconfig").setup({
	ensure_installed = {
		"typos_lsp", -- all
		"angularls", -- angular
		"ansiblels", -- ansible
		"bashls", -- bash
		"bufls", -- buf
		"cssls", -- css
		"denols", -- deno
		"dockerls", -- docker
		"docker_compose_language_service", -- docker-compose
		"eslint", -- eslint
		"elixirls", -- elixir
		"golangci_lint_ls", -- golangci-lint
		"gopls", -- gopls
		"graphql", -- graphql
		"html", -- html
		"htmx", -- htmx
		"helm_ls", -- helm
		"jsonls", -- json
		"tsserver", -- javascript/typescript
		"marksman", -- markdown
		"vale_ls", -- markdown/prose
		"swift_mesonls", -- meson
		"prismals", -- prisma
		"pyright", -- python
		"rust_analyzer", -- rust
		"taplo", -- toml
		"terraformls", -- terraform
		"tflint", -- terraform
		"yamlls", -- yaml
	},
	automatic_installation = true,
})

require("mason-lspconfig").setup_handlers({
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})
	end,
})

-- Formatter
local util = require("formatter.util")
require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		javascript = {
			require("formatter.filetypes.javascript").prettier,
		},
		typescript = {
			require("formatter.filetypes.typescript").prettier,
		},
		json = {
			require("formatter.filetypes.json").prettier,
		},
		graphql = {
			require("formatter.filetypes.graphql").prettier,
		},
		rust = {
			require("formatter.filetypes.rust").rustfmt,
		},
		go = {
			require("formatter.filetypes.go").gofmt,
		},
		python = {
			require("formatter.filetypes.python").black,
		},
		elixir = {
			require("formatter.filetypes.elixir").mix_format,
		},
		sh = {
			require("formatter.filetypes.sh").shfmt,
		},
		proto = {
			require("formatter.filetypes.proto").buf_format,
		},

		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})

require("trouble").setup({})
