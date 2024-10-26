return {
	private = true,
	run = function(C, msg)
		local cat, sub, arg = unpack(C.api.parseArgs(msg.text))

		if not (cat and sub)
		then return C.api:reply(msg, '/reload cmds ping')
		end

		local path = '../'.. cat ..'/'.. sub

		C.api:off(package.loaded[path])
		package.loaded[path] = nil

		if arg == '-off'
		then C.api:reply(msg, 'Turned off')
		else
			local succ, m = xpcall(require, debug.traceback, path)
			if not succ
			then return C.api:reply(msg, 'Reload failed. '.. m)
			end
			if cat == 'events'
			then C.api:on(sub, m)
			elseif cat == 'cmds'
			then C.cmds[sub] = m
			else m(C)
			end
			C.api:reply(msg, 'Reloaded. '.. tostring(m))
		end
	end,
}
