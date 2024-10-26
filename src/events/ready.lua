local function addCmd(C, lang, t, k, cmd)
	if not (cmd.private or cmd.hide) then
		local cmd = C.locale:get('cmds', k, lang or {})
		table.insert(t, {
			command = k,
			description = (cmd.args and cmd.args .. ' - ' or '')
			.. (cmd.desc or C.locale:get('cmds', 'not_des'))
		})
	end
end

return function(api, C)
	-- Register commands for given locales
	for _, lang in pairs(C.locale.list) do
		local t = {}
		for k, v in pairs(C.cmds)
		do addCmd(C, lang, t, k, v)
		end
		api:setMyCommands(t, lang)
	end
end
