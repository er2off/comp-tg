require 'tg-api'

return function(C)
	print 'Client initialization...'
	C.api = new 'TGClient' {
		token = C.config.token,
	}
	C.api:addArg(C)
	C.config.token = nil

	C.api:login(function()
		print('Logged on as @'.. C.api.info.username)
	end)

	C:load 'cmds'
	C:load 'events'
end
