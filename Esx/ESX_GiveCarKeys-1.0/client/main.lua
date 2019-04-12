ESX               = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("esx_darcoche:Dar")
AddEventHandler("esx_darcoche:Dar", function()

DarCoche()

end)

function DarCoche()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

	if IsPedInAnyVehicle(playerPed,  false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
	end
	
	local plate = GetVehicleNumberPlateText(vehicle)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	

	ESX.TriggerServerCallback('esx_darcoche:requestPlayerCars', function(isOwnedVehicle)

		if isOwnedVehicle then
		
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

if closestPlayer == -1 or closestDistance > 3.0 then
  ESX.ShowNotification('No players nearby!')
else
  ESX.ShowNotification('You are giving your car keys for vehicle with plate ~g~'..vehicleProps.plate..'!')
  TriggerServerEvent('esx_darcoche:setVehicleOwnedPlayerId', GetPlayerServerId(closestPlayer), vehicleProps)
end
		
		end
	end, GetVehicleNumberPlateText(vehicle))
end