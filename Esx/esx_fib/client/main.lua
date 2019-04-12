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
local IsHandcuffed              = false
local IsDragged                 = false
local CopPed                    = 0

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
    modEngine       = 4,
    modBrakes       = 3,
    modTransmission = 3,
    modSuspension   = 3,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function OpenCloakroomMenu()

	local elements = {
    {label = _U('citizen_wear'), value = 'citizen_wear'},
    {label = 'Tenue Swat', value = 'swat_wear'},	
	}
	
	if PlayerData.job ~= nil and (PlayerData.job.grade_name == 'recruit' or PlayerData.job.grade_name == 'agent' or PlayerData.job.grade_name == 'specialagent') then
		table.insert(elements, {label = 'Tenue Agent du FIB', value = 'fib_wear'})
	end
	
	if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = 'Tenue Directeur FIB ', value = 'fibboss_wear'})	
	end
	

	ESX.UI.Menu.CloseAll()
	
	if Config.EnableNonFreemodePeds then
		table.insert(elements, {label = _U('test'), value = 'test'})
		table.insert(elements, {label = _U('test'), value = 'test'})
	end	

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'cloakroom',
			{
				title    = _U('cloakroom'),
				align    = 'top-left',
				elements = elements,
				},

				function(data, menu)

			menu.close()

			--Taken from SuperCoolNinja
			if data.current.value == 'citizen_wear' then

            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

            if skin.sex == 0 then

                local model = GetHashKey("mp_m_freemode_01")
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        RequestModel(model)
                        Citizen.Wait(0)
                    end

                    SetPlayerModel(PlayerId(), model)
                    SetModelAsNoLongerNeeded(model)
                    TriggerEvent('skinchanger:loadSkin', skin)
            else
                    local model = GetHashKey("mp_f_freemode_01")

                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        RequestModel(model)
                        Citizen.Wait(0)
                    end

                    SetPlayerModel(PlayerId(), model)
                    SetModelAsNoLongerNeeded(model)
                    TriggerEvent('skinchanger:loadSkin', skin)
                    end

                end)
            end

			if data.current.value == 'fib_wear' and PlayerData.job.name == 'fib' then

				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

    				if skin.sex == 0 then
        				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
    				else
        				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
    				end
    
				end)
			end
			

			if data.current.value == 'fibboss_wear' and PlayerData.job.grade_name == 'boss' then

				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

    				if skin.sex == 0 then
        				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
    				else
        				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
    				end
    
				end)
			end
			
		if data.current.value == 'swat_wear' and PlayerData.job.name == 'fib' then
		
			local hashSkin = GetHashKey("mp_m_freemode_01")
		    Citizen.CreateThread(function()
		
		  if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
		
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  -- retrait grade
			
			SetPedComponentVariation(GetPlayerPed(-1), 11, 49, 0, 2)  -- Chemise Police
			SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2)   -- Ceinture+matraque Police 
			SetPedComponentVariation(GetPlayerPed(-1), 4, 34, 0, 2)   -- Pantalon Police
			SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 2)   -- Chaussure Police
			SetPedComponentVariation(GetPlayerPed(-1), 3, 17, 0, 2)   -- under skin
			SetPedComponentVariation(GetPlayerPed(-1), 9, 16, 2, 2)   -- parballes
			SetPedComponentVariation(GetPlayerPed(-1), 1, 52, 0, 0)   -- Mask
			SetPedPropIndex(GetPlayerPed(-1), 0, 39,0, 0) -- casque
			
			SetPedArmour(GetPlayerPed(-1), 100) -- Ajout armure
			
		  else
		
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  -- retrait grade
			
			SetPedComponentVariation(GetPlayerPed(-1), 11, 42, 0, 2) -- Chemise Police
			SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2)  -- Ceinture+matraque Police 
			SetPedComponentVariation(GetPlayerPed(-1), 4, 33, 0, 2)  -- Pantalon Police
			SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 2)  -- Chaussure Police
			SetPedComponentVariation(GetPlayerPed(-1), 3, 18, 0, 2)   -- under skin
			SetPedComponentVariation(GetPlayerPed(-1), 9, 18, 2, 2)   -- parballe
			SetPedComponentVariation(GetPlayerPed(-1), 1, 52, 0, 0)   -- Mask
			SetPedPropIndex(GetPlayerPed(-1), 0, 38,0, 0) -- casque
			
			SetPedArmour(GetPlayerPed(-1), 100) -- Ajout armure
		
		  end
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
	  {label = 'Prendre un gilet pare-balle',  value = 'gilet_wear'},
	  {label = 'Enlever le gilet pare-balle',  value = 'veste_wear'},
      {label = _U('get_weapon'), value = 'get_weapon'},
      {label = _U('put_weapon'), value = 'put_weapon'},
      {label = 'Prendre Objet',  value = 'get_stock'},
      {label = 'Déposer objet',  value = 'put_stock'}
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
              OpenPutStocksMenu()
            end

            if data.current.value == 'get_stock' then
              OpenGetStocksMenu()
            end
			
		if data.current.value == 'gilet_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function()
          --SetPedComponentVariation(GetPlayerPed(-1), 9, 20, 6, 2)--Gilet
          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 100)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
          end)
        end
	  
	    if data.current.value == 'veste_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function()
          --SetPedComponentVariation(GetPlayerPed(-1), 9, 14, 1, 2)--Sans Gilet
          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 0)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
          end)
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

    for i=1, #Config.FibStations[station].AuthorizedWeapons, 1 do
      local weapon = Config.FibStations[station].AuthorizedWeapons[i]
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
        TriggerServerEvent('esx_fib:giveWeapon', weapon,  1000)
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

  local vehicles = Config.FibStations[station].Vehicles

  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

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
            TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
          end)

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'fib', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('vehicle_spawner')
          CurrentActionData = {station = station, partNum = partNum}

        end
      )

    end, 'fib')

  else

    local elements = {}

	table.insert(elements, { label = 'Buffalo FIB', value = 'fbi'})
	table.insert(elements, { label = 'Suv FIB', value = 'fbi2'})	
    table.insert(elements, { label = 'Antiémeute', value = 'riot'})
	table.insert(elements, { label = 'Limousine Présid', value = 'schafter5'})


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

        local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          local playerPed = GetPlayerPed(-1)

          if Config.MaxInService == -1 then

            ESX.Game.SpawnVehicle(model, {
              x = vehicles[partNum].SpawnPoint.x,
              y = vehicles[partNum].SpawnPoint.y,
              z = vehicles[partNum].SpawnPoint.z
            }, vehicles[partNum].Heading, function(vehicle)
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
              SetVehicleMaxMods(vehicle)
            end)

          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                ESX.Game.SpawnVehicle(model, {
                  x = vehicles[partNum].SpawnPoint.x,
                  y = vehicles[partNum].SpawnPoint.y,
                  z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                  TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
                  SetVehicleMaxMods(vehicle)
                end)

              else
                ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'fib')

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

