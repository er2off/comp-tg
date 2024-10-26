return {
	name = 'er2/comp-tg',
	version = '2.0.0',
	private = true,
	license = 'Zlib',
	author = {
		name = 'Er2',
		email = 'er2@dismail.de',
	},
	dependencies = {
		'creationix/coro-http@v3.2.3',
		'er2off/dump@v1.0.0',
		'er2off/tg-api@v0.1.0',
		'luvit/json@v2.5.2',
	},
	files = {
		'**.lua',
		'src/locales/*.json',
		'deps/secure-socket/root_ca.dat',
	}
}
