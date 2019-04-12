local Keys = {["F6"] = 167, ["E"] = 38, ["DELETE"] = 178}
local isLoading         = true

ESX                     = nil
local playerData        = nil
local coords            = nil
local inVehicle         = false

local zoneList          = {} -- { {enable, gps, markerD, blipD, blip, name}, ...}
local alreadyInZone     = false
local lastZone          = nil

local currentAction     = nil
local currentActionMsg  = ''
local currentActionData = {}

local isWorking         = false
local isRunning         = false
local currentRun        = {}

-- debug msg
function printDebug(msg)
  if Config.debug then print(Config.debugPrint .. ' ' .. msg) end
end

-- init
Citizen.CreateThread(function()
  local startLoad = GetGameTimer()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  -- load player
  while playerData == nil do
    Citizen.Wait(1)
    playerData = ESX.GetPlayerData()
  end
  while playerData.job == nil do
    Citizen.Wait(1)
    playerData = ESX.GetPlayerData()
  end
  while playerData.job.name == nil do
    Citizen.Wait(1)
    playerData = ESX.GetPlayerData()
  end
  coords     = GetEntityCoords(GetPlayerPed(-1))
  inVehicle  = false
  -- load zone
  for k,v in pairs(Config.zones) do
    local zone = v
    zone.name = k
    if k == 'cloakRoom' then zone.blip = drawBlip(zone.gps, zone.blipD)
    else zone.blip = nil end
    table.insert(zoneList, zone)
  end
  -- init end
  isLoading = false
  printDebug('Loaded in ' .. tostring(GetGameTimer() - startLoad) .. 'ms')
end)
RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
  local specialContact = {
    name       = Config.companyName,
    number     = Config.jobName,
    base64Icon = 'data:image/png;base64,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'
  }
  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- MAIN
Citizen.CreateThread(function()
  while isLoading do Citizen.Wait(10) end
  while true do
    Citizen.Wait(10)
    -- refresh playerData ...
    local playerPed = GetPlayerPed(-1)
    playerData = ESX.GetPlayerData()
    coords     = GetEntityCoords(playerPed)
    inVehicle  = IsPedInAnyVehicle(playerPed, 0)
    -- quit job
    if isWorking and playerData.job.name ~= Config.jobName then isWorking = false end
    if isRunning and playerData.job.name ~= Config.jobName then isRunning = false end
    -- refresh zone
    for i=1, #zoneList, 1 do
      -- disable zone for old employees
      if playerData.job.name ~= Config.jobName and zoneList[i].enable then zoneList[i].enable = false
      -- enable cloakroom zone for new employees
      elseif playerData.job.name == Config.jobName and not zoneList[i].enable and zoneList[i].name == 'cloakRoom' then zoneList[i].enable = true end
    end
    -- others
  end
end)

-- blip
function drawBlip(gps, blipData)
  if not (blipData.name == nil) then printDebug('drawBlip: '.. blipData.name)
  else printDebug('drawBlip: market') end
  
  local blip = AddBlipForCoord(gps.x, gps.y, gps.z)
  if not (blipData.sprite == nil)  then SetBlipSprite (blip, blipData.sprite)     end
  if not (blipData.display == nil) then SetBlipDisplay(blip, blipData.display)    end
  if not (blipData.scale == nil)   then SetBlipScale  (blip, blipData.scale)      end
  if not (blipData.color == nil)   then SetBlipColour (blip, blipData.color)      end
  if not (blipData.range == nil)   then SetBlipAsShortRange(blip, blipData.range) end
  if not (blipData.route == nil)   then SetBlipRoute(blip, blipData.route)        end
  if not (blipData.name == nil)    then
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipData.name)
    EndTextCommandSetBlipName(blip)
  end
  return blip
