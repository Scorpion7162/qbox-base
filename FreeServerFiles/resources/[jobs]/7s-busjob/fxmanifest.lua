fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name '7s-busjob'
author 'Scorpion & Seven'
description 'Custom Busjob script!'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts{
    'server/*.lua'
} 
