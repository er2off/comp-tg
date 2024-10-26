local uv = require 'uv'

class 'Core' : inherits 'EventsThis' {
	config = {
		token = uv.os_getenv 'TOKEN',
		owner = tonumber(uv.os_getenv('OWNER') or ''),
		beta = uv.os_getenv 'BETA' == '1',
	},
	cmds = {},
	stats = {
		cpu = 0,
		loaded = 0,
		cmds = 0,
		uses = 0,
	},

	function(this)
		this:super()
		uv.os_unsetenv 'TOKEN'
		if not this.config.token
		then error 'Provide env TOKEN=' end
		this.beta = this.config.beta
		if this.beta
		then print 'Running in beta mode' end
		this:load 'parts'
		print 'Done!'
	end,

	stop = function(this)
		this.api:destroy()
		print('Stopped')
		print('Uptime: '.. (os.time() - this.loaded) ..' seconds')
		os.exit(0)
	end,

	load = function(this, cat)
		local files = bundle.readdir('src/'.. cat)
		for i = 1, #files do
			local v = files[i]:sub(0, -5)
			print('Loading '.. cat:sub(0, -2) ..' ('.. i ..' / '.. #files ..') '.. v ..'...')
			-- Lint?
			local succ, res = xpcall(require, debug.traceback, '../'.. cat ..'/'.. v)
			if succ then
				if cat == 'events'
				then this.api:on(v, res)

				elseif cat == 'cmds' then
					if not this.cmds[v]
					then this.stats.cmds = this.stats.cmds + 1
					end
					this.cmds[v] = res

				elseif cat == 'parts'
				then res(this)

				else error 'wut?'
				end
			else
				print('failed')
				print(res)
			end
		end
		print('Loaded '.. #files ..' '.. cat)
		this.loaded = os.time()
	end,
}

return function(C)
	if C then return end

	math.randomseed(os.time())
	uv.disable_stdio_inheritance()

	local core = new 'Core' ()
	local signal = uv.new_signal()
	signal:start('sigint', function()
		print('\nCaught SIGINT, shutting down')
		core:stop()
	end)
	uv.run()
end
