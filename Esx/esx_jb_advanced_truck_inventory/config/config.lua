--Truck
Config	=	{}

 -- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Limit = 25000

-- Default weight for an item:
	-- weight == 0 : The item do not affect character inventory weight
	-- weight > 0 : The item cost place on inventory
	-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 0



-- If true, ignore rest of file
Config.WeightSqlBased = false

-- I Prefer to edit weight on the config.lua and I have switched Config.WeightSqlBased to false:

Config.localWeight = {
	WEAPON_COMBATPISTOL = 1000,
	WEAPON_STUNGUN = 8000,
	WEAPON_SAWNOFFSHOTGUN = 1200,
	WEAPON_MICROSMG = 7500,
	WEAPON_HEAVYSHOTGUN = 8700,
	WEAPON_COMPACTRIFLE = 9800,
	WEAPON_ASSAULTRIFLE = 10000,
	WEAPON_SPECIALCARBINE = 11000,
	WEAPON_SMG = 11000,
	WEAPON_MG = 11000,
	WEAPON_COMBATPDW = 12000,
	WEAPON_MARKSMANRIFLE = 13000,
	WEAPON_GUSENBERG = 13000,
	WEAPON_BAT = 1100,
	WEAPON_GOLFCLUB = 2000,
	WEAPON_VINTAGEPISTOL = 1200,
	WEAPON_KNUCKLE = 1000,
	WEAPON_PISTOL50 = 1600,
	WEAPON_REVOLVER = 1300,
	WEAPON_FLASHLIGHT = 600,
	WEAPON_HATCHET = 800,
	WEAPON_CROWBAR = 900,
	WEAPON_HAMMER = 500,
	WEAPON_KNIFE = 400,
	WEAPON_MACHETE = 500,
	WEAPON_SNSPISTOL = 1800,
	WEAPON_MUSKET = 6000,
	black_money = 30, -- poids pour un argent
	alive_chicken = 1000,
	bandage = 100,
	blowpipe = 2000,
	bolcacahuetes = 200,
	bolchips = 200,
	bolnoixcajou = 200,
	bolpistache = 200,
	bread = 125,
	carotool = 2000,
	carokit = 10000,
	clothe = 500,
	coke = 300,
	coke_pooch = 900,
	copper = 500,
	croquettes = 200,
	alcool = 400,
	alcool_cargo = 1200,
	cagoule = 200,
	clip = 150,
	cutted_wood = 1000,
    diamond = 200,	
	drpepper = 300,
	energy = 300,
	essence = 2500,
	fabric = 300,
	fish = 300,
	fixkit = 2800,
	fixtool = 3000,
	flashlight = 400,
	gazbottle = 10000,
	gitanes = 150,
	gold = 800,
	golem = 5000,
	grand_cru = 400,
	grapperaisin = 250,
	ice = 100,
	icetea = 300,
	iron = 700,
	jager = 400,
	jagerbomb = 400,
	jagercerbere = 400,
	jewels = 600,
	jusfruit = 250,
	jus_raisin = 250,
	limonade = 350,
	lsd = 300,
	lsd_pooch = 750,
	malbora = 150,
	martini = 250,
	medikit = 2500,
	menthe = 30,
	meth = 350,
	meth_pooch = 900,
	metreshooter = 1000,
	mixapero = 400,
	mojito = 300,
	myrte = 400,
	myrtealcool = 400,
	myrte_cargo = 1200,
	opium = 300,
	opium_pooch = 750,
	packaged_chicken = 250,
	packaged_plank = 500,
	petrol = 1042,
	petrol_raffin = 1042,
	powerade = 300,
	protein_shake = 320,
	raisin = 300,
	redbull = 300,
	redbull_cargo = 1200,
	rhum = 350,
	rhumcoca = 150,
	rhumfruit = 150,
	sacbillets = 500,
	saucisson = 200,
	slaughtered_chicken = 1250,
	soda = 300,
	sportlunch = 200,
	stone = 2900,
	tabacblond = 20,
	tabacbloncsec = 20,
	tabacbrun = 20,
	tabacbrunsec = 20,
	teqpaf = 120,
	tequila = 120,
	viande = 1000,
	vine = 300,
	vodka = 300,
	vodkaenergy = 150,
	vodkafruit = 150,
	vodkrb = 150,
	washed_stone = 2600,
	weed = 200,
	weed_pooch = 900,
	whisky = 150,
	whiskycoc = 120,
	whiskycoca = 120,
	wood = 1250,
	wool = 625,
	water = 330,}

Config.VehicleLimit = {
    [0] = 30000, --Compact
    [1] = 40000, --Sedan
    [2] = 70000, --SUV
    [3] = 25000, --Coupes
    [4] = 30000, --Muscle
    [5] = 10000, --Sports Classics
    [6] = 5000, --Sports
    [7] = 5000, --Super
    [8] = 5000, --Motorcycles
    [9] = 18000, --Off-road
    [10] = 300000, --Industrial
    [11] = 70000, --Utility
    [12] = 80000, --Vans
    [13] = 0, --Cycles
    [14] = 5000, --Boats
    [15] = 20000, --Helicopters
    [16] = 20000, --Planes
    [17] = 40000, --Service
    [18] = 40000, --Emergency
    [19] = 20000, --Military
    [20] = 80000, --Commercial
    [21] = 20000, --Trains
}