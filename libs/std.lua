-- Standard Library in bot

local function await(fn)
	return coroutine.wrap(fn)()
end
local function acall(fn, ...)
	return coroutine.wrap(fn)(...)
end
_G.await = await
_G.acall = acall

--- Get value of inverted value-key table.
-- @tparam table t Table where need get index.
-- @tparam any val Value to be found.
-- @treturn any Value of needed key.
function table.indexOf(t, val)
	local i = {}
	for k, v in pairs(t)
	do i[v] = k
	end
	return i[val]
end

--- Return index if value matches.
-- @tparam table t Table to search in.
-- @tparam any val Value to be found.
-- @treturn any Key of found element.
function table.find(t, val)
	for k, v in pairs(t) do
		if v == val
		then return k
		end
	end
end

--- Return value in table matching value table.
-- @tparam table t Table to search in.
-- @tparam table val Table value to search matches.
-- @treturn any Found value.
function table.findV(t, val)
	local b
	for _, v in pairs(t) do
		for k, x in pairs(val) do
			if x ~= v[k] then
				b = 1
				break
			end
		end
		if b
		then b = nil
		else return v
		end
	end
end

--- Escape reserved regex values.
-- @tparam string s String.
-- @treturn string Filtered string.
function string.escp(s)
	return s:gsub('[%^%$%%%(%)%.%[%]%*%+%-%?]', '%%%0')
end
