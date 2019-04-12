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


local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
--local CopPed                    = 0

ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
    while ESX == nil do
	    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function SetVehicleMaxMods(vehicle)

    local props = {
	    modEngine       = 5,
		modBrakes       = 5,
		modTransmission = 5,
		modsuspension   = 3,
		modTurbo        = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)

end

function OpenCloakroomMenu()

  local elements = {
    { label = _U('citizen_wear'), value = 'citizen_wear' }
  }

  if PlayerData.job.grade_name == 'recruit' then
    table.insert(elements, {label = _U('avocat_wear'), value = 'recruit_wear'})
  end

  if PlayerData.job.grade_name == 'boss' then
    table.insert(elements, {label = _U('avocat_wear'), value = 'patron_wear'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)
      menu.close()

      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = GetHashKey("mp_m_freemode_01")
          else
            model = GetHashKey("mp_f_freemode_01")
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 0)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'recruit_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

            if skin.sex == 0 then

                local clothesSkin = {
                  ['tshirt_1'] = 11, ['tshirt_2'] = 0,
                  ['torso_1'] = 28, ['torso_2'] = 0,
                  ['decals_1'] = 0, ['decals_2'] = 0,
                  ['arms'] = 4,
                  ['pants_1'] = 37, ['pants_2'] = 2,
                  ['shoes_1'] = 10, ['shoes_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['chain_1'] = 0, ['chain_2'] = 0,
                  ['ears_1'] = 2, ['ears_2'] = 0
                  }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                  ['tshirt_1'] = 39, ['tshirt_2'] = 0,
                  ['torso_1'] = 6, ['torso_2'] = 4,
                  ['decals_1'] = 8, ['decals_2'] = 3,
                  ['arms'] = 5,
                  ['pants_1'] = 36, ['pants_2'] = 2,
                  ['shoes_1'] = 8, ['shoes_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['chain_1'] = 0, ['chain_2'] = 0,
                  ['ears_1'] = 2, ['ears_2'] = 0
              }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)

        end)
      end

      if data.current.value == 'avocat_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

            if skin.sex == 0 then

                local clothesSkin = {
                    ['tshirt_1'] = 58, ['tshirt_2'] = 0,
                    ['torso_1'] = 55, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 41,
                    ['pants_1'] = 25, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['tshirt_1'] = 35, ['tshirt_2'] = 0,
                    ['torso_1'] = 48, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 44,
                    ['pants_1'] = 34, ['pants_2'] = 0,
                    ['shoes_1'] = 27, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)

        end)
      end

      if data.current.value == 'avocat_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

            if skin.sex == 0 then

                local clothesSkin = {
                    ['tshirt_1'] = 58, ['tshirt_2'] = 0,
                    ['torso_1'] = 55, ['torso_2'] = 0,
                    ['decals_1'] = 8, ['decals_2'] = 2,
                    ['arms'] = 41,
                    ['pants_1'] = 25, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['tshirt_1'] = 35, ['tshirt_2'] = 0,
                    ['torso_1'] = 48, ['torso_2'] = 0,
                    ['decals_1'] = 7, ['decals_2'] = 2,
                    ['arms'] = 44,
                    ['pants_1'] = 34, ['pants_2'] = 0,
                    ['shoes_1'] = 27, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)

        end)
      end

      if data.current.value == 'patron_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

            if skin.sex == 0 then

                local clothesSkin = {
                    ['tshirt_1'] = 11, ['tshirt_2'] = 0,
                    ['torso_1'] = 28, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 4,
                    ['pants_1'] = 37, ['pants_2'] = 2,
                    ['shoes_1'] = 10, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = 2, ['ears_2'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                  ['tshirt_1'] = 39, ['tshirt_2'] = 0,
                  ['torso_1'] = 6, ['torso_2'] = 4,
                  ['decals_1'] = 8, ['decals_2'] = 3,
                  ['arms'] = 5,
                  ['pants_1'] = 36, ['pants_2'] = 2,
                  ['shoes_1'] = 8, ['shoes_2'] = 0,
                  ['helmet_1'] = -1, ['helmet_2'] = 0,
                  ['chain_1'] = 0, ['chain_2'] = 0,
                  ['ears_1'] = 2, ['ears_2'] = 0
              }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)

        end)
      end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )

end

function OpenArmoryMenu(station)

    if Config.EnableArmoryManagement then

	    local elements = {
		    {label = _U('get_weapon'), value = 'get_weapon'},
			{label = _U('put_weapon'), value = 'put_weapon'},
		    {label = 'Prendre Objet', value = 'get_stock'},
			{label = 'Déposer objet', value = 'put_stock'}
		}

		if PlayerData.job.grade_name == 'boss' then
		    table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'armory',
			{
			    title    = _U('armory'),
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)

			    if data.current.value == 'get_weapon' then
				    OpenGetWeaponMenu()
				end

				if data.current.value == 'put_weapon' then
				    OpenPutWeaponMenu()
				end

				if data.current.value == 'buy_weapons' then
				    OpenBuyWeaponsMenu(station)
				end

			    if data.current.value == 'put_stock' then
				        OpenPutStockMenu()
				    end

					if data.current.value == 'get_stock' then
					    OpenGetStockMenu()
					end
			end,
			function(data, menu)

			    menu.close()

				CurrentAction     = 'menu_armory'
				CurrentActionMsg  = _U('open_armory')
				CurrentActionData = {station = station}
			end
		)

	else

	    local elements = {}

		for i=1, #Config.AvocatStations[station].AuthorizedWeapons, 1 do
		    local weapon = Config.AvocatStations[station].AuthorizedWeapons[i]
			table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'armory',
			{
			    title    = _U('armory'),
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)
			    local weapon = data.current.value
				TriggerServerEvent('esx_avocat:giveWeapon', weapon, 1000)
			end,
			function(data, menu)

			    menu.close()

				CurrentAction     = 'menu_armory'
				CurrentActionMsg  = _U('open_armory')
				CurrentActionData = {station = station}

			end
		)
	end

end

function OpenVehicleSpawnerMenu(station, partNum)

    local vehicles = Config.AvocatStations[station].Vehicles

	ESX.UI.Menu.CloseAll()

	if Config.EnableSocietyOwnedVehicles then

	    local elements = {}

		ESX.TriggerServerCallback('esx_avocat:getVehiclesInGarage', function(garageVehicles)

		    for i=1, #garageVehicles, 1 do
			    table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
			end

			ESX.UI.Menu.Open(
			    'default', GetCurrentResourceName(), 'vehicle_spawner',
				{
				    title    = _U('vehicle_menu'),
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)

				    menu.close()

					local vehicleProps = data.current.value

					ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
					    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
						local playerPed = GetPlayerPed(-1)
						TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					end)

					TriggerServerEvent('esx_society:removeVehicleFromGarage', 'avocat', vehicleProps)

				end,
				function(data, menu)

				    menu.close()

					CurrentAction     = 'menu_vehicle_spawner'
					CurrentActionMsg  = _U('vehicle_spawner')
					CurrentActionData = {station = station, partNum = partNum}

				end
			)

		end, 'avocat')

	else

	    local elements = {}

		if PlayerData.job.grade_name == 'recruit' then
		    table.insert(elements, { label = 'Bentley', value = 'urus'})
		end

		if PlayerData.job.grade_name == 'boss' then
		    table.insert(elements, { label = 'AudiR8', value = 'r8prior'})
			table.insert(elements, { label = 'Bentlay', value = 'urus'})
		end

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'vehicle_spawner',
			{
			    title    = _U('vehicle_menu'),
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)

			    menu.close()

				local model = data.current.value

				local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x, vehicles[partNum].SpawnPoint.y, vehicles[partNum].SpawnPoint.z, 3.0, 0, 71)

				if not DoesEntityExist(vehicle) then

				    local playerPed = GetPlayerPed(-1)

					if Config.MaxInService == -1 then

					    ESX.Game.SpawnVehicle(model, {
						    x = vehicles[partNum].SpawnPoint.x,
							y = vehicles[partNum].SpawnPoint.y,
							z = vehicles[partNum].SpawnPoint.z
						}, vehicles[partNum].Heading, function(vehicle)
						    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
							SetVehicleMaxMods(vehicle)
              SetVehicleNumberPlateText(vehicle, "Avocat")
						end)

					else

					    ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

						    if canTakeService then

							    ESX.Game.SpawnVehicle(model, {
								    x = vehicles[partNum].SpawnPoint.x,
									y = vehicles[partNum].SpawnPoint.y,
									z = vehicles[partNum].SpawnPoint.z
								}, vehicles[partNum].Heading, function(vehicle)
								    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
									SetVehicleMaxMods(vehicle)
								end)

							else
							    ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
							end

						end, 'avocat')

					end

				else
				    ESX.ShowNotification(_U('vehicle_out'))
				end

			end,
			function(data, menu)

			    menu.close()

				CurrentAction     = 'menu_vehicle_spawner'
				CurrentActionMsg  = _U('vehicle_spawner')
				CurrentActionData = {station = station, partNum = partNum}

			end
		)

	end