function OpenVehicle1SpawnerMenu(station, partNum)

	local vehicles1 = Config.FibStations[station].Vehicles1

	ESX.UI.Menu.CloseAll()

	if Config.EnableSocietyOwnedVehicles1 then

		local elements = {}

		ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles1)

			for i=1, #garageVehicles1, 1 do
				table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles1[i].model) .. ' [' .. garageVehicles1[i].plate .. ']', value = garageVehicles1[i]})
			end

			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'vehicle_spawner1',
				{
					title    = _U('vehicle_menu'),
					align    = 'top-left',
					elements = elements,
				},
				function(data, menu)

					menu.close()

					local vehicleProps = data.current.value

					ESX.Game.SpawnVehicle(vehicleProps.model, vehicles1[partNum].SpawnPoint1, 270.0, function(vehicle)

						ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
						local playerPed = GetPlayerPed(-1)

						if model == 'frogger2' then
							SetVehicleModKit(vehicle, 0)
							SetVehicleLivery(vehicle, 1)
						end

						TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					end)

					TriggerServerEvent('esx_society:removeVehicleFromGarage', 'fib', vehicleProps)

				end,
				function(data, menu)

					menu.close()

					CurrentAction     = 'menu_vehicle_spawner1'
					CurrentActionMsg  = _U('vehicle_spawner')
					CurrentActionData = {station = station, partNum = partNum}

				end
			)

		end, 'fib')

	else

		local elements = {}

		for i=1, #Config.FibStations[station].AuthorizedVehicles1, 1 do
			local vehicle = Config.FibStations[station].AuthorizedVehicles1[i]
			table.insert(elements, {label = vehicle.label, value = vehicle.name})
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_spawner1',
			{
				title    = _U('vehicle_menu'),
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)

				menu.close()

				local model = data.current.value

				local vehicle = GetClosestVehicle(vehicles1[partNum].SpawnPoint1.x,  vehicles1[partNum].SpawnPoint1.y,  vehicles1[partNum].SpawnPoint1.z,  3.0,  0,  71)

				if not DoesEntityExist(vehicle) then

					local playerPed = GetPlayerPed(-1)

					if Config.MaxInService == -1 then

						ESX.Game.SpawnVehicle(model, {
							x = vehicles1[partNum].SpawnPoint1.x, 
							y = vehicles1[partNum].SpawnPoint1.y, 
							z = vehicles1[partNum].SpawnPoint1.z
						}, vehicles1[partNum].Heading1, function(vehicle)
							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
							SetVehicleMaxMods(vehicle)
						end)

					else

						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

							if canTakeService then

								ESX.Game.SpawnVehicle(model, {
									x = vehicles1[partNum].SpawnPoint1.x, 
									y = vehicles1[partNum].SpawnPoint1.y, 
									z = vehicles1[partNum].SpawnPoint1.z
								}, Vehicles1[partNum].Heading, function(vehicle)
									TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
									SetVehicleMaxMods(vehicle)
								end)

							else
								ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
							end

						end, 'fib')

					end

				else
					ESX.ShowNotification(_U('vehicle_out'))
				end

			end,
			function(data, menu)

				menu.close()

				CurrentAction     = 'menu_vehicle_spawner1'
				CurrentActionMsg  = _U('vehicle_spawner')
				CurrentActionData = {station = station, partNum = partNum}

			end
		)

	end

