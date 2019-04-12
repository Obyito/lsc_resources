ESX = nil

local playersNativeHarvest = {}
local playersNativeHarvestExit = {}

local playersNativeSell = {}
local playersNativeSellExit = {}

local playersBlackHarvest = {}
local playersBlackHarvestExit = {}

local playersBlackDestruct = {}
local playersBlackDestructExit = {}

-- debug msg
function printDebug(msg)
  if Config.debug then print(Config.debugPrint ..' '.. msg) end
end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_phone:registerNumber', Config.jobName, 'Client '..Config.companyName, false, false)
TriggerEvent('esx_society:registerSociety', Config.jobName, Config.companyName, Config.companyLabel, Config.companyLabel, Config.companyLabel, {type = 'private'})

-- nativeRun harvest
function nativeHarvest(source)
  printDebug('nativeHarvest')
  SetTimeout(Config.itemTime, function()
    if playersNativeHarvestExit[source] then playersNativeHarvest[source] = false end
    if playersNativeHarvest[source] == true then
      local xPlayer = ESX.GetPlayerFromId(source)
      local bag = xPlayer.getInventoryItem(Config.itemDb_name)
      local quantity = bag.count
      if quantity >= bag.limit then
        TriggerClientEvent('esx:showNotification', source, _U('harvest_truck'))
      else
        xPlayer.addInventoryItem(Config.itemDb_name, Config.itemAdd)
        TriggerClientEvent('esx:showNotification', source, _U('harvest_ok'))
        TriggerClientEvent('esx_brinks:nextMarket', source)
      end
    else TriggerClientEvent('esx:showNotification', source, _U('harvest_fail')) end
    playersNativeHarvest[source] = false
  end)
end
RegisterServerEvent('esx_brinks:startHarvestRun')
AddEventHandler('esx_brinks:startHarvestRun', function()
  printDebug('startHarvestRun')
  local _source = source
  if not playersNativeHarvest[_source] then
    TriggerClientEvent('esx:showNotification', _source, _U('harvest_start'))
    playersNativeHarvest[_source] = true
    playersNativeHarvestExit[_source] = false
    nativeHarvest(_source)
  end
  if playersNativeHarvestExit[_source] then
    TriggerClientEvent('esx:showNotification', _source, _U('dont_cheat'))
  end
end)
RegisterServerEvent('esx_brinks:stopHarvestRun')
AddEventHandler('esx_brinks:stopHarvestRun', function()
  printDebug('stopHarvestRun')
  local _source = source
  if playersNativeHarvest[_source] then playersNativeHarvestExit[_source] = true end
end)

-- nativeRun sell
function nativeSell(source)
  printDebug('nativeSell')
  SetTimeout(Config.itemTime, function()
    if playersNativeSellExit[source] then playersNativeSell[source] = false end
    if playersNativeSell[source] == true then
      local xPlayer = ESX.GetPlayerFromId(source)
      local quantity = xPlayer.getInventoryItem(Config.itemDb_name).count
      if quantity < Config.itemRemove then
        TriggerClientEvent('esx:showNotification', source, _U('no_item_to_sell', Config.itemDb_name))
        playersNativeSell[source] = false
      else
        local amount = Config.itemRemove
        local item = Config.itemDb_name
        xPlayer.removeInventoryItem(item, amount)
        
        xPlayer.addMoney(Config.itemPrice)
        local companyPrice = math.floor(Config.itemPrice * Config.companyRate)
        local gouvTaxe = math.floor(companyPrice * Config.gouvRate)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_brinks', function(account)account.addMoney(companyPrice)end )
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxe_brinks', function(account)account.addMoney(gouvTaxe)end )
        
        
        
        TriggerClientEvent('esx:showNotification', source, _U('you_earned', Config.itemPrice))
        TriggerClientEvent('esx:showNotification', source, _U('your_comp_earned', companyPrice))
        quantity = xPlayer.getInventoryItem(Config.itemDb_name).count
        if quantity >= Config.itemRemove then nativeSell(source)
        else 
          TriggerClientEvent('esx:showNotification', source, _U('sell_stop'))
          playersNativeSell[source] = false
        end
      end
    else TriggerClientEvent('esx:showNotification', source, _U('sell_fail')) end
  end)
end
RegisterServerEvent('esx_brinks:startSellRun')
AddEventHandler('esx_brinks:startSellRun', function()
  printDebug('startSellRun')
  local _source = source
  if not playersNativeSell[_source] then
    TriggerClientEvent('esx:showNotification', _source, _U('sell_start'))
    playersNativeSell[_source] = true
    playersNativeSellExit[_source] = false
    nativeSell(_source)
  end
  if playersNativeSellExit[_source] then
    TriggerClientEvent('esx:showNotification', _source, _U('dont_cheat'))
  end
end)
RegisterServerEvent('esx_brinks:stopSellRun')
AddEventHandler('esx_brinks:stopSellRun', function()
  printDebug('stopSellRun')
  local _source = source
  if playersNativeSell[_source] then playersNativeSellExit[_source] = true end
end)

