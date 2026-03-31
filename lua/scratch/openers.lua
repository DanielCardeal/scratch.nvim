local M = {}

function M.float(bufnr)
	local ui = vim.api.nvim_list_uis()[1]

	local width = math.floor(0.8 * ui.width)
	local height = math.floor(0.8 * ui.height)
	local col = math.floor((ui.width - width) / 2)
	local row = math.floor((ui.height - height) / 2)

	local win = vim.api.nvim_open_win(bufnr, true, {
		title = "[SCRATCH]",
		title_pos = "center",
		border = "rounded",
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
	})

	-- Auto closes float window when focusing on a non-float
	vim.api.nvim_create_autocmd("WinEnter", {
		group = vim.api.nvim_create_augroup("scratch:float-close", { clear = true }),
		callback = function()
			local w = vim.api.nvim_get_current_win()
			if vim.api.nvim_win_get_config(w).relative == "" then
				if vim.tbl_contains(vim.api.nvim_list_wins(), win) then
					vim.api.nvim_win_close(win, true)
				end
			end
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
