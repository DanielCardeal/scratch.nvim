local openers = require("scratch.openers")

local AUGROUP = vim.api.nvim_create_augroup("scratch", {})

local M = {
	opts = {
		filepath = vim.fn.stdpath("data") .. "/scratch.txt",
		opener = openers.float,
	},
	openers = openers,
	api = {},
}

local _get_scratch_buf = (function()
	local bufnr = nil

	return function()
		if bufnr ~= nil then
			return bufnr
		end

		if M.opts.filepath ~= nil then
			for _, b in pairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_get_name(b) == M.opts.filepath then
					bufnr = b
				end
			end
			bufnr = bufnr or vim.api.nvim_create_buf(false, true)

			vim.api.nvim_buf_call(bufnr, function()
				vim.cmd("edit " .. M.opts.filepath)
			end)
		else
			bufnr = vim.api.nvim_create_buf(false, true)
		end

		vim.api.nvim_create_autocmd({ "BufDelete", "BufHidden", "BufLeave", "WinLeave" }, {
			group = AUGROUP,
			buffer = bufnr,
			command = "silent w",
		})

		return bufnr
	end
end)()

function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

	vim.api.nvim_create_user_command("ScratchOpen", M.api.open, {})
	vim.api.nvim_create_user_command("ScratchClose", M.api.close, {})
	vim.api.nvim_create_user_command("ScratchToggle", M.api.toggle, {})
end

function M.api.toggle()
	local bufnr = _get_scratch_buf()

	local wins = vim.api.nvim_list_wins()
	if vim.api.nvim_get_current_buf() == bufnr then
		if #wins > 1 then
			vim.api.nvim_win_close(0, false)
		end
		return
	end

	for _, win in pairs(wins) do
		if vim.api.nvim_win_get_buf(win) == bufnr then
			vim.api.nvim_set_current_win(win)
			return
		end
	end

	M.opts.opener(bufnr)
end

function M.api.open()
	local bufnr = _get_scratch_buf()

	if vim.api.nvim_get_current_buf() == bufnr then
		return
	end

	local wins = vim.api.nvim_list_wins()
	for _, win in pairs(wins) do
		if vim.api.nvim_win_get_buf(win) == bufnr then
			vim.api.nvim_set_current_win(win)
			return
		end
	end

	M.opts.opener(bufnr)
end

function M.api.close()
	local bufnr = _get_scratch_buf()

	local wins = vim.api.nvim_list_wins()
	if #wins == 1 then
		return
	end

	for _, win in pairs(wins) do
		if vim.api.nvim_win_get_buf(win) == bufnr then
			vim.api.nvim_win_close(win, false)
		end
	end
end

return M