-- weekly harvest
function weeklyCollect(source)
  printDebug('weeklyCollect')
  SetTimeout(Config.blackTime, function()
    if playersBlackHarvestExit[source] then playersBlackHarvest[source] = false end
    if playersBlackHarvest[source] then
      local request = "SELECT start_date, harvest, sell, malus FROM weekly_run WHERE company = '" .. Config.jobName .. "'"
      local response = MySQL.Sync.fetchAll(request) -- [{"harvest":0,"malus":0,"sell":0,"start_date":0},]
      local tmpTime = os.time()
      if tmpTime >= response[1].start_date then
      if response[1].harvest < Config.blackStep - response[1].malus then
         local xPlayer = ESX.GetPlayerFromId(source)
         local account = xPlayer.getAccount('black_money')
         if account.money > 0 then TriggerClientEvent('esx:showNotification', source, _U('need_no_bm'))
         else
           xPlayer.addAccountMoney('black_money', Config.blackAdd)
           response[1].harvest = response[1].harvest + 1
           request = "UPDATE weekly_run SET harvest = ".. response[1].harvest .. " WHERE company = '" .. Config.jobName .. "'"
           local resp = MySQL.Sync.fetchScalar(request)
           if response[1].harvest == Config.blackStep - response[1].malus  then TriggerClientEvent('esx:showNotification', source, _U('return_bank',response[1].harvest, Config.blackStep - response[1].malus))
           else TriggerClientEvent('esx:showNotification', source, _U('depose_and_retry',response[1].harvest, Config.blackStep - response[1].malus)) end
         end
       else TriggerClientEvent('esx:showNotification', source, _U('harvest_complete')) end
     else TriggerClientEvent('esx:showNotification', source, _U('wait_week')) end
    else TriggerClientEvent('esx:showNotification', source, _U('weekly_harvest_stop')) end
    playersBlackHarvest[source] = false
  end)
end
RegisterServerEvent('esx_brinks:startWeeklyCollect')
AddEventHandler('esx_brinks:startWeeklyCollect', function()
  printDebug('startWeeklyCollect')
  local _source = source
  if not playersBlackHarvest[_source] then
    TriggerClientEvent('esx:showNotification', _source, _U('weekly_harvest_start'))
    playersBlackHarvest[_source] = true
    playersBlackHarvestExit[_source] = false
    weeklyCollect(_source)
  end
  if playersBlackHarvestExit[_source] then
    TriggerClientEvent('esx:showNotification', _source, _U('dont_cheat'))
  end
end)
RegisterServerEvent('esx_brinks:stopWeeklyCollect')
AddEventHandler('esx_brinks:stopWeeklyCollect', function()
  printDebug('stopWeeklyCollect')
  local _source = source
  if playersBlackHarvest[_source] then playersBlackHarvestExit[_source] = true end
end)
-- weekly destruct
function weeklyDestruct(source)
  printDebug('weeklyDestruct')
  SetTimeout(Config.blackTime, function()
    if playersBlackDestructExit[source] then playersBlackDestruct[source] = false end
    if playersBlackDestruct[source] == true then
      local xPlayer = ESX.GetPlayerFromId(source)
      local account = xPlayer.getAccount('black_money')
      local amountR = math.floor((Config.blackRemove-(Config.blackRemove % 1000))/1000) .. ' '
      local amountRBis = Config.blackRemove % 1000
      if amountRBis < 100 then amountR = amountR .. '0' end
      if amountRBis < 10  then amountR = amountR .. '0' end
      amountR = amountR .. amountRBis
      if account.money < Config.blackRemove then
        TriggerClientEvent('esx:showNotification', source, _U('need_more_bm', amountR))
        playersBlackDestruct[source] = false
      else
        xPlayer.removeAccountMoney('black_money', Config.blackRemove)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_brinks', function(account)account.addMoney(Config.blackPrice)end)
        local request = "SELECT start_date, harvest, sell, malus FROM weekly_run WHERE company = '" .. Config.jobName .. "'"
        local response = MySQL.Sync.fetchAll(request) -- [{"harvest":0,"malus":0,"sell":0,"start_date":0},]
        request = "UPDATE weekly_run SET sell = ".. response[1].sell + 1 .. " WHERE company = '" .. Config.jobName .. "'"
        local resp = MySQL.Sync.fetchScalar(request)
        
        local amountP = math.floor((Config.blackPrice-(Config.blackPrice % 1000))/1000) .. ' '
        local amountPBis = Config.blackPrice % 1000
        if amountPBis < 100 then amountP = amountP .. '0' end
        if amountPBis < 10  then amountP = amountP .. '0' end
        amountP = amountP .. amountPBis
        TriggerClientEvent('esx:showNotification', source, _U('was_destruct', amountR))
        TriggerClientEvent('esx:showNotification', source, _U('your_comp_earned', amountP))
        account = xPlayer.getAccount('black_money')
        if account.money >= Config.blackRemove then weeklyDestruct(source)
        else 
          TriggerClientEvent('esx:showNotification', source, _U('weekly_destruct_stop'))
          playersBlackDestruct[source] = false
        end
      end
    else TriggerClientEvent('esx:showNotification', source, _U('weekly_destruct_fail')) end
  end)