end
Citizen.CreateThread(function()
  while isLoading do Citizen.Wait(10) end
  while true do
    Citizen.Wait(1000)
    for i=1, #zoneList, 1 do
      -- for employees
      if playerData.job.name == Config.jobName then
        -- draw blip
        if zoneList[i].enable and not DoesBlipExist(zoneList[i].blip) then zoneList[i].blip = drawBlip(zoneList[i].gps, zoneList[i].blipD)
        -- remove blip execpt cloakroom
        elseif not zoneList[i].enable and DoesBlipExist(zoneList[i].blip) and zoneList[i].name ~= 'cloakRoom' then 
          RemoveBlip(zoneList[i].blip)
          zoneList[i].blip = nil
          printDebug('remove Blip: '.. zoneList[i].name)
        end
      -- for civil
      else
        -- remove blip execpt cloakroom
        if zoneList[i].name ~= 'cloakRoom' and DoesBlipExist(zoneList[i].blip) then 
          RemoveBlip(zoneList[i].blip)
          zoneList[i].blip = nil
          printDebug('remove Blip: '.. zoneList[i].name)
        end
      end
    end
  end
end)

-- marker
function showMarker(zone)
  DrawMarker(zone.markerD.type, 
    zone.gps.x, zone.gps.y, zone.gps.z, 
    0.0, 0.0, 0.0, 
    0, 0.0, 0.0, 
    zone.markerD.size.x , zone.markerD.size.y , zone.markerD.size.z, 
    zone.markerD.color.r, zone.markerD.color.g, zone.markerD.color.b, 100, 
    false, false, 2, false, false, false, false
  )
end
Citizen.CreateThread(function()
  while isLoading do Citizen.Wait(10) end
  while true do
    Citizen.Wait(0)
    if playerData.job.name == Config.jobName then
      for i=1, #zoneList, 1 do
        if zoneList[i].enable and GetDistanceBetweenCoords(coords, zoneList[i].gps.x, zoneList[i].gps.y, zoneList[i].gps.z, true) < zoneList[i].markerD.drawDistance then
          showMarker(zoneList[i])
        end
      end
    end
  end
end)

-- enter/exit zone
AddEventHandler('esx_brinks:hasEnteredMarker', function(zone)
  printDebug('hasEnteredMarker: ' .. zone.name)
  if zone.name == 'cloakRoom' then
    currentAction = 'brinksMenu'
    currentActionMsg = _U('cloakroom_action')
    currentActionData = {}
  elseif zone.name == 'vehicleSpawner' then
    currentAction = 'vehiclespawn_menu'
    currentActionMsg = _U('vehicleSpawner_action')
    currentActionData = {}
  elseif zone.name == 'market' then
    currentAction = 'harvestRun'
    currentActionMsg = _U('market_action')
    currentActionData = {}
  elseif zone.name == 'bank' then
    currentAction = 'sellRun'
    currentActionMsg = _U('bank_action')
    currentActionData = {}
  elseif zone.name == 'northBank' then
    currentAction = 'collectWeekly'
    currentActionMsg = _U('weeklyHarvest_action')
    currentActionData = {}
  elseif zone.name == 'unionDepository' then
    currentAction = 'destructWeekly'
    currentActionMsg = _U('weeklyDestruct_action')
    currentActionData = {}
  elseif zone.name == 'vehicleDeleter' then
    if inVehicle then
      currentAction = 'delete_vehicle'
      currentActionMsg = _U('vehicleDeleter_action')
      currentActionData = {}
    end
  end
end)
AddEventHandler('esx_brinks:hasExitedMarker', function(zone)
  printDebug('hasExitedMarker: ' .. zone.name)
  if zone.name == 'market' then TriggerServerEvent('esx_brinks:stopHarvestRun') 
  elseif zone.name == 'bank' then TriggerServerEvent('esx_brinks:stopSellRun') 
  elseif zone.name == 'northBank' then TriggerServerEvent('esx_brinks:stopWeeklyCollect') 
  elseif zone.name == 'unionDepository' then TriggerServerEvent('esx_brinks:stopWeeklyDestruct') end
  currentAction    = nil
  currentActionMsg = ''
  ESX.UI.Menu.CloseAll()
end)
Citizen.CreateThread(function()
  while isLoading do Citizen.Wait(10) end
  while true do
    Citizen.Wait(0)
    if playerData.job.name == Config.jobName then
      local isInMarker  = false
      local currentZone = nil
      for i=1, #zoneList, 1 do
        if zoneList[i].enable and GetDistanceBetweenCoords(coords, zoneList[i].gps.x, zoneList[i].gps.y, zoneList[i].gps.z, true) < zoneList[i].markerD.size.x * 0.75 then
          isInMarker    = true
          currentZone   = zoneList[i]
        end
      end
      if isInMarker and not alreadyInZone then
        alreadyInZone = true
        lastZone      = currentZone
        TriggerEvent('esx_brinks:hasEnteredMarker', currentZone)
      end
      if not isInMarker and alreadyInZone then
        alreadyInZone = false
        TriggerEvent('esx_brinks:hasExitedMarker', lastZone)
      end
    end
  end
end)

