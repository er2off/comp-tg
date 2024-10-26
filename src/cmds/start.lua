return {
	hide = true,
	run = function(C, msg)
		C.api:reply(msg, msg.loc.msg:format 'https://github.com/er2off/comp-tg')
	end,
}