end
RegisterServerEvent('esx_brinks:startWeeklyDestruct')
AddEventHandler('esx_brinks:startWeeklyDestruct', function()
  printDebug('startWeeklyDestruct')
  local _source = source
  if not playersBlackDestruct[_source] then
    TriggerClientEvent('esx:showNotification', _source, _U('weekly_destruct_start'))
    playersBlackDestruct[_source] = true
    playersBlackDestructExit[_source] = false
    weeklyDestruct(_source)
  end
  if playersBlackDestructExit[_source] then
    TriggerClientEvent('esx:showNotification', _source, _U('dont_cheat'))
  end
end)
RegisterServerEvent('esx_brinks:stopWeeklyDestruct')
AddEventHandler('esx_brinks:stopWeeklyDestruct', function()
  printDebug('stopWeeklyDestruct')
  local _source = source
  if playersBlackDestruct[_source]then playersBlackDestructExit[_source] = true end
end)

-- get Storage
ESX.RegisterServerCallback('esx_brinks:getStockItems', function(source, cb)
  printDebug('getStockItems')
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_brinks', function(inventory)
    cb(inventory.items)
  end)
end)
RegisterServerEvent('esx_brinks:getStockItem')
AddEventHandler('esx_brinks:getStockItem', function(itemName, count)
  printDebug('getStockItem')
  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_brinks', function(inventory)
    local item = inventory.getItem(itemName)
    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)
  end)
end)
-- put Storage 
ESX.RegisterServerCallback('esx_brinks:getPlayerInventory', function(source, cb)
  printDebug('getPlayerInventory')
  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory
  cb({
    items      = items
  })
end)
RegisterServerEvent('esx_brinks:putStockItems')
AddEventHandler('esx_brinks:putStockItems', function(itemName, count)
  printDebug('putStockItems')
  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_brinks', function(inventory)
    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count
    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)
  end)
end)
-- get weapon
ESX.RegisterServerCallback('esx_brinks:getArmoryWeapons', function(source, cb)
  printDebug('getArmoryWeapons')
  TriggerEvent('esx_datastore:getSharedDataStore', 'society_brinks', function(store)
    local weapons = store.get('weapons')
    if weapons == nil then weapons = {} end
    cb(weapons)
  end)
end)
-- put weapon
ESX.RegisterServerCallback('esx_brinks:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
  printDebug('addArmoryWeapon')
  local xPlayer = ESX.GetPlayerFromId(source)
  if removeWeapon then xPlayer.removeWeapon(weaponName) end
  TriggerEvent('esx_datastore:getSharedDataStore', 'society_brinks', function(store)
    local weapons = store.get('weapons')
    if weapons == nil then weapons = {} end
    local foundWeapon = false
    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
        break
      end
    end
    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end
    store.set('weapons', weapons)
    cb()
  end)
end)
ESX.RegisterServerCallback('esx_brinks:removeArmoryWeapon', function(source, cb, weaponName)
  printDebug('removeArmoryWeapon')
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weaponName, 500)
  TriggerEvent('esx_datastore:getSharedDataStore', 'society_brinks', function(store)
    local weapons = store.get('weapons')
    if weapons == nil then weapons = {} end
    local foundWeapon = false
    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
        break
      end
    end
    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end
    store.set('weapons', weapons)
    cb()
  end)
end)

-- Reset weekly run every monday at 00:00
function weeklyTask(d, h, m)
  printDebug('weeklyTask')
  if d == 2 then
    local request = "SELECT harvest, sell, malus FROM weekly_run WHERE company = '" .. Config.jobName .. "'"
    local response = MySQL.Sync.fetchAll(request) -- [{"harvest":0,"malus":0,"sell":0,"start_date":0},]
    if response[1].harvest ~= 0 then
      if response[1].sell < response[1].harvest then response[1].malus = response[1].malus + 1
      else response[1].malus = response[1].malus - 1 end
      if response[1].malus < 0 then response[1].malus = 0
      elseif response[1].malus >= Config.blackStep then response[1].malus = Config.blackStep - 1 end
    end
    request = "UPDATE weekly_run SET start_date = ".. os.time() .. ", malus = " .. response[1].malus .. ", harvest = 0, sell = 0 WHERE company = '" .. Config.jobName .. "'"
    response = MySQL.Sync.fetchAll(request) 
  end
end
TriggerEvent('cron:runAt', 0, 0, weeklyTask)
