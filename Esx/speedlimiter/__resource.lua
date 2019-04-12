-- https://wiki.fivem.net/wiki/Resource_manifest

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'An series of scripts'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'config.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/npc_drop-client.lua',
	'client/speed_limit-client.lua',
	
}
