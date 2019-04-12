Config.Jobs.reporter = {

	BlipInfos = {
		Sprite = 184,
		Color = 1
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "rumpo",
			Trailer = "none",
			HasCaution = true
		}

	},

	Zones = {

		VehicleSpawner = {
			Pos = {x = -1075.3194580078, y = -253.41345214844, z = 37.763282775879},
			Size = {x = 2.0, y = 2.0, z = 0.2},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("reporter_name"),
			Type = "vehspawner",
			Spawner = 1,
			Hint = _U("reporter_garage"),
			Caution = 0		},

		VehicleSpawnPoint = {
			Pos = {x = -1051.7182617188, y = -249.69282531738, z = 37.858947753906},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U("service_vh"),
			Type = "vehspawnpt",
			Spawner = 1,
			Heading = 200.1
		},

		VehicleDeletePoint = {
			Pos = {x = -1051.7182617188, y = -249.69282531738, z = 37.858947753906},
			Size = {x = 5.0, y = 5.0, z = 0.2},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("return_vh"),
			Type = "vehdelete",
			Hint = _U("return_vh_button"),
			Spawner = 1,
			Caution = 0,
			GPS = 0,
			Teleport = {x = -1051.7182617188, y = -249.69282531738, z = 37.858947753906}
		}

	}
}
