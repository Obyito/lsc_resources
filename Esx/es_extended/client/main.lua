local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local LoadoutLoaded = false
local IsPaused      = false
local PlayerSpawned = false
local LastLoadout   = {}
local Pickups       = {}
local isDead        = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded  = true
	ESX.PlayerData    = xPlayer
	
    local moneyTpl = '<div><img src="http://image.noelshack.com/fichiers/2018/42/7/1540144899-cash.png"/> {{money}}</div>'

    ESX.UI.HUD.RegisterElement('money', 0, 0, moneyTpl, {
      money = 0
    })

    Citizen.CreateThread(function()

          while true do

              Citizen.Wait(2000)
              ESX.UI.HUD.UpdateElement('money', {
                   money = xPlayer.money
              })
          end

    end)
	for i=1, #xPlayer.accounts, 1 do
		local accountTpl = '<div><img src="img/accounts/' .. xPlayer.accounts[i].name .. '.png"/>{{money}}</div>'

		ESX.UI.HUD.RegisterElement('account_' .. xPlayer.accounts[i].name, i-1, 0, accountTpl, {
			money = 0
		})

		ESX.UI.HUD.UpdateElement('account_' .. xPlayer.accounts[i].name, {
			money = xPlayer.accounts[i].money
		})
	end

	local jobTpl = '<div>{{job_label}} - {{grade_label}}</div>'

	if xPlayer.job.grade_label == '' then
		jobTpl = '<div>{{grade_label}}</div>'
	end

	ESX.UI.HUD.RegisterElement('job', #xPlayer.accounts, 0, jobTpl, {
		job_label   = '',
		grade_label = ''
	})

	ESX.UI.HUD.UpdateElement('job', {
		job_label   = xPlayer.job.label,
		grade_label = xPlayer.job.grade_label
	})

    local orgTpl = '<div>{{org_label}}</div>'

	if xPlayer.org.gradeorg_label == '' then
		orgTpl = '<div>{{org_label}}</div>'
	end

    if xPlayer.org_label == 'Organisation' then
      orgTpl = '<div>{{gradeorg_label}}</div>'
    end

	ESX.UI.HUD.RegisterElement('org', #xPlayer.accounts, 0, orgTpl, {
		org_label   = '',
		gradeorg = ''
	})

	ESX.UI.HUD.UpdateElement('org', {
		org_label   = xPlayer.org.label,
		gradeorg_label = xPlayer.org.gradeorg_label
	})

end)

AddEventHandler('playerSpawned', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	local playerPed = PlayerPedId()

	-- Restore position
	if ESX.PlayerData.lastPosition ~= nil then
		SetEntityCoords(playerPed,  ESX.PlayerData.lastPosition.x,  ESX.PlayerData.lastPosition.y,  ESX.PlayerData.lastPosition.z)
	end

	TriggerEvent('esx:restoreLoadout') -- restore loadout

	LoadoutLoaded = true
	PlayerSpawned = true
	isDead = false
end)

