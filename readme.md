# Computer bot

This is a bot for Telegram.
It haven't got much possibilities
but this code can be used in other bots.

Bot can use locale of Telegram client (unlike much bots)
and use it or fallback to English.

# Installation

You need to have [luvi](https://github.com/luvit/luvi) and [lit](https://github.com/luvit/lit)
(both are part of luvit).

Then, run
```sh
$ lit install
$ env TOKEN=changeme OWNER=changeme luvi .
```

If you want to build self-contained image, run
```sh
$ lit make # can add . comp-tg /path/to/luvi there
$ env ... ./comp-tg
```
