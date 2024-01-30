-- Configure theme
require("rose-pine").setup({
	variant = "auto", -- auto, main, moon, or dawn
	dark_variant = "moon", -- main, moon, or dawn
	dim_inactive_windows = false,
	extend_background_behind_borders = true,

	enable = {
		terminal = true,
	},

	styles = {
		bold = true,
		italic = true,
		transparency = false,
	},
})
vim.cmd("colorscheme rose-pine")
vim.o.background = "light"

local debounce = function(ms, fn)
	local running = false
	return function()
		if running then
			return
		end
		vim.defer_fn(function()
			running = false
		end, ms)
		running = true
		vim.schedule(fn)
	end
end

-- Create a job to detect current gnome color scheme and set background
local Job = require("plenary.job")
local set_background = function()
	local j = Job:new({ command = "gsettings", args = { "get", "org.gnome.desktop.interface", "color-scheme" } })
	j:sync()
	if j:result()[1] == "'default'" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
end

-- Call imidiatly to set initially
set_background()

-- Listen for SIGUSR1 signal to update background
local group = vim.api.nvim_create_augroup("BackgroundWatch", { clear = true })
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = debounce(500, set_background),
	group = group,
})