AddEventHandler('baseevents:onPlayerDied', function(killerType, deathCoords)
	local playerPed = PlayerPedId()

	local data = {
		killed      = false,
		killerType  = killerType,
		deathCoords = deathCoords,
		deathCause  = GetPedCauseOfDeath(playerPed)
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end)

AddEventHandler('baseevents:onPlayerKilled', function(killerId, data)
	local playerPed = PlayerPedId()
	local killer    = GetPlayerFromServerId(killerId)

	if NetworkIsPlayerActive(killer) then
		local victimCoords = data.killerpos
		local weaponHash   = data.weaponhash

		data.killerpos  = nil
		data.weaponhash = nil

		local killerPed    = GetPlayerPed(killer)
		local killerCoords = GetEntityCoords(killerPed)
		local distance     = GetDistanceBetweenCoords(victimCoords[1], victimCoords[2], victimCoords[3], killerCoords, false)

		table.insert(data, {
			victimCoords = victimCoords,
			weaponHash   = weaponHash,
			deathCause   = GetPedCauseOfDeath(playerPed),
			killed       = true,
			killerId     = killerId,
			killerCoords = { table.unpack(killerCoords) },
			distance     = ESX.Round(distance)
		})

	else
		table.insert(data, {
			killed     = false,
			deathCause = GetPedCauseOfDeath(playerPed)
		})
	end

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('skinchanger:loadDefaultModel', function()
	LoadoutLoaded = false
end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
	local playerPed = PlayerPedId()

	RemoveAllPedWeapons(playerPed, true)

	for i=1, #ESX.PlayerData.loadout, 1 do
		local weaponHash = GetHashKey(ESX.PlayerData.loadout[i].name)
		GiveWeaponToPed(playerPed, weaponHash, ESX.PlayerData.loadout[i].ammo, false, false)
	end

	LoadoutLoaded = true
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
		ESX.PlayerData.accounts[i] = account
		end
	end

	ESX.UI.HUD.UpdateElement('account_' .. account.name, {
		money = account.money
	})
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == item.name then
		ESX.PlayerData.inventory[i] = item
		end
	end

	ESX.UI.ShowInventoryItemNotification(true, item, count)

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == item.name then
		ESX.PlayerData.inventory[i] = item
		end
	end

	ESX.UI.ShowInventoryItemNotification(false, item, count)

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
	--AddAmmoToPed(playerPed, weaponHash, ammo) possibly not needed
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	RemoveWeaponFromPed(playerPed,  weaponHash)

	if ammo then
		local pedAmmo   = GetAmmoInPedWeapon(playerPed, weaponHash)
		local finalAmmo = math.floor(pedAmmo - ammo)
		SetPedAmmo(playerPed, weaponHash, finalAmmo)
	else
		SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
	end
end)

-- Commands
RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(pos)
	pos.x = pos.x + 0.0
	pos.y = pos.y + 0.0
	pos.z = pos.z + 0.0

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(1)
	end

	SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.UI.HUD.UpdateElement('job', {
		job_label   = job.label,
		grade_label = job.grade_label
	})
end)

RegisterNetEvent('esx:loadIPL')
AddEventHandler('esx:loadIPL', function(name)
	Citizen.CreateThread(function()
		LoadMpDlcMaps()
		EnableMpDlcMaps(true)
		RequestIpl(name)
	end)
end)

RegisterNetEvent('esx:unloadIPL')
AddEventHandler('esx:unloadIPL', function(name)
	Citizen.CreateThread(function()
		RemoveIpl(name)
	end)
end)

RegisterNetEvent('esx:playAnim')
AddEventHandler('esx:playAnim', function(dict, anim)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end

		TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, 20000, 0, 1, true, true, true)
	end)
end)

RegisterNetEvent('esx:playEmote')
AddEventHandler('esx:playEmote', function(emote)
	Citizen.CreateThread(function()

		local playerPed = PlayerPedId()

		TaskStartScenarioInPlace(playerPed, emote, 0, false);
		Citizen.Wait(20000)
		ClearPedTasks(playerPed)

	end)
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	ESX.Game.SpawnVehicle(model, coords, 90.0, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
	end)
end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	ESX.Game.SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)

RegisterNetEvent('esx:pickup')
AddEventHandler('esx:pickup', function(id, label, player)
	local ped     = GetPlayerPed(GetPlayerFromServerId(player))
	local coords  = GetEntityCoords(ped)
	local forward = GetEntityForwardVector(ped)
	local x, y, z = table.unpack(coords + forward * -2.0)

	ESX.Game.SpawnLocalObject('prop_money_bag_01', {
		x = x,
		y = y,
		z = z - 2.0,
	}, function(obj)
		SetEntityAsMissionEntity(obj, true, false)
		PlaceObjectOnGroundProperly(obj)

		Pickups[id] = {
			id = id,
			obj = obj,
			label = label,
			inRange = false,
			coords = {
				x = x,
				y = y,
				z = z
			}
		}
	end)
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(id)
	ESX.Game.DeleteObject(Pickups[id].obj)
	Pickups[id] = nil
end)

RegisterNetEvent('esx:pickupWeapon')
AddEventHandler('esx:pickupWeapon', function(weaponPickup, weaponName,ammo)
	local ped          = PlayerPedId()
	local playerPedPos = GetEntityCoords(ped, true)
	CreateAmbientPickup(GetHashKey(weaponPickup), playerPedPos.x + 2.0, playerPedPos.y, playerPedPos.z + 0.5, 0, ammo, 1, false, true)
end)

RegisterNetEvent('esx:spawnPed')
AddEventHandler('esx:spawnPed', function(model)
	model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end

		CreatePed(5, model, x, y, z, 0.0, true, false)
	end)
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function()
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	end

	if DoesEntityExist(vehicle) then
		ESX.Game.DeleteVehicle(vehicle)
	end
end)


-- Pause menu disable HUD display
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			TriggerEvent('es:setMoneyDisplay', 0.0)
			ESX.UI.HUD.SetDisplay(0.0)
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
			TriggerEvent('es:setMoneyDisplay', 1.0)
			ESX.UI.HUD.SetDisplay(1.0)
		end
	end
