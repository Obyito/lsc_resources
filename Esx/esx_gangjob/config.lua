Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = false -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale = 'fr'

Config.GangStations = {

  Gang = {

    Blip = {
--      Pos     = { x = 425.130, y = -979.558, z = 30.711 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_SWITCHBLADE',     price = 2500 },
      { name = 'WEAPON_MOLOTOV',       price = 8000 },
      { name = 'WEAPON_PISTOL50',        price = 15000},
      { name = 'WEAPON_STUNGUN',      price = 6000 },
	  { name = 'WEAPON_DOUBLEACTION',        price = 50000 },
      { name = 'WEAPON_DBSHOTGUN',          price = 100000},
      { name = 'WEAPON_MICROSMG',         price = 30000 },
      { name = 'WEAPON_COMPACTRIFLE',     price = 85000 },
    },

	  AuthorizedVehicles = {
		  { name = 'schafter5',  label = 'Véhicule Civil' },
		  { name = 'Akuma',    label = 'Moto' },
		  { name = 'Granger',   label = '4X4' },
		  { name = 'mule3',      label = 'Camion de Transport' },
	  },

    Cloakrooms = {
      --{ x = 144.57633972168, y = -2203.7377929688, z = 3.6880254745483},
    },

    Armories = {
      { x = 1400.6208496094, y = 1159.5941162109, z = 114.33364868164},
    },

    Vehicles = {
      {
        Spawner    = { x = 1400.5882568359, y = 1127.9512939453, z = 114.33448791504 },
        SpawnPoint = { x = 1395.3980712891, y = 1117.4404296875, z = 114.83769226074 },
        Heading    = 315.699890,
      }
    },

    Helicopters = {
      {
        Spawner    = { x = 113.30500793457, y = -3109.3337402344, z = 5.0060696601868 },
        SpawnPoint = { x = 112.94457244873, y = -3102.5942382813, z = 5.0050659179688 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = 1414.5119628906, y = 1116.5119628906, z = 114.83792114258 },
      
    },

    BossActions = {
      { x = 1397.5802001953, y = 1164.1193847656, z = 114.33358001709 },
    },

  },

}
