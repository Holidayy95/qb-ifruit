fx_version 'cerulean'
game 'gta5'

description 'qb-ifruit'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@qb-core/shared/locale.lua',
    'locale/en.lua', -- replace with desired language
    'config.lua'
}

client_script {
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua',
    'client/doors.lua'
}
server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/doors.lua'
}

lua54 'yes'