end

function OpenPoliceActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'avocat_actions',
    {
      title    = 'Avocat',
      align    = 'top-left',
      elements = {
        {label = _U('citizen_interaction'), value = 'citizen_interaction'},
      },
    },
    function(data, menu)

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('citizen_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('id_card'),       value = 'identity_card'},
              {label = _U('persofine'),            value = 'persofine'}
            },
          },
          function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

              if data2.current.value == 'identity_card' then
                OpenIdentityCardMenu(player)
              end

              if data2.current.value == 'persofine' then
                OpenAvocatActionsMenu(player)
              end

            else
              ESX.ShowNotification(_U('no_players_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

	end)

end

function OpenIdentityCardMenu(player)

    if Config.EnableESXIdentity then

	    ESX.TriggerServerCallback('esx_avocat:getOtherPlayerData', function(data)

		    local jobLabel    = nil
			local sexLabel    = nil
			local sex         = nil
			local dobLabel    = nil
			local heightLabel = nil
			local idLabel     = nil

			if data.job.grade_label ~= nil and data.job.grade_label ~= '' then
			    jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
			else
			    jobLabel = 'Job : ' .. data.job.label
			end

			if data.sex ~= nil then
			    if (data.sex == 'm') or (data.sex == 'M') then
				    sex = 'Male'
				else
				    sex = 'Female'
				end
				sexLabel = 'Sex : ' .. sex
			else
			    sexLabel = 'Sex : Unknown'
			end

			if data.job ~= nil then
			    dobLabel = 'DOB : ' .. data.dob
			else
			    dobLabel = 'DOB : Unknown'
			end

			if data.height ~= nil then
			    heightLabel = 'Height : ' .. data.height
			else
			    heightLabel = 'Height : Unknown'
			end

			if data.name ~= nil then
			    idLabel = 'ID : ' .. data.name
			else
			    idLabel = 'ID : Unknown'
			end

			local elements = {
			    {label = _U('name') .. data.firstname .. " " .. data.lastname, value = nil},
				{label = sexLabel,    value = nil},
				{label = dobLabel,    value = nil},
				{label = heightLabel, value = nil},
				{label = jobLabel,    value = nil},
				{label = idLabel,     value = nil},
			}

			if data.licenses ~= nil then

			    table.insert(elements, {label = '--- Licenses ---', value = nil})

				for i=1, #data.licenses, 1 do
				    table.insert(elements, {label = data.licenses[i].label, value = nil})
				end

			end

			ESX.UI.Menu.Open(
			    'default', GetCurrentResourceName(), 'citizen_interaction',
				{
				    title     = _U('citizen_interaction'),
					align     = 'top-left',
					elements  = elements,
				},
				function(data, menu)

				end,
				function(data, menu)
			        menu.close()
				end
			)
		end, GetPlayerServerId(player))

	else

	    ESX.TriggerServerCallback('esx_avocat:getOtherPlayerData', function(data)

		    local jobLabel = nil

			if data.job.grade_label ~= nil and data.job.grade_label ~= '' then
	            jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
			else
			    jobLabel = 'Job : ' .. data.job.label
			end

                local elements = {
                    {label = _U('name') .. data.name, value = nil},
                    {label = jobLabel,                value = nil},
				}

			if data.licenses ~= nil then

			    table.insert(elements, {label = '--- Licenses ---', value = nil})

				for i=1, #data.licenses, 1 do
				    table.insert(elements, {label = data.licenses[i].label, value = nil})
				end

			end

			ESX.UI.Menu.Open(
			    'default', GetCurrentResourceName(), 'citizen_interaction',
				{
				    title    = _U('citizen_interaction'),
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)

				end,
				function(data, menu)
				    menu.close()
				end
			)

		end, GetPlayerServerId(player))

	end

end

--function OpenFineMenu(player)

   -- ESX.UI.Menu.Open(
	    --'default', GetCurrentResourceName(), 'persofine',
		--{
		    --title    = _U('persofine'),
			--align    = 'top-left',
			--elements = {
			    --{label = _U('payment'), value = 0}
			--},
		--},
		--function(data, menu)

		    --OpenFineCategoryMenu(player, data.current.value)

		--end,
		--function(data, menu)
		    --menu.close()
		--end
	--)

--end

function OpenAvocatActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'avocat_actions',
    {
      title    = 'Avocat',
      elements = {
        {label = _U('persofine'), value = 'persofine'}
      }
    },
    function(data, menu)

      if data.current.value == 'persofine' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'persofine',
          {
            title = _U('invoice_amount')
          },
          function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil then
              ESX.ShowNotification(_U('amount_invalid'))
            else

              menu.close()

              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification(_U('no_players_near'))
              else
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_avocat', 'Avocat', amount)
              end

            end

          end,
          function(data, menu)
            menu.close()
          end
        )

      end

    end,
    function(data, menu)
      menu.close()
    end
  )

