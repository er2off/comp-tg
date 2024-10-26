--- Eval environment
local env = {
	assert = assert,
	error = error,
	ipairs = ipairs,
	pairs = pairs,
	next = next,
	tonumber = tonumber,
	tostring = tostring,
	type = type,
	pcall = pcall,
	xpcall = xpcall,
	--debug = debug,
	math = math,
	string = string,
	table = table,
	dump = dump,
}

--- Print alternative for eval
local function prind(...)
	local s = ''
	for _, v in pairs {...} do
		if #s > 0 then
			-- transform tab to spaces, looks like cringe but why not
			--s = s.. (' '):rep(8 - (#s % 8))
			s = s.. '\t'
		end
		s = s.. tostring(v) or 'nil'
	end
	return s.. '\n'
end

return {
	private = true,
	run = function(C, msg, isOwner)
		local out = {'```'}
		local t = {
			msg = msg,
			print = function(...)
				table.insert(out, prind(...))
			end,
			C = isOwner and C,
			api = isOwner and C.api,
		}
		for k, v in pairs(env)
		do t[k] = v
		end

		local e, err = load(msg.text, 'eval', 'bt', t)
		xpcall(function()
			if err
			then error(err)
			end
			e = tostring(e() or '<... nothing ...>')
		end, function(err)
			e = err
		end)
		table.insert(out, '\n'.. e)
		table.insert(out, '\n```')
		C.api:reply(msg, table.concat(out), {
			parseMode = 'MarkdownV2',
		})
	end
}