end)

-- Save loadout
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)

		local playerPed      = PlayerPedId()
		local loadout        = {}
		local loadoutChanged = false

		if IsPedDeadOrDying(playerPed) then
			LoadoutLoaded = false
		end

		for i=1, #Config.Weapons, 1 do

			local weaponHash = GetHashKey(Config.Weapons[i].name)

			if HasPedGotWeapon(playerPed, weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)

				if LastLoadout[Config.Weapons[i].name] == nil or LastLoadout[Config.Weapons[i].name] ~= ammo then
					loadoutChanged = true
				end

				LastLoadout[Config.Weapons[i].name] = ammo

				table.insert(loadout, {
					name  = Config.Weapons[i].name,
					ammo  = ammo,
					label = Config.Weapons[i].label
				})
			else
				if LastLoadout[Config.Weapons[i].name] ~= nil then
					loadoutChanged = true
				end

				LastLoadout[Config.Weapons[i].name] = nil
			end

		end

		if loadoutChanged and LoadoutLoaded then
			ESX.PlayerData.loadout = loadout
			TriggerServerEvent('esx:updateLoadout', loadout)
		end

	end
end)

-- Menu interactions
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(10)

		if IsControlJustReleased(0, Keys['F2']) and GetLastInputMethod(2) and not isDead and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
			ESX.ShowInventory()
		end

	end
end)

-- Dot above head
if Config.ShowDotAbovePlayer then

	Citizen.CreateThread(function()
		while true do

			Citizen.Wait(1)

			local players = ESX.Game.GetPlayers()
			for i = 1, #players, 1 do
				if players[i] ~= PlayerId() then
					local ped    = GetPlayerPed(players[i])
					local headId = CreateMpGamerTag(ped, ('·'), false, false, '', false)
				end
			end

		end
	end)

end

-- Disable wanted level
if Config.DisableWantedLevel then

	Citizen.CreateThread(function()
		while true do

			Citizen.Wait(10)

			local playerId = PlayerId()
			if GetPlayerWantedLevel(playerId) ~= 0 then
				SetPlayerWantedLevel(playerId, 0, false)
				SetPlayerWantedLevelNow(playerId, false)
			end

		end
	end)

end

-- Pickups
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
		
		-- if there's no nearby pickups we can wait a bit to save performance
		if next(Pickups) == nil then
			Citizen.Wait(500)
		end

		for k,v in pairs(Pickups) do

			local distance = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  v.coords.x,  v.coords.y,  v.coords.z,  true)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if distance <= 5.0 then
				ESX.Game.Utils.DrawText3D({
					x = v.coords.x,
					y = v.coords.y,
					z = v.coords.z + 0.25
				}, v.label)
			end

			if (closestDistance == -1 or closestDistance > 3) and distance <= 1.0 and not v.inRange and not IsPedSittingInAnyVehicle(playerPed) then
				TriggerServerEvent('esx:onPickup', v.id)
				PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
				v.inRange = true
			end

		end

	end
end)

-- Last position
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1000)
		if ESX ~= nil and ESX.PlayerLoaded and PlayerSpawned then
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			if not IsEntityDead(playerPed) then
				ESX.PlayerData.lastPosition = {x = coords.x, y = coords.y, z = coords.z}
			end
		end

	end
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1000)

		local playerPed = PlayerPedId()
		if IsEntityDead(playerPed) and PlayerSpawned then
			PlayerSpawned = false
		end
	end
end)

-- Menu interactions
Citizen.CreateThread(function()
	while true do

  	Wait(0)

  	if IsControlPressed(0, Keys["F2"]) and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') and (GetGameTimer() - GUI.Time) > 150 then
  		ESX.ShowInventory()
	  	GUI.Time  = GetGameTimer()
    end

  end
end)

-- Pause menu disable HUD display
Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1)
    if IsPauseMenuActive() and not IsPaused then
      IsPaused = true
      TriggerEvent('es:setMoneyDisplay', 0.0)
      ESX.UI.HUD.SetDisplay(0.0)     
    elseif not IsPauseMenuActive() and IsPaused then
      IsPaused = false
      TriggerEvent('es:setMoneyDisplay', 1.0)
      ESX.UI.HUD.SetDisplay(1.0)    
    end
  end
end)

---------------------------------------------------------------------------------------------------------
--NB : gestion des menu
---------------------------------------------------------------------------------------------------------

RegisterNetEvent('NB:openMenuInventaire')
AddEventHandler('NB:openMenuInventaire', function()
	ESX.ShowInventory()
end)