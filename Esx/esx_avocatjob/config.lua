Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 25
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = true
Config.MaxInService               = -1
Config.Locale = 'fr'

Config.AvocatStations = {

  AVOCAT = {

    Blip = {
      Pos     = { x = -304.905, y = -616.622, z = 33.556 },
      Sprite  = 269,
      Display = 4,
      Scale   = 1.0,
      Colour  = 35,
    },

    AuthorizedWeapons = {
      { name = 'WEAPON_STUNGUN',          price = 5000 },
    },

    AuthorizedVehicles = {
      { name = 'police',  label = 'Véhicule de patrouille 1' },
      { name = 'police2', label = 'Véhicule de patrouille 2' },
      { name = 'police3', label = 'Véhicule de patrouille 3' },
      { name = 'police4', label = 'Véhicule civil' },
      { name = 'policeb', label = 'Moto' },
      { name = 'policet', label = 'Van de transport' },
    },

    Cloakrooms = {
      { x = -82.678, y = -810.010, z = 242.385 },
    },


    Armories = {
      { x = -77.773, y = -810.908, z = 242.385 },
    },

    Vehicles = {
      {
        Spawner    = { x = -370.412, y = -641.796, z = 30.266 },
        SpawnPoint = { x = -364.692, y = -644.675, z = 31.455 },
        Heading    = 90.0,
      }
    },

    VehicleDeleters = {
      { x = -365.775, y = -642.277, z = 30.500 },
    },

    BossActions = {
      { x = -80.591, y = -801.505, z = 242.405 }
    },

  },

}
