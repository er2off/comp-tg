return function(api, C, msg)
	local lang = msg.from.language_code
	local isOwner = msg.from.id == C.config.owner

	local cmd = C.cmds[msg.cmd]
	msg.l = lang

	if not cmd
	then return api:send(msg, C.locale:get('error', 'inv_cmd', lang))

	elseif type(cmd.run) ~= 'function'
	then return api:send(msg, C.locale:get('error', 'cmd_run', lang))

	elseif cmd.private and not isOwner
	then return api:send(msg, C.locale:get('error', 'adm_cmd', lang))
	end

	msg.loc = C.locale:get('cmds', msg.cmd, lang)
	local succ, err = xpcall(cmd.run, debug.traceback, C, msg, isOwner)
	if not succ then
		print(err)
		api:forward(msg, C.config.owner)
		api:send(C.config.owner, err)
		api:reply(msg, C.locale:get('error', 'not_suc', lang))
	end
end