end

function OpenFibActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'fib_actions',
    {
      title    = 'Fib',
      align    = 'top-left',
      elements = {
        {label = _U('citizen_interaction'), value = 'citizen_interaction'},
        {label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
        {label = _U('object_spawner'),      value = 'object_spawner'},
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
              {label = _U('id_card'),         value = 'identity_card'},
              {label = _U('search'),          value = 'body_search'},
              {label = _U('handcuff'),        value = 'handcuff'},
              {label = _U('drag'),          value = 'drag'},
              {label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
              --{label = _U('fine'),            value = 'fine'},
			  {label = ("amendes"), 		  value = 'billing'},
			  {label = _U('codedmv'),         value = 'codedmv'},
			  {label = _U('codedrive'),       value = 'codedrive'},
			  {label = _U('codedrivebike'),   value = 'codedrivebike'},
			  {label = _U('codedrivetruck'),  value = 'codedrivetruck'},
			  {label = _U('weaponlicense'),  value = 'weaponlicense'},
        
            },
          },
          function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

              if data2.current.value == 'identity_card' then
                OpenIdentityCardMenu(player)
              end

              if data2.current.value == 'body_search' then
                OpenBodySearchMenu(player)
              end

              if data2.current.value == 'handcuff' then
                TriggerServerEvent('esx_fib:handcuff', GetPlayerServerId(player))
              end

              if data2.current.value == 'drag' then
                TriggerServerEvent('esx_fib:drag', GetPlayerServerId(player))
              end

              if data2.current.value == 'put_in_vehicle' then
                TriggerServerEvent('esx_fib:putInVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'out_the_vehicle' then
                  TriggerServerEvent('esx_fib:OutVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'fine' then
                OpenFineMenu(player)
              end
			  
		if data.current.value == 'billing' then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'billing',
					{
						title = 'Montant de la facture'
					},
					function(data, menu)
						local amount = tonumber(data.value)
						if amount == nil then
							ESX.ShowNotification('Montant invalide')
						else							
							menu.close()							
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification('Aucun joueur à proximité')
							else
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_fib', 'Fib', amount)
							end
						end
					end,
				function(data, menu)
					menu.close()
				end
				)
			end	  
        
        if data2.current.value == 'code' then
                TriggerServerEvent('esx_fib:codedmv', GetPlayerServerId(player))
              end
        
        if data2.current.value == 'codedrive' then
                TriggerServerEvent('esx_fib:codedrive', GetPlayerServerId(player))
              end
        
        if data2.current.value == 'codedrivebike' then
                TriggerServerEvent('esx_fib:codedrivebike', GetPlayerServerId(player))
              end
        
        if data2.current.value == 'codedrivetruck' then
                TriggerServerEvent('esx_fib:codedrivetruck', GetPlayerServerId(player))
              end 
        
        if data2.current.value == 'weaponlicense' then
                TriggerServerEvent('esx_fib:weaponlicense', GetPlayerServerId(player))
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

      if data.current.value == 'vehicle_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'vehicle_interaction',
          {
            title    = _U('vehicle_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('vehicle_info'), value = 'vehicle_infos'},
              {label = _U('pick_lock'),    value = 'hijack_vehicle'},
            },
          },
          function(data2, menu2)

            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local vehicle   = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

            if DoesEntityExist(vehicle) then

              local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

              if data2.current.value == 'vehicle_infos' then
                OpenVehicleInfosMenu(vehicleData)
              end

              if data2.current.value == 'hijack_vehicle' then

                local playerPed = GetPlayerPed(-1)
                local coords    = GetEntityCoords(playerPed)

                if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

                  local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  3.0,  0,  71)

                  if DoesEntityExist(vehicle) then

                    Citizen.CreateThread(function()

                      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

                      Wait(20000)

                      ClearPedTasksImmediately(playerPed)

                      SetVehicleDoorsLocked(vehicle, 1)
                      SetVehicleDoorsLockedForAllPlayers(vehicle, false)

                      TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))

                    end)

                  end

                end

              end

            else
              ESX.ShowNotification(_U('no_vehicles_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

      if data.current.value == 'object_spawner' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('traffic_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('cone'),     value = 'prop_roadcone02a'},
              {label = _U('barrier'), value = 'prop_barrier_work06a'},
              {label = _U('spikestrips'),    value = 'p_ld_stinger_s'},
              {label = _U('box'),   value = 'prop_boxpile_07d'},
              {label = _U('cash'),   value = 'hei_prop_cash_crate_half_full'}
            },
          },
          function(data2, menu2)


            local model     = data2.current.value
            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = table.unpack(coords + forward * 1.0)

            if model == 'prop_roadcone02a' then
              z = z - 2.0
            end

            ESX.Game.SpawnObject(model, {
              x = x,
              y = y,
              z = z
            }, function(obj)
              SetEntityHeading(obj, GetEntityHeading(playerPed))
              PlaceObjectOnGroundProperly(obj)
            end)

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

    end,
    function(data, menu)

      menu.close()

    end
  )