end


function OpenGetWeaponMenu()

    ESX.TriggerServerCallback('esx_avocat:getArmoryWeapons', function(weapons)

	    local elements = {}

		for i=1, #weapons, 1 do
		    if weapons[i].count > 0 then
			    table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
			end
		end

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'armory_get_weapon',
			{
			    title    = _U('get_weapon_menu'),
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)

			    menu.close()

				ESX.TriggerServerCallback('esx_avocat:removeArmoryWeapon', function()
				    OpenGetWeaponMenu()
				end, data.current.value)

			end,
			function(data, menu)
			    menu.close()
			end
		)

	end)

end

function OpenPutWeaponMenu()

    local elements   = {}
	local playerPed  = GetPlayerPed(-1)
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do

	    local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
		    local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
			table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
		end

	end

	ESX.UI.Menu.Open(
	    'default', GetCurrentResourceName(), 'armory_put_weapon',
		{
		    title    = _U('put_weapon_menu'),
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)

		    menu.close()

			ESX.TriggerServerCallback('esx_avocat:addArmoryWeapon', function()
			    OpenPutWeaponMenu()
			end, data.current.value)

		end,
		function(data, menu)
		    menu.close()
		end
	)

end

function OpenBuyWeaponsMenu(station)

    ESX.TriggerServerCallback('esx_avocat:getArmoryWeapons', function(weapons)

	    local elements = {}

		for i=1, #Config.AvocatStations[station].AuthorizedWeapons, 1 do

		    local weapon = Config.AvocatStations[station].AuthorizedWeapons[i]
			local count  = 0

			for i=1, #weapons, 1 do
			    if weapons[i].name == weapon.name then
				    count = weapons[i].count
					break
				end
			end

			table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})
		end

		ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'armory_buy_weapons',
            {
                title    = _U('buy_weapon_menu'),
                align    = 'top-left',
                elements = elements,
            },
            function(data, menu)

                ESX.TriggerServerCallback('esx_avocat:buy', function(hasEnoughMoney)

                    if hasEnoughMoney then
                        ESX.TriggerServerCallback('esx_avocat:addArmoryWeapon', function()
                            OpenBuyWeaponsMenu(station)
                        end, data.current.value)
                    else
                        ESX.ShowNotification(_U('not_enough_money'))
                    end

                end, data.current.price)

            end,
            function(data, menu)
                menu.close()
            end
        )

    end)

end

function OpenGetStockMenu()

    ESX.TriggerServerCallback('esx_avocat:getStockItems', function(items)

        print(json.encode(items))

        local elements = {}

        for i=1, #items,1 do
            table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'stocks_menu',
			{
			    title    = _U('avocat_stock'),
				elements = elements
			},
			function(data, menu)

			    local itemName = data.current.value

				ESX.UI.Menu.Open(
				    'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
					{
					    title = _U('quantity')
					},
					function(data2, menu2)

					    local count = tonumber(data2.value)

						if count == nil then
						    ESX.ShowNotification(_u('quantity_invalid'))
						else
						    menu2.close()
							menu.close()
							OpenGetStockMenu()

							TriggerServerEvent('esx_avocat:getStockItem', itemName, count)
						end

					end,
					function(data2, menu2)
					    menu2.close()
					end
				)

			end,
			function(data, menu)
			    menu.close()
			end
		)

	end)

