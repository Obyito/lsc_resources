Config              = {}
Config.MarkerType   = 1
Config.DrawDistance = 100.0
Config.ZoneSize     = {x = 5.0, y = 5.0, z = 3.0}
--Config.MarkerColor  = {r = 100, g = 204, b = 100}
Config.ShowBlips   = false  --markers visible on the map? (false to hide the markers on the map)

Config.RequiredCopsCoke  = 1
Config.RequiredCopsMeth  = 1
Config.RequiredCopsWeed  = 0
Config.RequiredCopsOpium = 1

Config.TimeToFarm    = 3 * 750
Config.TimeToProcess = 3 * 700
Config.TimeToSell    = 3 * 700

Config.Locale = 'fr'

Config.Zones = {
	CokeField =			{x = 318.35882568359,	y = 6655.1411132813,	z = 28.93111038208,		name = _U('coke_field'),		sprite = 501,	color = 40}, --ok
	CokeProcessing =	{x = 2432.5939941406,	y = 4972.1279296875,	z = 42.347599029541,	name = _U('coke_processing'),	sprite = 478,	color = 40}, --ok
	CokeDealer =		{x = 176.90342712402,	y = -1856.2749023438,	z = 24.063276290894,	name = _U('coke_dealer'),		sprite = 500,	color = 75}, --ok
	MethField =			{x = 173.68449401855,	y = 2778.5864257813,	z = 46.077297210693,	name = _U('meth_field'),		sprite = 499,	color = 26}, --ok
	MethProcessing =	{x = 1389.2780761719,	y = 3604.7658691406,	z = 38.941890716553,	name = _U('meth_processing'),	sprite = 499,	color = 26}, --ok
	MethDealer =		{x = -63.59,			y = -1224.07,			z = 27.76,				name = _U('meth_dealer'),		sprite = 500,	color = 75}, --ok
	WeedField =			{x = 1831.8612060547,	y = 4991.501953125,		z = 53.045333862305,	name = _U('weed_field'),		sprite = 496,	color = 52}, --ok
	WeedProcessing =	{x = -45.712841033936,	y = 1917.9655761719,	z = 195.70532226563,	name = _U('weed_processing'),	sprite = 496,	color = 52}, --ok
	WeedDealer =		{x = -54.24,			y = -1443.36,			z = 31.06,				name = _U('weed_dealer'),		sprite = 500,	color = 75}, --ok
	OpiumField =		{x = 1972.78,			y = 3819.39,			z = 32.50,				name = _U('opium_field'),		sprite = 51,	color = 60}, --ok
	OpiumProcessing =	{x = 245.53923034668,	y = 370.65252685547,	z = 105.7381439209,		name = _U('opium_processing'),	sprite = 51,	color = 60}, --ok
	OpiumDealer =		{x = 2331.08,			y = 2570.22,			z = 45.30,				name = _U('opium_dealer'),		sprite = 500,	color = 75}, --ok
}
