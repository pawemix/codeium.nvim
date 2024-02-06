local M = {}

local source = nil

function M.setup(options)
	local Source = require("codeium.source")
	local Server = require("codeium.api")
	local update = require("codeium.update")
	require("codeium.config").setup(options)

	local s = Server:new()
	update.download(function(err)
		if not err then
			Server.load_api_key()
			s.start()
		end
	end)

	vim.api.nvim_create_user_command("Codeium", function(opts)
		local args = opts.fargs
		if args[1] == "Auth" then
			Server.authenticate()
		end
	end, {
		nargs = 1,
		complete = function()
			return { "Auth" }
		end,
	})

	source = Source:new(s)
	require("cmp").register_source("codeium", source)
end

function M.enabled()
	if source == nil then return nil end
	return source:enabled()
end

function M.enable()
	if source == nil then return nil end
	return source:enable()
end

function M.disable()
	if source == nil then return nil end
	return source:disable()
end

function M.toggle()
	if source == nil then return nil end
	return source:toggle()
end

return M
