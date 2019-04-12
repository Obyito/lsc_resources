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
Config.EnableLicenses             = true
Config.MaxInService               = -1
Config.Locale = 'fr'

Config.MafiaStations = {

  Mafia = {

    Blip = {
      Pos     = { x = 425.130, y = -979.558, z = 30.711 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

    AuthorizedWeapons = {
    {name = 'WEAPON_FIREEXTINGUISHER', price = 500},
    {name = 'WEAPON_STUNGUN',          price = 1000},
    {name = 'WEAPON_BZGAS',            price = 3000},
    {name = 'WEAPON_MOLOTOV',          price = 1500},
    {name = 'WEAPON_SMOKEGRENADE',     price = 1500},            
    {name = 'WEAPON_HEAVYPISTOL',      price = 8000},
    {name = 'WEAPON_COMBATPISTOL',     price = 10000},    
    {name = 'WEAPON_MICROSMG',         price = 12000},
    {name = 'WEAPON_SMG',              price = 16000},
    {name = 'WEAPON_CARBINERIFLE',     price = 18000},  
    {name = 'WEAPON_MG',               price = 25000},
    {name = 'WEAPON_COMPACTRIFLE',     price = 25000}, 
    {name = 'WEAPON_ASSAULTRIFLE',     price = 25000},
    {name = 'WEAPON_COMBATPDW',        price = 25000},
    {name = 'WEAPON_SPECIALCARBINE',   price = 35000},           
    {name = 'WEAPON_SAWNOFFSHOTGUN',   price = 17500},    
    {name = 'WEAPON_PUMPSHOTGUN',      price = 17500},
    {name = 'WEAPON_HEAVYSHOTGUN',     price = 25000},
    {name = 'WEAPON_MARKSMANRIFLE',    price = 30000},
    {name = 'WEAPON_SNIPERRIFLE',      price = 500000},
    {name = 'WEAPON_HEAVYSNIPER',      price = 650000},    
    {name = 'WEAPON_GUSENBERG',        price = 800000},
    {name = 'WEAPON_STICKYBOMB',       price = 100000},
    {name = 'WEAPON_PIPEBOMB',         price = 150000},
    {name = 'WEAPON_COMPACTLAUNCHER',  price = 1650000},
    {name = 'WEAPON_HOMINGLAUNCHER',   price = 3500000},
	  
    },

	  AuthorizedVehicles = {
		  { name = 'charublu',  label = 'Dodge Charger' },
		  { name = 'btype',      label = 'Roosevelt' },
		  { name = 'sandking',   label = '4X4' },
		  { name = 'mule3',      label = 'Camion de Transport' },
		  { name = 'guardian',   label = 'Grand 4x4' },
		  { name = 'burrito3',   label = 'Fourgonnette' },
		  { name = 'mesa',       label = 'Tout-Terrain' },
	  },

    Cloakrooms = {
      --{ x = 9.283, y = 528.914, z = 169.635 },
    },

    Armories = {
      { x = 1.550, y = 527.397, z = 169.617 },
    },

    Vehicles = {
      {
        Spawner    = { x = 13.40, y = 549.1, z = 175.187 },
        SpawnPoint = { x = 8.237, y = 556.963, z = 175.266 },
        Heading    = 90.0,
      }
    },
	
	Helicopters = {
      {
        Spawner    = { x = 20.312, y = 535.667, z = 173.627 },
        SpawnPoint = { x = 3.40, y = 525.56, z = 177.919 },
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      { x = 22.74, y = 545.9, z = 175.027 },
      { x = 21.35, y = 543.3, z = 175.027 },
    },

    BossActions = {
      { x = 4.113, y = 526.897, z = 173.628 }
    },

  },

}
