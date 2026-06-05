local M = {}

local FLOAT_WIDTH_PCT = 0.8
local FLOAT_HEIGHT_PCT = 0.8

local function get_float_win_config()
	local ui = vim.api.nvim_list_uis()[1]
	local cfg = {}
	cfg.title = "[SCRATCH]"
	cfg.title_pos = "center"
	cfg.border = "rounded"
	cfg.width = math.floor(FLOAT_WIDTH_PCT * ui.width)
	cfg.height = math.floor(FLOAT_HEIGHT_PCT * ui.height)
	cfg.relative = "editor"
	cfg.col = math.floor((ui.width - cfg.width) / 2)
	cfg.row = math.floor((ui.height - cfg.height) / 2)
	return cfg
end

function M.float(bufnr)
	local win = vim.api.nvim_open_win(bufnr, true, get_float_win_config())

	-- Auto closes float window when focusing on a non-float
	vim.api.nvim_create_autocmd("WinEnter", {
		group = vim.api.nvim_create_augroup("scratch:float-close", { clear = true }),
		buf = bufnr,
		callback = function()
			local w = vim.api.nvim_get_current_win()
			if vim.api.nvim_win_get_config(w).relative == "" then
				if vim.tbl_contains(vim.api.nvim_list_wins(), win) then
					vim.api.nvim_win_close(win, true)
				end
			end
		end,
	})

	-- Auto resize window on terminal resize
	vim.api.nvim_create_autocmd("VimResized", {
		group = vim.api.nvim_create_augroup("scratch:float-resize", { clear = true }),
		buf = bufnr,
		callback = function()
			local w = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_config(w, get_float_win_config())
		end,
	})
end

function M.vsplit(bufnr)
	vim.api.nvim_open_win(bufnr, true, {
		split = "right",
		win = -1,
	})
end

function M.split(bufnr)
	vim.api.nvim_open_win(bufnr, true, {
		split = "below",
		win = -1,
		height = 10,
	})
end

return M
