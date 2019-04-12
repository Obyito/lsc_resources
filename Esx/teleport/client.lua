local TeleportFromTo = {
	["Courtroom"] = {
		positionFrom = { ['x'] = 1013.1706542969, ['y'] = 2905.4699707031, ['z'] = 41.374877929688, nom = "Entré dans le Bunker"},
		positionTo = { ['x'] = 1009.8477172852, ['y'] = 2905.8864746094, ['z'] = 34.620891571045, nom = "Sortir du Bunker"},
	},	
}

local TeleportFromTo = {
	["Gouv"] = {
		positionFrom = { ['x'] = 136.169, ['y'] = -761.737, ['z'] = 45.400, nom = "Entré dans le Gouvernement"},
		positionTo = { ['x'] = 136.169, ['y'] = -761.737, ['z'] = 241.800, nom = "Sortir du Gouvernement"},
	},	
}

local TeleportFromTo = {
	["Cartel"] = {
		positionFrom = { ['x'] = 1395.0163574219, ['y'] = 1141.8153076172, ['z'] = 114.62686157227, nom = "Entré dans la Villa"},
		positionTo = { ['x'] = 1396.7177734375, ['y'] = 1141.8315429688, ['z'] = 114.33358001709, nom = "Sortir de la Villa"},
	},	
}

local TeleportFromTo = {
    ["Meth"] = {
		positionFrom = { ['x'] = 1236.982421875, ['y'] = -650.78973388672, ['z'] = 38.640277862549, nom = "Entré dans l'ascenseur"},
		positionTo = { ['x'] = 996.82196044922, ['y'] = -3200.6862792969, ['z'] = -36.393718719482, nom = "Sortir de l'hangar"},
	},	
}

local TeleportFromTo = {
    ["Coke"] = {
		positionFrom = { ['x'] = 887.289794, ['y'] = -953.441223, ['z'] = 39.113142, nom = "Entré la cave"},
		positionTo = { ['x'] = 1088.854980, ['y'] = -3188.458740, ['z'] = -38.99347, nom = "Sortir de la cave"},
	},	
}

local coord1 = {x=136.169,y=-761.737,z=45.400}
local coord2 = {x=136.169,y=-761.737,z=241.800}

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
			if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 150.0)then
				DrawMarker(1, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, .801, 255, 255, 255,255, 0, 0, 0,0)
				if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 5.0)then
					Drawing.draw3DText(j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1.100, j.positionFrom.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
					if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 2.0)then
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("Press ~r~E~w~ to ".. j.positionFrom.nom)
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

			if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 150.0)then
				DrawMarker(1, j.positionTo.x, j.positionTo.y, j.positionTo.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, .801, 255, 255, 255,255, 0, 0, 0,0)
				if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 5.0)then
					Drawing.draw3DText(j.positionTo.x, j.positionTo.y, j.positionTo.z - 1.100, j.positionTo.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
					if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 2.0)then
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("Press ~r~E~w~ to ".. j.positionTo.nom)
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