-- action
Citizen.CreateThread(function()
  while isLoading do Citizen.Wait(10) end
  while true do
    Citizen.Wait(0)
    if IsControlJustReleased(1, Keys["F6"]) and playerData.job.name == Config.jobName then openMobileBrinksMenu() end
    if currentAction ~= nil then
      SetTextComponentFormat('STRING')
      AddTextComponentString(currentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, - 1)
      if IsControlJustReleased(1, Keys["E"]) then
        if currentAction     == 'brinksMenu' then
          if not inVehicle then openBrinksActionsMenu() 
          else ESX.ShowNotification(_U('in_vehicle')) end
        elseif currentAction == 'vehiclespawn_menu' then
          if not inVehicle then vehicleMenu() 
          else ESX.ShowNotification(_U('in_vehicle')) end
        elseif currentAction == 'harvestRun' then
          if not inVehicle then
            TriggerServerEvent('esx_brinks:startHarvestRun')
          else ESX.ShowNotification(_U('in_vehicle')) end
        elseif currentAction == 'sellRun' then
          if not inVehicle then TriggerServerEvent('esx_brinks:startSellRun')
          else ESX.ShowNotification(_U('in_vehicle')) end
        elseif currentAction == 'collectWeekly' then
          if not inVehicle then 
            if playerData.job.grade >= Config.weeklyMinGrade then TriggerServerEvent('esx_brinks:startWeeklyCollect')
            else ESX.ShowNotification(_U('bad_grade')) end 
          else ESX.ShowNotification(_U('in_vehicle')) end
        elseif currentAction == 'destructWeekly' then
          if not inVehicle then 
            if playerData.job.grade >= Config.weeklyMinGrade then TriggerServerEvent('esx_brinks:startWeeklyDestruct')
            else ESX.ShowNotification(_U('bad_grade')) end 
          else ESX.ShowNotification(_U('in_vehicle')) end
        elseif currentAction == 'delete_vehicle' then
          if inVehicle then
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            local hash = GetEntityModel(vehicle)
            local plate = string.gsub(GetVehicleNumberPlateText(vehicle), " ", "")
            if string.find (plate, Config.platePrefix) then
              if hash == GetHashKey(Config.vehicles.truck.hash) or hash == GetHashKey(Config.vehicles.bossCar.hash) then
                if GetVehicleEngineHealth(vehicle) <= 500 or GetVehicleBodyHealth(vehicle) <= 500 then ESX.ShowNotification(_U('vehicle_broken'))
                else DeleteVehicle(vehicle) end
              end
            else ESX.ShowNotification(_U('bad_vehicle')) end
          end
        end
        currentAction = nil
      end
    end
  end
end)

