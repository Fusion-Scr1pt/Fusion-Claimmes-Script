fx_version 'cerulean'
game 'gta5'
author 'Fusion Scripts'
description 'Claimmes script'
version '1.0.0'

dependency 'es_extended'
dependency 'oxmysql'

shared_script 'config.lua'

server_scripts {
    '@es_extended/locale.lua',
    'server.lua'
}

escrow_ignore {
    'server.lua'
}
