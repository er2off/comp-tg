local uv = require 'uv'

local isWinda = os.getenv 'OS' == 'Windows_NT'
return {
	private = true,
	run = function(C, msg)
		local args = C.api.parseArgs(msg.text)
		local cmd
		-- run in powershell as some commands don't work
		if isWinda
		then cmd = 'powershell'
		else cmd = args[1]
			table.remove(args, 1)
		end
		if not cmd or (isWinda and not args[1])
		then return C.api:reply(msg, 'write smth')
		end

		local out = {'```'}

		local function readData(err, data)
			assert(not err, err)
			if data then
				data = data
					:gsub('\r', '')
					:gsub('%s*$', '')
					:gsub('[\\`]', '\\%0')
				table.insert(out, data)
			end
		end
		local stdout, stderr = uv.new_pipe(), uv.new_pipe()
		uv.spawn(cmd, {
			args = args,
			stdio = {nil, stdout, stderr},
			hide = true,
		}, function(code, signal)
			if code ~= 0
			then table.insert(out, '-- exit code: '.. code ..' --')
			end
			if signal ~= 0
			then table.insert(out, '-- signal: '.. signal ..' --')
			end
			if #out == 1
			then table.insert(out, '<... nothing ...>')
			end
			table.insert(out, '```')
			acall(C.api.reply, C.api, msg, table.concat(out, '\n'), {
				parseMode = 'MarkdownV2',
			})
		end)
		uv.read_start(stdout, readData)
		uv.read_start(stderr, readData)
	end,
}
