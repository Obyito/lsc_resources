description 'ESX brinks'

version '0.7'

dependencies {
  "mysql-async",
  "esx_datastore",
  "esx_society",
  "esx_billing",
  "esx_phone",
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'config.lua',
  'client/esx_brinks_cl.lua',
}

server_scripts {
  "@mysql-async/lib/MySQL.lua",
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'config.lua',
  'server/esx_brinks_sv.lua',
}