fx_version 'cerulean'
game 'gta5'

author 'um & tgiann & kersroot'
version '2.0.0'

ui_page 'html/index.html'

files {
    'html/index.html'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'locales/*.lua',
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'locales/*.lua',
    'server/server.lua',
    'server/webhooks.lua'
}

dependencies {
    'oxmysql'
}

lua54 'yes'