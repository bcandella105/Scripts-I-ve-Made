-- Global variable to store the original hair state
local originalHair = {}

-- Register the /hairtie command
RegisterCommand('hairtie', function(source, args, rawCommand)
    local playerPed = PlayerPedId() -- Get the player's ped

    -- Check if the player is in a valid ped model
    if not IsPedAPlayer(playerPed) then return end

    -- Define animations
    local animDict = "veh@common@fp_helmet@"
    local animTakeOff = "take_off_helmet_stand"
    local animPutOn = "put_on_helmet"

    -- Load the animation dictionary
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end

    -- Get the current hair drawable ID and texture
    local currentDrawable = GetPedDrawableVariation(playerPed, 2) -- Component ID 2 is hair
    local currentTexture = GetPedTextureVariation(playerPed, 2)

    -- If originalHair is empty, store the original hairstyle
    if not originalHair.drawable then
        originalHair = { drawable = currentDrawable, texture = currentTexture }
    end

    -- Toggle the hair state based on current drawable
    local hiddenHairDrawable = 0
    local hiddenHairTexture = 0

    -- Disable sounds temporarily by using vehicle sound suppression
    SetEntityInvincible(playerPed, true) -- Prevent interactions during the animation
    ClearPedTasksImmediately(playerPed) -- Clear any active tasks

    -- Mute the vehicle-related sounds (attempted workaround)
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    if playerVehicle and playerVehicle ~= 0 then
        SetVehicleHornEnabled(playerVehicle, false) -- Disable horn (if related to the animation)
    end

    -- Play the animation without sound
    if currentDrawable ~= hiddenHairDrawable then
        -- Play take-off animation without sound
        TaskPlayAnim(playerPed, animDict, animTakeOff, 8.0, -8.0, -1, 48, 0, false, false, false)
        Wait(800) -- Wait for animation to finish (adjust timing as needed)

        -- Set hair to hidden
        SetPedComponentVariation(playerPed, 2, hiddenHairDrawable, hiddenHairTexture, 2)
        TriggerServerEvent('hairtie:sync', hiddenHairDrawable, hiddenHairTexture)

    else
        -- Play put-on animation without sound
        TaskPlayAnim(playerPed, animDict, animPutOn, 8.0, -8.0, -1, 48, 0, false, false, false)
        Wait(800) -- Wait for animation to finish (adjust timing as needed)

        -- Set hair back to original state (visible)
        SetPedComponentVariation(playerPed, 2, originalHair.drawable, originalHair.texture, 2)
        TriggerServerEvent('hairtie:sync', originalHair.drawable, originalHair.texture)

    end

    -- Re-enable interactions after animation is done
    SetEntityInvincible(playerPed, false)

    -- Re-enable vehicle horn (if it was disabled)
    if playerVehicle and playerVehicle ~= 0 then
        SetVehicleHornEnabled(playerVehicle, true)
    end

    -- Clean up animation dictionary
    RemoveAnimDict(animDict)
end, false)
