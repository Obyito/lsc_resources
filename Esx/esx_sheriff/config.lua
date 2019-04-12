Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = true -- only turn this on if you are using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 20 * 60000 -- 10 mins

Config.MaxInService               = -1
Config.Locale = 'fr'

Config.PoliceStations = {

	DKSP = {

		Blip = {
			Pos     = { x = 1851.81, y = 3690.65, z = 34.267 },
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 60,
		},

		-- https://wiki.fivem.net/wiki/Weapons
		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK',       price = 250 },
			{ name = 'WEAPON_COMBATPISTOL',     price = 1500 },
			{ name = 'WEAPON_PUMPSHOTGUN',      price = 10000 },
			{ name = 'WEAPON_SMG',              price = 12000 },
			{ name = 'WEAPON_CARBINERIFLE',     price = 15000},
			{ name = 'WEAPON_ADVANCEDRIFLE',    price = 15000 },
			{ name = 'WEAPON_STICKYBOMB',       price = 25000 },
			{ name = 'WEAPON_STUNGUN',          price = 1200 },
			{ name = 'WEAPON_FLASHLIGHT',       price = 20 },
			{ name = 'WEAPON_FIREEXTINGUISHER', price = 20 },
			{ name = 'WEAPON_FLAREGUN',         price = 20 },
		},

		Cloakrooms = {
			{ x = 1857.0776, y = 3689.1477, z = 33.2670 },
		},

		Armories = {
			{ x = 1827.4526, y = 3674.0349, z = -119.7615 },
		},

		Vehicles = {
			{
				Spawner    = { x = 1860.0919, y = 3680.8056, z = 32.7401 },
				SpawnPoint = { x = 1867.7656, y = 3699.0434, z = 32.5043 },
				Heading    = 210.0,
			},
		},

		Helicopters = {
			{
				Spawner    = { x = 1838.6384, y = 3673.0874, z = 38.2205 },
				SpawnPoint = { x = 1834.4521, y = 3680.9506, z = 39.4104, },
				Heading    = 210.0,
			},
		},

		VehicleDeleters = {
			{ x = 1855.4907, y = 3713.0529, z = 32.2709 },
		},

		BossActions = {
			{ x = 1842.9237, y = 3674.9060, z = -119.7615 },
		},

	},

}

-- https://wiki.fivem.net/wiki/Vehicles
Config.AuthorizedVehicles = {
	Shared = {
	},

	recruit = {
		{
			model = 'sheriff',
			label = 'Sheriff Cruiser'
		},
		{
			model = 'sheriff2',
			label = 'Sheriff 4x4'
		},
	},

	officer = {
	    	{
			model = 'sheriff',
			label = 'Sheriff Cruiser'
		},
		{
			model = 'sheriff2',
			label = 'Sheriff 4x4'
		},
	},

	sergeant = {
		{
			model = 'sheriff',
			label = 'Sheriff Cruiser'
		},
		{
			model = 'sheriff2',
			label = 'Sheriff 4x4'
		},
		{
		  	model = 'policet',
			label = 'Armored Transport Unit',
		},
	},

	lieutenant = {
		{
			model = 'sheriff',
			label = 'Sheriff Cruiser'
		},
		{
			model = 'sheriff2',
			label = 'Sheriff 4x4'
		},
		{
		  	model = 'policet',
			label = 'Armored Transport Unit',
		},
	},

	boss = {
		{
			model = 'sheriff',
			label = 'Sheriff Cruiser'
		},
		{
			model = 'sheriff2',
			label = 'Sheriff 4x4'
		},
		{
		  	model = 'policet',
			label = 'Armored Transport Unit',
		},
		{
		  	model = 'riot',
			label = 'SWAT Transport Unit',
		},

	},
}
-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	cadet_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 46,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	sheriff_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	sergeant_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 1,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	lieutenant_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 2,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	commandant_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 11,  ['bproof_2'] = 1
		},
		female = {
			['bproof_1'] = 13,  ['bproof_2'] = 1
		}
	},
	gilet_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}

}