-- take service
function takeService(work, value)
  printDebug('takeService ' .. value)
  isWorking = work
  -- enable/disable zone except market
  for i=1, #zoneList, 1 do
    if zoneList[i].name == 'vehicleSpawner' or 
       zoneList[i].name == 'vehicleDeleter' or 
       zoneList[i].name == 'bank' or 
       zoneList[i].name == 'northBank' or 
       zoneList[i].name == 'unionDepository'
    then 
       zoneList[i].enable = isWorking
    end
  end
  -- take service
  if isWorking then
    local playerPed = GetPlayerPed(-1)
    TriggerEvent('skinchanger:getSkin', function(skin)
      if skin.sex == 0 then
        if Config.uniforms[value].male ~= nil then TriggerEvent('skinchanger:loadClothes', skin, Config.uniforms[value].male)
        else ESX.ShowNotification(_U('no_outfit')) end
      else
        if Config.uniforms[value].female ~= nil then TriggerEvent('skinchanger:loadClothes', skin, Config.uniforms[value].female)
        else ESX.ShowNotification(_U('no_outfit')) end
      end
    end)
    -- SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
  -- end service
  else
    -- disable market
    for i=1, #zoneList, 1 do
      if zoneList[i].name == 'market' then 
        zoneList[i].enable = false
        isRunning = false
        break
      end
    end
    -- change wear
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
      local model = nil
      if skin.sex == 0 then model = GetHashKey("mp_m_freemode_01")
      else model = GetHashKey("mp_f_freemode_01") end
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
      -- SetPedArmour(playerPed, 0)
      ClearPedBloodDamage(playerPed)
      ResetPedVisibleDamage(playerPed)
      ClearPedLastWeaponDamage(playerPed)
    end)
  end
end

-- menu brinks
function openBrinksActionsMenu()
  printDebug('openBrinksActionsMenu')
  local elements = {}  
  if isWorking then table.insert(elements, {label = _U('end_service'), value = 'citizen_wear'})
  else table.insert(elements, {label = _U('take_service'), value = 'job_wear'}) end  
  if playerData.job.grade >= Config.storageMinGrade then 
    table.insert(elements, {label = _U('storage'),   value = 'storage'})
  end
  if playerData.job.grade >= Config.manageMinGrade then table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'}) end
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'brinks_actions',
    {
      title    = _U('cloakroom_blip'),
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'citizen_wear' then
        menu.close()
        takeService(false, data.current.value)
        openBrinksActionsMenu()
        ESX.ShowNotification(_U('end_service_notif'))
      elseif data.current.value == 'job_wear' then
        menu.close()
        takeService(true, data.current.value)
        openBrinksActionsMenu()
        ESX.ShowNotification(_U('take_service_notif'))
        ESX.ShowNotification(_U('start_job'))
      elseif data.current.value == 'storage' then
        menu.close()
        openBrinksStorageMenu()
      elseif data.current.value == 'boss_actions' then
        TriggerEvent('esx_society:openBossMenu', 'brinks', function(data, menu)
          menu.close()
        end)
      end
    end,
    function(data, menu)
      menu.close()
      TriggerEvent('esx_brinks:hasEnteredMarker', lastZone)
    end
  )
end
function openBrinksStorageMenu()
  printDebug('openBrinksStorageMenu')
  local elements = {}    
  table.insert(elements, {label = _U('deposit_stock'),   value = 'put_stock'})
  table.insert(elements, {label = _U('withdraw_stock'),  value = 'get_stock'})
  if playerData.job.grade >= Config.armoryMinGrade then 
    table.insert(elements, {label = _U('deposit_weapon'),   value = 'put_weapon'})
    table.insert(elements, {label = _U('withdraw_weapon'),  value = 'get_weapon'})
  end
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'brinks_storage',
    {
      title    = _U('storage'),
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'put_stock' then
        openPutStocksMenu()
      elseif data.current.value == 'get_stock' then
        openGetStocksMenu()
      elseif data.current.value == 'put_weapon' then
        openPutWeaponMenu()
      elseif data.current.value == 'get_weapon' then
        openGetWeaponMenu()
      end
    end,
    function(data, menu)
      menu.close()
      openBrinksActionsMenu()
    end
  )
  
end
function openGetStocksMenu()
  printDebug('openGetStocksMenu')
  ESX.TriggerServerCallback('esx_brinks:getStockItems', function(items)
    local elements = {}
    for i=1, #items, 1 do
      if items[i].count ~= 0 then
        table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
      end
    end
    if #elements == 0 then table.insert(elements, {label = 'empty', type = 'empty', value = 'empty'}) end
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'stocks_menu',
    {
      title    = _U('withdraw_stock'),
      elements = elements
    },
    function(data, menu)
      if data.current.value ~= 'empty' then
        local itemName = data.current.value
        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)
            local count = tonumber(data2.value)
            if count == nil then
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              TriggerServerEvent('esx_brinks:getStockItem', itemName, count)
              openGetStocksMenu()
            end
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
  end)
