ESX               = nil
local cars 		  = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_darcoche:requestPlayerCars', function(source, cb, plate)

	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @identifier', 
		{
			['@identifier'] = xPlayer.identifier
		},
		function(result)

			local found = false

			for i=1, #result, 1 do

				local vehicleProps = json.decode(result[i].vehicle)

				if vehicleProps.plate == plate then
					found = true
					break
				end

			end

			if found then
				cb(true)
			else
				cb(false)
			end

		end
	)
end)

RegisterServerEvent('esx_darcoche:setVehicleOwnedPlayerId')
AddEventHandler('esx_darcoche:setVehicleOwnedPlayerId', function (playerId, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.execute('UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate
	},
	
	function (rowsChanged)
		TriggerClientEvent('esx:showNotification', playerId, 'You have got a new car with plate ~g~' ..vehicleProps.plate..'!', vehicleProps.plate)

	end) 
end)

TriggerEvent('es:addGroupCommand', 'givecarkeys', 'user', function(source, args, user)
	TriggerClientEvent('esx_darcoche:Dar', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'ERROR - Check codeina.pro for information.' } })
end)
