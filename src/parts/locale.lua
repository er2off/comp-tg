local json = require 'json'

class 'Locale' {
	main = 'en',

	__newindex = function() end,
	__static = function(this)
		local list = bundle.readdir 'src/locales'
		this.list = {}
		for i = 1, #list do
			local n = list[i]:sub(0, -6)
			local f = bundle.readfile('src/locales/'.. n ..'.json')
			this[n] = json.decode(f)
			this.list[i] = n
		end
	end,

	function(this, C)
		C.locale = this
	end,

	get = function(this, category, key, lang)
		assert(category, 'Category not provided')
		assert(key, 'Key not provided')
		lang = lang or this.main
		local v = (this[lang] or {})[category]
		if not v
		then return this[this.main][category][key] or ''
		else return v[key] or ''
		end
	end,
}

return new 'Locale'
