ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'fib', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'fib', _U('alert_sheriff'), true, true)
TriggerEvent('esx_society:registerSociety', 'fib', 'fib', 'society_fib', 'society_fib', 'society_fib', {type = 'public'})

RegisterServerEvent('esx_fib:giveWeapon')
AddEventHandler('esx_fib:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_fib:confiscatePlayerItem')
AddEventHandler('esx_fib:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label
	-- local weapon = targetXPlayer.getInventoryItem('weapon')
	-- local dmv = targetXPlayer.getInventoryItem('dmv')
	-- local drive = targetXPlayer.getInventoryItem('drive')
	-- local drive_bike = targetXPlayer.getInventoryItem('drive_bike').
	-- local drive_truck = targetXPlayer.getInventoryItem('drive_truck').count
	if (itemName == "weapon" or itemName == "dmv" or itemName == "drive"  or itemName == "drive_bike" or itemName == "drive_truck") then
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Tu peux lui prendre sa licence par l'autre menu")
	else
		targetXPlayer.removeInventoryItem(itemName, amount)
		sourceXPlayer.addInventoryItem(itemName, amount)
	
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
		TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )
	end
  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. _U('confdm') .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. sourceXPlayer.name .. _U('confweapon') .. ESX.GetWeaponLabel(itemName))

  end

end)

RegisterServerEvent('esx_fib:handcuff')
AddEventHandler('esx_fib:handcuff', function(target)
  TriggerClientEvent('esx_fib:handcuff', target)
end)

RegisterServerEvent('esx_fib:drag')
AddEventHandler('esx_fib:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_fib:drag', target, _source)
end)

RegisterServerEvent('esx_fib:putInVehicle')
AddEventHandler('esx_fib:putInVehicle', function(target)
  TriggerClientEvent('esx_fib:putInVehicle', target)
end)

RegisterServerEvent('esx_fib:OutVehicle')
AddEventHandler('esx_fib:OutVehicle', function(target)
    TriggerClientEvent('esx_fib:OutVehicle', target)
end)

RegisterServerEvent('esx_fib:getStockItem')
AddEventHandler('esx_fib:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fib', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('esx_fib:putStockItems')
AddEventHandler('esx_fib:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fib', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_fib:getOtherPlayerData', function(source, cb, target)

  if Config.EnableESXIdentity then

    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.Sync.fetchAll("SELECT * FROM characters WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })

    local user      = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex               = user['sex']
    local dob               = user['dateofbirth']
    local heightInit        = user['height']
    local heightFeet    = tonumber(string.format("%.0f",heightInit / 12, 0))
    local heightInches    = tonumber(string.format("%.0f",heightInit % 12, 0))
    local height        = heightFeet .. "\' " .. heightInches .. "\""

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex           = sex,
      dob           = dob,
      height        = height
    }

    --TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)

      --if status ~= nil then
        --data.drunk = math.floor(status.percent) -- erreur ??
      --end

    --end)

    if Config.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', target, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('esx_status:getStatus', _source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', _source, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)

ESX.RegisterServerCallback('esx_fib:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_fib:getVehicleInfos', function(source, cb, plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM characters WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('esx_fib:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_fib', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_fib:addArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_fib', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
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

ESX.RegisterServerCallback('esx_fib:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_fib', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
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


ESX.RegisterServerCallback('esx_fib:buy', function(source, cb, amount)

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_fib', function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_fib:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fib', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_fib:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)

RegisterServerEvent('esx_fib:codedmv') --Lui retire son Code coter Bdd
AddEventHandler('esx_fib:codedmv', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedmv = xPlayer.getInventoryItem('dmv').count
print(codedmv)
if codedmv > 0 then
xPlayer.removeInventoryItem('dmv', 1)
local codedmv2 = xPlayer.getInventoryItem('dmv').count
print(codedmv2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'dmv'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'dmv'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. _U('dmv') .. _U('from') .. xPlayer.name)
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Il n'a pas de" .. _U('dmv'))
end
end)

RegisterServerEvent('esx_fib:codedrive') --Lui retire son Code coter Bdd
AddEventHandler('esx_fib:codedrive', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedrive = xPlayer.getInventoryItem('drive').count
print(codedrive)
if codedrive > 0 then
xPlayer.removeInventoryItem('drive', 1)
local codedrive2 = xPlayer.getInventoryItem('drive').count
print(codedrive2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'drive'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'drive'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. _U('drive') .. _U('from') .. xPlayer.name)
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Il n'a pas de" .. _U('drive'))
end
end)

RegisterServerEvent('esx_fib:codedrivebike') --Lui retire son Code coter Bdd
AddEventHandler('esx_fib:codedrivebike', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedrivebike = xPlayer.getInventoryItem('drive_bike').count
print(codedrivebike)
if codedrivebike > 0 then
xPlayer.removeInventoryItem('drive_bike', 1)
local codedrivebike2 = xPlayer.getInventoryItem('drive_bike').count
print(codedrivebike2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'drive_bike'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'drive_bike'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. _U('drive_bike') .. _U('from') .. xPlayer.name)
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Il n'a pas de" .. _U('drive_bike'))
end
end)

RegisterServerEvent('esx_fib:codedrivetruck') --Lui retire son Code coter Bdd
AddEventHandler('esx_fib:codedrivetruck', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local codedrivetruck = xPlayer.getInventoryItem('drive_truck').count
print(codedrivetruck)
if codedrivetruck > 0 then
xPlayer.removeInventoryItem('drive_truck', 1)
local codedrivetruck2 = xPlayer.getInventoryItem('drive_truck').count
print(codedrivetruck2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'drive_truck'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'drive_truck'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. _U('drive_truck') .. _U('from') .. xPlayer.name)
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Il n'a pas de" .. _U('drive_truck'))
end
end)

RegisterServerEvent('esx_fib:weaponlicense') --Lui retire son Code coter Bdd
AddEventHandler('esx_fib:weaponlicense', function(playerId)
local xPlayer = ESX.GetPlayerFromId(playerId) --Variable playerId sert a trouver Id du joueur proche.
local sourceXPlayer = ESX.GetPlayerFromId(source)
local weaponlicense = xPlayer.getInventoryItem('weapon').count
print(weaponlicense)
if weaponlicense > 0 then
xPlayer.removeInventoryItem('weapon', 1)
local weaponlicense2 = xPlayer.getInventoryItem('weapon').count
print(weaponlicense2)
MySQL.Async.execute(
		"DELETE FROM `user_licenses` WHERE `owner` = @owner AND `type` = 'weapon'",
		{
			['@owner'] = xPlayer.identifier;
		}
	)
MySQL.Async.execute(
		"DELETE FROM `user_inventory` WHERE `identifier` = @identifier AND `item` = 'weapon'",
		{
			['@identifier'] = xPlayer.identifier;
		}
	)
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. _U('weapon') .. _U('from') .. xPlayer.name)
else
TriggerClientEvent('esx:showNotification', sourceXPlayer.source, "Il n'a pas de" .. _U('weapon'))
end
end)