end

function OpenIdentityCardMenu(player)

  if Config.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_fib:getOtherPlayerData', function(data)

      --local jobLabel    = nil
      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      --local idLabel     = nil

      --[[if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end]]--

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Masculin'
        else
          sex = 'Feminin'
        end
        sexLabel = 'Sexe : ' .. sex
      else
        sexLabel = 'Sexe : Inconnue'
      end

      if data.dob ~= nil then
        dobLabel = 'Date de naissance : ' .. data.dob
      else
        dobLabel = 'Date de naissance : Inconnue'
      end

      if data.height ~= nil then
        heightLabel = 'Taille : ' .. data.height
      else
        heightLabel = 'Taille : Inconnue'
      end

      --[[if data.name ~= nil then
        idLabel = 'ID : ' .. data.name
      else
        idLabel = 'ID : Inconnue'
      end]]--

      local elements = {
        {label = _U('name') .. data.firstname .. " " .. data.lastname, value = nil},
        {label = sexLabel,    value = nil},
        {label = dobLabel,    value = nil},
        {label = heightLabel, value = nil},
        --{label = jobLabel,    value = nil}, 
        --{label = idLabel,     value = nil},
      }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

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

  else

    ESX.TriggerServerCallback('esx_fib:getOtherPlayerData', function(data)

      --[[local jobLabel = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

        local elements = {
          {label = _U('name') .. data.name, value = nil},
          {label = jobLabel,              value = nil},
        }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end]]--

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

function OpenBodySearchMenu(player)

  ESX.TriggerServerCallback('esx_fib:getOtherPlayerData', function(data)

    local elements = {}

    local blackMoney = 0

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end

    table.insert(elements, {
      label          = _U('confiscate_dirty') .. blackMoney,
      value          = 'black_money',
      itemType       = 'item_account',
      amount         = blackMoney
    })

    table.insert(elements, {label = '--- Armes ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
        value          = data.weapons[i].name,
        itemType       = 'item_weapon',
        amount         = data.ammo,
      })
    end

    table.insert(elements, {label = _U('inventory_label'), value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value          = data.inventory[i].name,
          itemType       = 'item_standard',
          amount         = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
        title    = _U('search'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount   = data.current.amount

        if data.current.value ~= nil then

          TriggerServerEvent('esx_fib:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)

          OpenBodySearchMenu(player)

        end

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end

function OpenFineMenu(player)

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'fine',
    {
      title    = _U('fine'),
      align    = 'top-left',
      elements = {
        {label = _U('traffic_offense'),   value = 0},
        {label = _U('minor_offense'),     value = 1},
        {label = _U('average_offense'),   value = 2},
        {label = _U('major_offense'),     value = 3}
      },
    },
    function(data, menu)

      OpenFineCategoryMenu(player, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenFineCategoryMenu(player, category)

  ESX.TriggerServerCallback('esx_fib:getFineList', function(fines)

    local elements = {}

    for i=1, #fines, 1 do
      table.insert(elements, {
        label     = fines[i].label .. ' $' .. fines[i].amount,
        value     = fines[i].id,
        amount    = fines[i].amount,
        fineLabel = fines[i].label
      })
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fine_category',
      {
        title    = _U('fine'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local label  = data.current.fineLabel
        local amount = data.current.amount

        menu.close()

        if Config.EnablePlayerManagement then
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_fib', _U('fine_total') .. label, amount)
        else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total') .. label, amount)
        end

        ESX.SetTimeout(300, function()
          OpenFineCategoryMenu(player, category)
        end)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, category)

end

function OpenVehicleInfosMenu(vehicleData)

  ESX.TriggerServerCallback('esx_fib:getVehicleInfos', function(infos)

    local elements = {}

    table.insert(elements, {label = _U('plate') .. infos.plate, value = nil})

    if infos.owner == nil then
      table.insert(elements, {label = _U('owner_unknown'), value = nil})
    else
      table.insert(elements, {label = _U('owner') .. infos.owner, value = nil})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_infos',
      {
        title    = _U('vehicle_info'),
        align    = 'top-left',
        elements = elements,
      },
      nil,
      function(data, menu)
        menu.close()
      end
    )

  end, vehicleData.plate)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_fib:getArmoryWeapons', function(weapons)

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

        ESX.TriggerServerCallback('esx_fib:removeArmoryWeapon', function()
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

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
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

      ESX.TriggerServerCallback('esx_fib:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenBuyWeaponsMenu(station)

  ESX.TriggerServerCallback('esx_fib:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #Config.FibStations[station].AuthorizedWeapons, 1 do

      local weapon = Config.FibStations[station].AuthorizedWeapons[i]
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

        ESX.TriggerServerCallback('esx_fib:buy', function(hasEnoughMoney)

          if hasEnoughMoney then
            ESX.TriggerServerCallback('esx_fib:addArmoryWeapon', function()
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

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_fib:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('fib_stock'),
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
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_fib:getStockItem', itemName, count)
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

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_fib:getPlayerInventory', function(inventory)

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
              OpenPutStocksMenu()

              TriggerServerEvent('esx_fib:putStockItems', itemName, count)
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
    name       = 'Fib',
    number     = 'fib',
    base64Icon = 'data:image/png;base64,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'
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_fib:hasEnteredMarker', function(station, part, partNum)

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
  
  if part == 'VehicleSpawner1' then
		CurrentAction     = 'menu_vehicle_spawner1'
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

AddEventHandler('esx_fib:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

AddEventHandler('esx_fib:hasEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  if PlayerData.job ~= nil and PlayerData.job.name == 'fib' and not IsPedInAnyVehicle(playerPed, false) then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = _U('remove_object')
    CurrentActionData = {entity = entity}
  end

  if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed)

      for i=0, 7, 1 do
        SetVehicleTyreBurst(vehicle,  i,  true,  1000)
      end

    end

  end

end)

AddEventHandler('esx_fib:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)

RegisterNetEvent('esx_fib:handcuff')
AddEventHandler('esx_fib:handcuff', function()

  IsHandcuffed    = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Wait(100)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)

    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)

    end

  end)
end)

RegisterNetEvent('esx_fib:drag')
AddEventHandler('esx_fib:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = GetPlayerPed(-1)
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(GetPlayerPed(-1), true, false)
      end
    end
  end
end)

RegisterNetEvent('esx_fib:putInVehicle')
AddEventHandler('esx_fib:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)

RegisterNetEvent('esx_fib:OutVehicle')
AddEventHandler('esx_fib:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

-- Handcuff
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      DisableControlAction(0, 30,  true) -- MoveLeftRight
      DisableControlAction(0, 31,  true) -- MoveUpDown
      DisableControlAction(0, 1,    true) -- LookLeftRight
      DisableControlAction(0, 2,    true) -- LookUpDown
      DisableControlAction(0, 25,   true) -- Input Aim
      DisableControlAction(0, 106,  true) -- Vehicle Mouse Control Override
      DisableControlAction(0, 24,   true) -- Input Attack
      DisableControlAction(0, 140,  true) -- Melee Attack Alternate
      DisableControlAction(0, 141,  true) -- Melee Attack Alternate
      DisableControlAction(0, 142,  true) -- Melee Attack Alternate
      DisableControlAction(0, 257,  true) -- Input Attack 2
      DisableControlAction(0, 263,  true) -- Input Melee Attack
      DisableControlAction(0, 264,  true) -- Input Melee Attack 2
      DisableControlAction(0, 12,   true) -- Weapon Wheel Up Down
      DisableControlAction(0, 14,   true) -- Weapon Wheel Next
      DisableControlAction(0, 15,   true) -- Weapon Wheel Prev
      DisableControlAction(0, 16,   true) -- Select Next Weapon
      DisableControlAction(0, 17,   true) -- Select Prev Weapon
	  DisableControlAction(0, 322,  true)
	  DisableControlAction(0, 288,  true)
	  DisableControlAction(0, 289,  true)
	  DisableControlAction(0, 170,  true)
	  DisableControlAction(0, 166,  true)
	  DisableControlAction(0, 167,  true)
	  DisableControlAction(0, 168,  true)
	  DisableControlAction(0, 169,  true)
	  DisableControlAction(0, 56,   true)
	  DisableControlAction(0, 57,   true)
	  DisableControlAction(0, 23,   true)
	  DisableControlAction(0, 32,   true)
	  DisableControlAction(0, 20,   true)
	  DisableControlAction(0, 73,   true)
	  DisableControlAction(0, 29,   true)
	  DisableControlAction(0, 37,   true)
    
    end
  end
end)

-- Create blips
Citizen.CreateThread(function()

  for k,v in pairs(Config.FibStations) do

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

-- Display markers
Citizen.CreateThread(function()
  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'fib' then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)

      for k,v in pairs(Config.FibStations) do

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
		
		for i=1, #v.Vehicles1, 1 do
		  if GetDistanceBetweenCoords(coords,  v.Vehicles1[i].Spawner1.x,  v.Vehicles1[i].Spawner1.y,  v.Vehicles1[i].Spawner1.z,  true) < Config.DrawDistance then
			DrawMarker(Config.MarkerType, v.Vehicles1[i].Spawner1.x, v.Vehicles1[i].Spawner1.y, v.Vehicles1[i].Spawner1.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
		  end
		end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColorDel.r, Config.MarkerColorDel.g, Config.MarkerColorDel.b, 100, false, true, 2, false, false, false, false)
          end
        end
		
		for i=1, #v.VehicleDeleters1, 1 do
		  if GetDistanceBetweenCoords(coords,  v.VehicleDeleters1[i].x,  v.VehicleDeleters1[i].y,  v.VehicleDeleters1[i].z,  true) < Config.DrawDistance then
			DrawMarker(Config.MarkerType, v.VehicleDeleters1[i].x, v.VehicleDeleters1[i].y, v.VehicleDeleters1[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSizeDel.x, Config.MarkerSizeDel.y, Config.MarkerSizeDel.z, Config.MarkerColorDel.r, Config.MarkerColorDel.g, Config.MarkerColorDel.b, 100, false, true, 2, false, false, false, false)
		  end
		end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'fib' and PlayerData.job.grade_name == 'boss' then

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

-- Enter / Exit marker events
Citizen.CreateThread(function()

  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'fib' then

      local playerPed      = GetPlayerPed(-1)
      local coords         = GetEntityCoords(playerPed)
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config.FibStations) do

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

        for i=1, #v.Vehicles1, 1 do

		  if GetDistanceBetweenCoords(coords,  v.Vehicles1[i].Spawner1.x,  v.Vehicles1[i].Spawner1.y,  v.Vehicles1[i].Spawner1.z,  true) < Config.MarkerSize.x then
			isInMarker     = true
			currentStation = k
			currentPart    = 'VehicleSpawner1'
			currentPartNum = i
		  end

		  if GetDistanceBetweenCoords(coords,  v.Vehicles1[i].SpawnPoint1.x,  v.Vehicles1[i].SpawnPoint1.y,  v.Vehicles1[i].SpawnPoint1.z,  true) < Config.MarkerSize.x then
			isInMarker     = true
			currentStation = k
			currentPart    = 'VehicleSpawnPoint1'
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
		
		for i=1, #v.VehicleDeleters1, 1 do
		  if GetDistanceBetweenCoords(coords,  v.VehicleDeleters1[i].x,  v.VehicleDeleters1[i].y,  v.VehicleDeleters1[i].z,  true) < Config.MarkerSizeDel.x then
			isInMarker     = true
			currentStation = k
			currentPart    = 'VehicleDeleter'
			currentPartNum = i
		  end
		end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'fib' and PlayerData.job.grade_name == 'boss' then

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
          TriggerEvent('esx_fib:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_fib:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_fib:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

    end

  end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()

  local trackedEntities = {
    'prop_roadcone02a',
    'prop_barrier_work06a',
    'p_ld_stinger_s',
    'prop_boxpile_07d',
    'hei_prop_cash_crate_half_full'
  }

  while true do

    Citizen.Wait(0)

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    local closestDistance = -1
    local closestEntity   = nil

    for i=1, #trackedEntities, 1 do

      local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)

      if DoesEntityExist(object) then

        local objCoords = GetEntityCoords(object)
        local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)

        if closestDistance == -1 or closestDistance > distance then
          closestDistance = distance
          closestEntity   = object
        end

      end

    end

    if closestDistance ~= -1 and closestDistance <= 3.0 then

      if LastEntity ~= closestEntity then
        TriggerEvent('esx_fib:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end

    else

      if LastEntity ~= nil then
        TriggerEvent('esx_fib:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end

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

      if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'fib' and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
        end
		
		if CurrentAction == 'menu_vehicle_spawner1' then
		  OpenVehicle1SpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
		end

        if CurrentAction == 'delete_vehicle' then

          if Config.EnableSocietyOwnedVehicles then

            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'fib', vehicleProps)

          else

            if
              GetEntityModel(vehicle) == GetHashKey('fbi') or
              GetEntityModel(vehicle) == GetHashKey('fbi2') or
              GetEntityModel(vehicle) == GetHashKey('riot')	or
              GetEntityModel(vehicle) == GetHashKey('schafter5')			  
            then
              TriggerServerEvent('esx_service:disableService', 'fib')
            end

          end

          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'fib', function(data, menu)

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
	
	if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'fib' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'fib_actions') and (GetGameTimer() - GUI.Time) > 150 then
      OpenFibActionsMenu()
      GUI.Time = GetGameTimer()
    end

  end
end) 


local TeleportFromTo = {

	["FIB"] = {
		positionFrom = { ['x'] = 136.18350219727, ['y'] = -761.86651611328, ['z'] = 242.15200805664, nom = "Descendre au rdc"},
		positionTo = { ['x'] = 138.98336791992, ['y'] = -762.68725585938, ['z'] = 45.752006530762, nom = "Monter au bureau"},
	},
	
	["GARAGE"] = {
		positionFrom = { ['x'] = 136.0496673584, ['y'] = -761.77819824219, ['z'] = 45.752021789551, nom = "Descendre au garage"},
		positionTo = { ['x'] = 144.23973083496, ['y'] = -689.15106201172, ['z'] = 33.128112792969, nom = "Monter au rdc"},
	},

	["HELICO"] = {
		positionFrom = { ['x'] = 138.22854614258, ['y'] = -764.94403076172, ['z'] = 242.15211486816, nom = "Monter sur le toit"},
		positionTo = { ['x'] = -67.257919311523, ['y'] = -821.841796875, ['z'] = 321.28735351563, nom = "Descendre au bureau"}, 
	},	
	
}	

Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing


function Drawing.draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,r, g, b, a)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function Drawing.drawMissionText(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

------------------------------------------
------------------------------------------
------Modifier text-----------------------
------------------------------------------
------------------------------------------
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	--DisplayHelpTextFromStringLabel(0, 0, 0, -1)			---A 0 Enleve le son de la notif
end
------------------------------------------
------------------------------------------
------Modifier text-----------------------
------------------------------------------
------------------------------------------

function msginf(msg, duree)
    duree = duree or 500
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(duree, 1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		
		for k, j in pairs(TeleportFromTo) do
		
			--msginf(k .. " " .. tostring(j.positionFrom.x), 15000)
			if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 150.0) then
				DrawMarker(1, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 0.501, 117,202,93,255, 0, 0, 0,0)
				if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 5.0)then
					Drawing.draw3DText(j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1.100, j.positionFrom.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
					if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 1.0)then
						ClearPrints()
						DisplayHelpText("Appuyez sur ~INPUT_PICKUP~ pour ~b~".. j.positionFrom.nom,1, 1, 0.5, 0.8, 0.9, 255, 255, 255, 255)
						DrawSubtitleTimed(2000, 1)
						if IsControlJustPressed(1, 38) then
							DoScreenFadeOut(1000)
							Citizen.Wait(2000)
							SetEntityCoords(GetPlayerPed(-1), j.positionTo.x, j.positionTo.y, j.positionTo.z - 1)
							DoScreenFadeIn(1000)
						end
					end
				end
			end
			
			if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 150.0) then
				DrawMarker(1, j.positionTo.x, j.positionTo.y, j.positionTo.z - 1, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 0.501, 117,202,93,255, 0, 0, 0,0)
				if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 5.0)then
					Drawing.draw3DText(j.positionTo.x, j.positionTo.y, j.positionTo.z - 1.100, j.positionTo.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
					if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 1.0)then
						ClearPrints()
						DisplayHelpText("Appuyez sur ~INPUT_PICKUP~ pour ~r~".. j.positionTo.nom,1, 1, 0.5, 0.8, 0.9, 255, 255, 255, 255)
						DrawSubtitleTimed(2000, 1)
						if IsControlJustPressed(1, 38) then
							DoScreenFadeOut(1000)
							Citizen.Wait(2000)
							SetEntityCoords(GetPlayerPed(-1), j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1)
							DoScreenFadeIn(1000)
						end
					end
				end
			end
		end
	end
end)