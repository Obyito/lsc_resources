ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_plongee:withdraw')
AddEventHandler('esx_plongee:withdraw', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
		xPlayer.removeMoney(Config.Price)
		TriggerClientEvent('esx:showNotification', _source, 'Vous avez payé '.. Config.Price)
end)