end
function openPutStocksMenu()
  printDebug('openPutStocksMenu')
  ESX.TriggerServerCallback('esx_brinks:getPlayerInventory', function(inventory)
    local elements = {}
    for i=1, #inventory.items, 1 do
      local item = inventory.items[i]
      if item.count > 0 then table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name}) end
    end
    if #elements == 0 then table.insert(elements, {label = 'empty', type = 'empty', value = 'empty'}) end
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
      title    = _U('deposit_stock'),
      elements = elements
      },
      function(data, menu)
        if data.current.value ~= 'empty' then
          local itemName = data.current.value
          ESX.UI.Menu.Open(
            'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
            {
              title = _U('quantity')
            },
            function(data2, menu2)
              local count = tonumber(data2.value)
              if count == nil then
                ESX.ShowNotification(_U('invalid_quantity'))
              else
                menu2.close()
                menu.close()
                TriggerServerEvent('esx_brinks:putStockItems', itemName, count)
                openPutStocksMenu()
              end
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
  end)
end
function openGetWeaponMenu()
  printDebug('openPutWeaponMenu')
  ESX.TriggerServerCallback('esx_brinks:getArmoryWeapons', function(weapons)
    local elements = {}
    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end
    if #elements == 0 then table.insert(elements, {label = 'empty', value = 'empty'}) end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon',
    {
      title    = _U('withdraw_weapon'),
      align    = 'top-left',
      elements = elements
    }, 
    function(data, menu)
      if data.current.value ~= 'empty' then
        menu.close()
        ESX.TriggerServerCallback('esx_brinks:removeArmoryWeapon', function() openGetWeaponMenu() end, data.current.value)
      end
    end, 
    function(data, menu)
      menu.close()
    end)
  end)

end
function openPutWeaponMenu()
  printDebug('openPutWeaponMenu')
  local elements   = {}
  local playerPed  = PlayerPedId()
  local weaponList = ESX.GetWeaponList()
  for i=1, #weaponList, 1 do
    local weaponHash = GetHashKey(weaponList[i].name)
    if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end
  end
  if #elements == 0 then table.insert(elements, {label = 'empty', value = 'empty'}) end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',
  {
    title    = _U('deposit_weapon'),
    align    = 'top-left',
    elements = elements
  }, 
  function(data, menu)
    if data.current.value ~= 'empty' then
      menu.close()
      ESX.TriggerServerCallback('esx_brinks:addArmoryWeapon', function() openPutWeaponMenu() end, data.current.value, true)
    end
  end, function(data, menu)
    menu.close()
  end)
end

-- menu Vehicle
function vehicleMenu()
  local elements = { {label = Config.vehicles.truck.label, value = Config.vehicles.truck} }
  if playerData.job.grade >= Config.armoryMinGrade then table.insert(elements, {label = Config.vehicles.bossCar.label, value = Config.vehicles.bossCar})end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle',
    {
      title = _U('vehicle_menu_title'),
      elements = elements
    },
    function(data, menu)
        local playerPed = GetPlayerPed(-1)
        local gps = Config.zones.vehicleSpawnPoint.gps
        local heading = Config.zones.vehicleSpawnPoint.markerD.heading
        local plate = Config.platePrefix .. math.random(10, 99)
        ESX.Game.SpawnVehicle(data.current.value.hash, gps, heading, function(vehicle)
          if data.current.label == Config.vehicles.bossCar.label then SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0) end
          TaskWarpPedIntoVehicle(playerPed, vehicle, - 1)
          SetVehicleNumberPlateText(vehicle, plate)
        end)
        menu.close()
        TriggerEvent('esx_brinks:hasExitedMarker', lastZone)
    end,
    function(data, menu)
      menu.close()
      TriggerEvent('esx_brinks:hasEnteredMarker', lastZone)
    end
)
end

