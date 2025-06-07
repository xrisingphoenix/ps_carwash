fx_version 'adamant'

games { 'gta5' }

script_author 'Phoenix Studios'
description 'Carwash Script (Prop Placement an Animation -> from ixhal)'

lua54 'yes'

shared_scripts {
	'config.lua',
	'@es_extended/imports.lua',
	'@ox_lib/init.lua'
} 

client_scripts {
	'client.lua',
}

server_scripts {
	'server.lua',
	'@oxmysql/lib/MySQL.lua',
}