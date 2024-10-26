return {
	run = function(C, msg)
		local t = os.time()
		local sPing, sUp = t - msg.date, t - C.loaded
		local mUp = sUp / 60
		local hUp = mUp / 60
		local dUp = hUp / 24
		C.api:send(msg, msg.loc.pat:format(sPing, dUp, hUp, mUp, sUp))
	end,
}