end

function OpenPutStockMenu()

    ESX.TriggerServerCallback('esx_avocat:getPlayerInventory', function(inventory)

	    local elements = {}

		for i=1, #inventory.items, 1 do

		    local item = inventory.items[i]

			if item.count > 0 then
			    table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end

		end

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'stocks_menu',
			{
			    title    = _U('inventory'),
				elements = elements
			},
			function(data, menu)

			    local itemName = data.current.value

				ESX.UI.Menu.Open(
				    'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
				    {
					    title = _U('quantity')
					},
					function(data2, menu2)

					    local count = tonumber(data2.value)

					    if count == nil then
						    ESX.ShowNotification(_U('quantity_invalid'))
						else
						    menu2.close()
							menu.close()
							OpenPutStockMenu()

							TriggerServerEvent('esx_avocat:putStockItems', itemName, count)
						end

					end,
					function(data2, menu2)
					    menu2.close()
					end
				)

			end,
			function(data, menu)
			    menu.close()
		    end
		)

	end)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

    local specialContact = {
	    name       = 'Avocat',
		  number     = 'avocat',
        base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAB8SURBVEhLYxgFo2AUjIKRABihNBHgjYwKhCHy5A6EQQxggtI0A6RZsPzrJyAJ9woxgFgLIIbmvn8F4RIPBkcQcTAi0gIkhokPJaJSEVbjiExLNA8iwuCguCzQB8ieiOHmQxPBAwj7QJuVHUgiB8gScGIdBaNgFAwWwMAAAJCkGvcXbMRGAAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_avocat:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  end

  if part == 'VehicleSpawner' then
    CurrentAction     = 'menu_vehicle_spawner'
    CurrentActionMsg  = _U('vehicle_spawner')
    CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'VehicleDeleter' then

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed, false)

      if DoesEntityExist(vehicle) then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end

    end

  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_avocat:hasExitedMarker', function(station, part, partNum)
    ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

Citizen.CreateThread(function()

    for k,v in pairs(Config.AvocatStations) do

	    local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('map_blip'))
		EndTextCommandSetBlipName(blip)

	end

end)

Citizen.CreateThread(function()
  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'avocat' then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)

      for k,v in pairs(Config.AvocatStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Vehicles, 1 do
          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' and PlayerData.job.grade_name == 'boss' then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.DrawDistance then
              DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end

        end

      end

    end

  end
end)

Citizen.CreateThread(function()

  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'avocat' then

      local playerPed      = GetPlayerPed(-1)
      local coords         = GetEntityCoords(playerPed)
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config.AvocatStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
          end
        end

        for i=1, #v.Vehicles, 1 do

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawnPoint'
            currentPartNum = i
          end

        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleDeleter'
            currentPartNum = i
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' and PlayerData.job.grade_name == 'boss' then

          for i=1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
              isInMarker     = true
              currentStation = k
              currentPart    = 'BossActions'
              currentPartNum = i
            end
          end

        end

      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_avocat:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_avocat:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_avocat:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

    end

  end
end)

Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
        end

        if CurrentAction == 'delete_vehicle' then

          if Config.EnableSocietyOwnedVehicles then

            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'avocat', vehicleProps)

		  else

		    if
              GetEntityModel(vehicle) == GetHashKey('police')  or
              GetEntityModel(vehicle) == GetHashKey('police2') or
              GetEntityModel(vehicle) == GetHashKey('police3') or
              GetEntityModel(vehicle) == GetHashKey('police4') or
              GetEntityModel(vehicle) == GetHashKey('policeb') or
              GetEntityModel(vehicle) == GetHashKey('policet')
            then
              TriggerServerEvent('esx_service:disableService', 'avocat')
            end

          end

          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'avocat', function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end)

        end

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end

    if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'avocat' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'avocat_actions') and (GetGameTimer() - GUI.Time) > 150 then
      OpenPoliceActionsMenu()
      GUI.Time = GetGameTimer()
    end

  end
end)
