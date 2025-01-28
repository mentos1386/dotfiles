-- Plugins
local Plug = vim.fn["plug#"]

vim.call("plug#begin")

-- Dependencies by multiple plugins
Plug("nvim-lua/plenary.nvim")
-- General
Plug("ojroques/nvim-osc52")
-- Look
Plug('f-person/auto-dark-mode.nvim')
Plug("rose-pine/neovim", { as = "rose-pine", tag = "v3.*" })
Plug("nvim-lualine/lualine.nvim")
Plug("Yggdroot/indentLine")
Plug("koenverburg/peepsight.nvim")
Plug("norcalli/nvim-colorizer.lua")
Plug("j-hui/fidget.nvim")
-- Git
Plug("lewis6991/gitsigns.nvim")
Plug("NeogitOrg/neogit")
Plug("sindrets/diffview.nvim")
-- Search/Files
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("ANGkeith/telescope-terraform-doc.nvim")
Plug("FeiyouG/commander.nvim")
-- Ignore/Edit files
Plug("vim-scripts/gitignore")
-- Languages
Plug("NoahTheDuke/vim-just")
-- Coding helpers
Plug("zbirenbaum/copilot.lua")
Plug("zbirenbaum/copilot-cmp")
Plug("Exafunction/codeium.nvim")
Plug("petertriho/cmp-git")
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = vim.fn[":TSUpdate"] })
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
Plug("neovim/nvim-lspconfig")
Plug("mhartington/formatter.nvim")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/nvim-cmp")
Plug("onsails/lspkind.nvim")
Plug("folke/trouble.nvim")
Plug("hrsh7th/vim-vsnip")
Plug("hrsh7th/vim-vsnip-integ")
-- Kawaii
Plug("giusgad/pets.nvim")
Plug("giusgad/hologram.nvim")
Plug("MunifTanjim/nui.nvim")
vim.call("plug#end")

-- TMUX/Clipboard fixes
vim.opt.termguicolors = true
require("osc52").setup({
	silent = false,
	tmux_passthrough = true,
})
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
function copy()
	if vim.v.event.operator == "y" and vim.v.event.regname == "" then
		require("osc52").copy_register("+")
	end
	if vim.v.event.operator == "d" and vim.v.event.regname == "" then
		require("osc52").copy_register("+")
	end
end
vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })

-- Misc
vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function()
		vim.opt.filetype = jsonc
	end,
})

-- VIM Configuration
vim.opt.encoding = "UTF-8"
vim.opt.autoread = true -- will re-read opened file if changed externally
vim.opt.autowrite = true
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Use spaces (2) instead of tabs
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.incsearch = true -- search as you type
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"
--vim.opt.spell spelllang=en_us
vim.opt.updatetime = 300
vim.opt.cmdheight = 1
vim.opt.hidden = true
--vim.opt.shortmess = vim.opt.shortmess .. 'c'

-- Custom configurations
require("code_helpers")
require("code_look")
require("kawaii")

-- Fidget
require("fidget").setup({
	notification = {
		override_vim_notify = true,
	},
})

-- Telescope Configuration
require("telescope").setup({
	defaults = {
		layout_strategy = "vertical",
	},
	extensions = {
		terraform_doc = {
			url_open_command = "xdg-open",
			latest_provider_symbol = "  ",
			wincmd = "botright new",
			wrap = "nowrap",
		},
	},
})
require("telescope").load_extension("terraform_doc")

-- Keybindings
-- Using SPACE as <leader> key
vim.keymap.set("n", "<SPACE>", "<Nop>")
vim.g.mapleader = " "
require("keybindings")

-- Visuals
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.hlsearch = true -- highlight all results
vim.opt.signcolumn = "number" -- always show git diff column

-- Theme configuration
require("theme")

require("lualine").setup({
	options = {
		theme = "rose-pine",
		section_separators = { "", "" },
		component_separators = { "", "" },
		icons_enabled = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "diagnostics", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