-- menu facturation
function openBrinksBilling()
  printDebug('openBrinksBilling')
  ESX.UI.Menu.Open(
    'dialog', GetCurrentResourceName(), 'billing',
    {
      title = _U('bill_amount')
    },
    function(data, menu)
      local amount = tonumber(data.value)
      if amount == nil then
        ESX.ShowNotification(_U('invalid_amount'))
      else              
        menu.close()              
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
          ESX.ShowNotification(_U('no_player_nearby'))
        else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_brinks', 'Brinks', amount)
        end
      end
    end,
  function(data, menu)
    menu.close()
  end
  )
end
function openMobileBrinksMenu()
  printDebug('openMobileBrinksMenu')
  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_brinks_actions',
    {
      title    = _U('billing_title'),
      align    = 'top-left',
      elements = {
        {label = _U('billing'),   value = 'billing'},
      }
    },
    function(data, menu)
      if data.current.value == 'billing' then
        openBrinksBilling()
      end
    end,
    function(data, menu)
      menu.close()
    end
  )
end

-- start/stop run
function randomizeList(list)
  local newlist = {}
  while #list > 0 do
    local index = GetRandomIntInRange(1, #list)
    table.insert(newlist, list[index])
    local tmpList = {}
    for i=1, #list, 1 do
      if i ~= index then table.insert(tmpList, list[i]) end
    end
    list = tmpList
  end
  return newlist
end
function genMarketList()
  local coordsList = {}
  -- liste random des quartiers
  local listQuartier = {}
  for i=1, #Config.market,1 do table.insert(listQuartier, i) end
  listQuartier = randomizeList(listQuartier)
  -- liste random des boites par quartier
  for i=1, #listQuartier, 1 do 
    local tmpList = randomizeList(Config.market[listQuartier[i]])
    for y=1, #tmpList,1 do table.insert(coordsList, tmpList[y]) end
  end
  currentRun = coordsList
  printDebug('genRunList: ' .. #currentRun)
end
RegisterNetEvent('esx_brinks:nextMarket')
AddEventHandler('esx_brinks:nextMarket', function()
  local tmpList = {}
  for i=1, #currentRun, 1 do
    if i ~= 1 then table.insert(tmpList, currentRun[i]) end
  end
  currentRun = tmpList
  if #currentRun == 0 then genMarketList() end
  for i=1, #zoneList, 1 do
    if zoneList[i].name == 'market' then 
      if DoesBlipExist(zoneList[i].blip) then RemoveBlip(zoneList[i].blip) end
      zoneList[i].gps = currentRun[1]
      zoneList[i].enable = true
      zoneList[i].blip = nil
      break
    end
  end
  ESX.ShowNotification(_U('gps_info'))
  printDebug('nextMarket: ' .. #currentRun)
end)
function startNativeRun()
  printDebug('startNativeRun: ' .. #currentRun)
  for i=1, #zoneList, 1 do
    if zoneList[i].name == 'market' then 
      zoneList[i].gps = currentRun[1]
      zoneList[i].enable = true
    end
  end
  ESX.ShowNotification(_U('gps_info'))
end
function stopNativeJob()
  printDebug('stopNativeJob: ' .. #currentRun)
  for i=1, #zoneList, 1 do
    if zoneList[i].name == 'market' then
      zoneList[i].enable = false
      break
    end
  end
  ESX.ShowNotification(_U('cancel_mission'))
end
Citizen.CreateThread(function()
  while isLoading do Citizen.Wait(10) end
  while true do
    Citizen.Wait(0)
    if IsControlJustReleased(1, Keys["DELETE"]) and isWorking then
      if #currentRun == 0 then genMarketList() end      
      if isRunning then
        stopNativeJob(true)
        isRunning = false
      else
        local playerPed = GetPlayerPed(-1)
        if inVehicle and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), GetHashKey(Config.vehicles.truck.hash)) then
          startNativeRun()
          isRunning = true
        else ESX.ShowNotification(_U('not_good_veh')) end
      end
    end
  end
end)

-- debug gps
Citizen.CreateThread(function()
  while isLoading do Citizen.Wait(10) end
  while Config.debug do
    Citizen.Wait(15000)
    printDebug('gps = {x='.. coords.x ..', y='.. coords.y ..', z='.. coords.z ..'}')
  end
end)