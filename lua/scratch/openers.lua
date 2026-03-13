local AUGROUP = vim.api.nvim_create_augroup("scratch", { clear = false })

local M = {}

function M.float(bufnr)
	local ui = vim.api.nvim_list_uis()[1]

	local width = math.floor(0.8 * ui.width)
	local height = math.floor(0.8 * ui.height)
	local col = math.floor((ui.width - width) / 2)
	local row = math.floor((ui.height - height) / 2)

	vim.api.nvim_open_win(bufnr, true, {
		title = "[SCRATCH]",
		title_pos = "center",
		border = "rounded",
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
	})

	vim.api.nvim_create_autocmd("WinLeave", {
		group = AUGROUP,
		buffer = bufnr,
		command = "silent q",
	})
end

function M.vsplit(bufnr)
	vim.notify("TODO", vim.log.levels.ERROR)
end

function M.split(bufnr)
	vim.notify("TODO", vim.log.levels.ERROR)
end

return M
