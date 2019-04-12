
-------------------------------
-- Modification du esx_diving--
--        By Saiji           --
-------------------------------

ESX                             = nil
local PlayerData                = {}
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local OnJob                     = false
local TargetCoords              = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenplongeeActionsMenu(zone)

	local elements = {
		{label = 'Mettre la tenue (100$)', value = 'cloakroom'},
		{label = 'Retirer la tenue', value = 'cloakroom2'}
	}
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'plongee_actions',
		{
			title    = 'plongee',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'cloakroom' then
				menu.close()
				
				TriggerEvent('skinchanger:getSkin', function(skin)

				if skin.sex == 0 then
					local clothesSkin = {
            		['tshirt_1'] = 15,    ['tshirt_2'] = 0,
					['ears_1'] = -1, 	  ['ears_2'] = 0,
            		['torso_1'] = 243,     ['torso_2'] = 20,
            		['decals_1'] = 0,     ['decals_2']= 0,
            		['mask_1'] = 36, 	  ['mask_2'] = 0,
            		['arms'] = 12,
            		['pants_1'] = 94, 	  ['pants_2'] = 20,
            		['shoes_1'] = 67,     ['shoes_2'] = 20,
            		['helmet_1'] 	= 8,  ['helmet_2'] = 0,
            		['bags_1'] = 43,      ['bags_2'] = 0,
					['glasses_1'] = 26,    ['glasses_2'] = 4,
					['chain_1'] = 0,      ['chain_2'] = 0,
            		['bproof_1'] = 0,     ['bproof_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				else
					local clothesSkin = {
            		['tshirt_1'] = 2,    ['tshirt_2'] = 0,
					['ears_1'] = -1,      ['ears_2'] = 0,
            		['torso_1'] = 251,     ['torso_2'] 	= 19,
            		['decals_1'] = 0,     ['decals_2'] = 0,
            		['mask_1'] = 0,      ['mask_2'] 	= 0,
            		['arms'] = 7,
            		['pants_1'] = 97,     ['pants_2'] 	= 19,
            		['shoes_1'] = 70,     ['shoes_2'] 	= 19,
            		['helmet_1']= -1,     ['helmet_2'] 	= 0,
            		['bags_1'] = 43,      ['bags_2']	= 0,
					['glasses_1'] = 28,    ['glasses_2'] = 3,
					['chain_1'] = 0,      ['chain_2'] = 0,
            		['bproof_1'] = 0,     ['bproof_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					TriggerServerEvent('esx_plongee:withdraw', data.amount)
				end
				local playerPed = GetPlayerPed(-1)
				SetEnableScuba(GetPlayerPed(-1),true)
				SetPedMaxTimeUnderwater(GetPlayerPed(-1), 1500.00)
			end)
		end

			if data.current.value == 'cloakroom2' then
				menu.close()
				TriggerEvent('skinchanger:getSkin', function(skin)

				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, hasSkin)

				if hasSkin then

					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('esx:restoreLoadout')
					SetPedMaxTimeUnderwater(GetPlayerPed(-1), 20.00)
				end
				end)
				end)
			end
		end,
		function(data, menu)
			menu.close()
			CurrentAction     = 'plongee_actions_menu'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
			CurrentActionData = {zone = zone}
		end
	)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

AddEventHandler('esx_plongee:hasEnteredMarker', function(zone)

		CurrentAction     = 'plongee_actions_menu'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {zone = zone}
	
end)

AddEventHandler('esx_plongee:hasExitedMarker', function(zone)

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()

end)

-- Create Blips
Citizen.CreateThread(function()		
	for k,v in pairs(Config.Zones) do
  	for i = 1, #v.Pos, 1 do
		local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
		SetBlipSprite (blip, 267)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.5)
		SetBlipColour (blip, 3)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Plongée")
		EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do		
		Wait(0)		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
					DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x) then
					isInMarker  = true
					ShopItems   = v.Items
					currentZone = k
					LastZone    = k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_plongee:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_plongee:hasExitedMarker', LastZone)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustReleased(0, 38) then                
                if CurrentAction == 'plongee_actions_menu' then
                    OpenplongeeActionsMenu()
                end
                
                CurrentAction = nil               
            end
        end
    end
end)