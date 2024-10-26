local http = require 'coro-http'
local json = require 'json'

class 'Rub' {
	url = 'https://www.cbr-xml-daily.ru/daily_json.js',
	pat = '%d %s (%s) - %.4f ₽ (%s)',

	getPat = function(this, val)
		local diff = val.Value - val.Previous
		return this.pat:format(val.Nominal, val.Name, val.CharCode, val.Value, (diff >= 0 and '+' or '').. ('%.1f'):format(diff))
	end,

	course = function(this, wants)
		local hdr, res = http.request('GET', this.url)
		if hdr.code ~= 200
		then return 'err'
		end
		res = json.decode(res)

		-- Pseudo-valutes
		res.Valute['RUB'] = {
			ID = 'R01000',
			NumCode = '001',
			CharCode = 'RUB',
			Nominal = 1,
			Name = 'Российский рубль',
			Value = 1,
			Previous = 1,
		}
		local uah = res.Valute['UAH']
		assert(uah, 'No UAH found')
		res.Valute['SHT'] = {
			ID = 'R02000',
			NumCode = '200',
			CharCode = 'SHT',
			Nominal = 1,
			Name = 'Штаны',
			Value = uah.Value / uah.Nominal * 40, -- 40 UAH
			Previous = uah.Previous / uah.Nominal * 40, -- 40 UAH
		}

		local date
		do local y, m, d = res.Date:match('(%d+)%-(%d+)%-(%d+)')
			date = ('%d.%d.%d'):format(d, m, y)
		end

		local r, founds = {}, {}
		if table.find(wants, 'ALL') then
			for _, v in pairs(res.Valute)
			do table.insert(r, this:getPat(v))
			end
			return r, date, wants -- string, date, found
		end

		for k, v in pairs(res.Valute) do
			if table.find(wants, k) then
				table.insert(founds, v.CharCode)
				table.insert(r, this:getPat(v))
			end
		end
		return r, date, founds
	end,
}

local rub = new 'Rub' ()

return {
	run = function(C, msg)
		local wants = {
			'USD',
			'EUR',
			unpack(C.api.parseArgs(msg.text))
		}
		for i = 1, #wants
		do wants[i] = wants[i]:upper()
		end
		local v, d, f = rub:course(wants)
		if v == 'err'
		then return C.api:reply(msg, C.locale:get('error', 'req_err', msg.l))
		end
		local nf = {}
		for _, i in pairs(wants) do
			if not table.find(f, i)
			then table.insert(nf, i)
			end
		end
		local s = msg.loc.cur:format(d, table.concat(v, '\n'))
		if #nf > 0
		then s = s .. msg.loc.notf .. table.concat(nf, ',')
		end
		C.api:reply(msg, s .. msg.loc.prov)
	end
}
