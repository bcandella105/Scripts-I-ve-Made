-- Server-side script: server/dohja_hairtie_server.lua

-- Client-side event to apply synced hair state
RegisterNetEvent('hairtie:apply', function(playerId, drawable, texture)
    local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
    if DoesEntityExist(playerPed) then
        SetPedComponentVariation(playerPed, 2, drawable, texture, 2)
    end
end)