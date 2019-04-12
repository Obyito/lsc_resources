Config                            = {}
Config.DrawDistance               = 600.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale = 'fr'

Config.ArmyStations = {

  ARMY = {

    Blip = {
      Pos     = { x = -2307.806, y = 3390.877, z = 30.989 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
  	Colour  = 81,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_NIGHTSTICK',       price = 2000 },
      { name = 'WEAPON_COMBATPISTOL',     price = 30000 },
      { name = 'WEAPON_ASSAULTSMG',       price = 12500 },
      { name = 'WEAPON_ASSAULTRIFLE',     price = 15000},
      { name = 'WEAPON_PUMPSHOTGUN',      price = 60000 },
      { name = 'WEAPON_STUNGUN',          price = 50000 },
      { name = 'WEAPON_FLASHLIGHT',       price = 800 },
      { name = 'WEAPON_FIREEXTINGUISHER', price = 12000 },
      { name = 'WEAPON_FLAREGUN',         price = 60000 },
      { name = 'WEAPON_STICKYBOMB',       price = 25000 },
      { name = 'WEAPON_KNIFE',            price = 2000 },
      { name = 'WEAPON_CROWBAR',          price = 3000 },
      { name = 'WEAPON_PISTOL',           price = 12500 },
      { name = 'WEAPON_PISTOL50',         price = 15000 },
      { name = 'WEAPON_MG',               price = 60000 },
      { name = 'WEAPON_STINGER',          price = 12000 },
      { name = 'WEAPON_BULLPUPRIFLE',     price = 60000 },
      { name = 'WEAPON_HEAVYSHOTGUN',     price = 25000 },
      { name = 'WEAPON_HEAVYSNIPER',      price = 250000 },
      { name = 'WEAPON_MARKSMANRIFLE',    price = 200000 },
      { name = 'WEAPON_AUTOSHOTGUN',      price = 125000 },
      { name = 'WEAPON_ASSAULTRIFLE',     price = 150000 },
      { name = 'WEAPON_REMOTESNIPER',     price = 150000 },
      { name = 'GADGET_PARACHUTE',        price = 3000 },
    },

	AuthorizedVehicles = {
		{name = 'apc' , label = 'Transport blindé Tout-Terrain'},
		{name = 'barracks', label = 'Convoi'},
		{name = 'barracks2', label = 'Convoi sans remorque'},
		{name = 'crusader', label = 'Transport de Troupes'},
		{name = 'rhino', label = 'Tank'},
		{name = 'hauler2', label = 'Transport'},
		{name = 'phantom2', label = 'Transport'},
		{name = 'insurgent', label = 'Véhicule de combat blindé Tout-Terrain'},
		{name = 'insurgent2', label = 'Véhicule de transport blindé Tout-Terrain'},
		{name = 'insurgent3', label = 'Véhicule de combat blindé Tout-Terrain'},
		{name = 'savage', label = 'Hélicoptère de combat lourd'},
		{name = 'buzzard', label = 'Hélicoptère de combat'},
		{name = 'annihilator', label = 'Hélicoptère de combat mitrailleur'},
		{name = 'cargobob', label = 'Transport Aérien'},
	},

    Cloakrooms = {
      { x = -2390.397, y = 3287.108, z = 31.977 },
    },

    Armories = {
      { x = -2386.211, y = 3297.569, z = 31.977 },
    },

    Vehicles = {
      {
        Spawner    = { x = -2413.983, y = 3313.745, z = 31.830 },
        SpawnPoint = { x = -2402.755, y = 3309.140, z = 31.830 },
        Heading    = 90.0,
      }
    },

    Helicopters = {
      {
        Spawner    = { x = -2399.345, y = 3273.080, z = 31.977 },
        SpawnPoint = { x = -2019.129, y = 2865.339, z = 31.906 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = -2413.352, y = 3334.117, z = 31.828 },
      { x = -2416.548, y = 3328.347, z = 31.828 },
      { x = -2413.052, y = 3287.123, z = 32.830 },
    },

    BossActions = {
      { x = -2380.654, y = 3320.855, z = 32.044 }
    },

  },

}
