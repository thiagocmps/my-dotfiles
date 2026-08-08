local M = {}

local session_dir = vim.fn.stdpath("state") .. "/sessions"

local function slug()
	local cwd = vim.fn.getcwd()
	return (cwd:gsub("/", "-"):gsub("^%-", ""):gsub("[^%w%-]", "-"))
end

function M.session_file()
	vim.fn.mkdir(session_dir, "p")
	return session_dir .. "/" .. slug() .. ".vim"
end

function M.save()
	local has_files = false
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		local name = vim.api.nvim_buf_get_name(bufnr)
		if name ~= "" and vim.api.nvim_buf_get_option(bufnr, "buftype") == "" then
			has_files = true
			break
		end
	end
	if not has_files then
		return
	end
	pcall(vim.cmd, "mksession! " .. vim.fn.fnameescape(M.session_file()))
end

function M.restore_current()
	local path = M.session_file()
	if vim.fn.filereadable(path) == 1 then
		pcall(vim.cmd, "source " .. vim.fn.fnameescape(path))
		vim.notify("Sessão restaurada: " .. slug(), vim.log.levels.INFO)
	else
		vim.notify("Nenhuma sessão salva para este diretório", vim.log.levels.WARN)
	end
end

function M.restore_file(path)
	pcall(vim.cmd, "source " .. vim.fn.fnameescape(path))
end

function M.list_recent(limit)
	limit = limit or 6
	local entries = {}
	if vim.fn.isdirectory(session_dir) == 0 then
		return entries
	end
	for name in vim.fs.dir(session_dir) do
		if name:match("%.vim$") then
			local path = session_dir .. "/" .. name
			local stat = vim.uv.fs_stat(path)
			table.insert(entries, {
				name = name:gsub("%.vim$", ""),
				path = path,
				mtime = stat and (stat.mtime.sec + stat.mtime.nsec / 1e9) or 0,
			})
		end
	end
	table.sort(entries, function(a, b)
		return a.mtime > b.mtime
	end)
	if #entries > limit then
		for i = limit + 1, #entries do
			entries[i] = nil
		end
	end
	return entries
end

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = vim.api.nvim_create_augroup("UserSessions", { clear = true }),
	callback = M.save,
})

return M
