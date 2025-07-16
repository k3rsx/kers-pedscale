local isMenuOpen = false
local currentHeight = 1.0
local currentWeight = 1.0
local adminId = nil
local playerScales = {}
local scaleThreadActive = false
local function norm(vec)
    local mag = math.sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z)
    if mag == 0 then return vec end
    return vector3(vec.x / mag, vec.y / mag, vec.z / mag)
end

local function changeEntitySize(ped, height, weight)
    if not DoesEntityExist(ped) or (height == 1.0 and weight == 1.0) then return end
    
    local forward, right, upVector, position = GetEntityMatrix(ped)
    
    local heightScale = height
    local widthScale = weight
    
    local adjustedWidthScale = (widthScale == 1.0) and heightScale or (heightScale * widthScale + 1)
    
    local forwardNorm = norm(forward) * adjustedWidthScale
    local rightNorm = norm(right) * adjustedWidthScale
    local upNorm = norm(upVector) * heightScale
    
    local zOffset = (1.0 - heightScale) * 0.5
    local adjustedZ = position.z - zOffset
    
    if GetEntitySpeed(ped) > 0 then
        adjustedZ = adjustedZ - zOffset
    else
        adjustedZ = adjustedZ + zOffset
    end
    
    SetEntityMatrix(ped,
        forwardNorm.x, forwardNorm.y, forwardNorm.z,
        rightNorm.x, rightNorm.y, rightNorm.z,
        upNorm.x, upNorm.y, upNorm.z,
        position.x, position.y, adjustedZ
    )
end

local function startScaleSystem()
    if scaleThreadActive then return end
    
    scaleThreadActive = true
    CreateThread(function()
        while scaleThreadActive do
            local playerCoords = GetEntityCoords(PlayerPedId())
            
            for playerId, scaleData in pairs(playerScales) do
                if NetworkIsPlayerActive(playerId) and (scaleData.height ~= 1.0 or scaleData.weight ~= 1.0) then
                    local ped = GetPlayerPed(playerId)
                    if DoesEntityExist(ped) then
                        local distance = #(playerCoords - GetEntityCoords(ped))
                        if distance < 100 then
                            changeEntitySize(ped, scaleData.height, scaleData.weight)
                        end
                    end
                end
            end
            Wait(0)
        end
    end)
end

local function stopScaleSystem()
    scaleThreadActive = false
end

CreateThread(function()
    while true do
        local hasScaledPlayers = false
        
        for _, playerId in ipairs(GetActivePlayers()) do
            local player = Player(GetPlayerServerId(playerId))
            if player and player.state then
                local scale = player.state["kersPedScale"]
                local serverPlayerId = GetPlayerServerId(playerId)
                
                if scale and scale ~= 1.0 then
                    playerScales[playerId] = scale
                    hasScaledPlayers = true
                    
                    if serverPlayerId == GetPlayerServerId(PlayerId()) then
                        currentScale = scale
                    end
                else
                    if playerScales[playerId] then
                        playerScales[playerId] = nil
                    end

                    if serverPlayerId == GetPlayerServerId(PlayerId()) then
                        currentScale = 1.0
                    end
                end
            end
        end
        
        if hasScaledPlayers and not scaleThreadActive then
            startScaleSystem()
        elseif not hasScaledPlayers and scaleThreadActive then
            stopScaleSystem()
        end
        
        Wait(1000)
    end
end)

local function openMenu()
    if isMenuOpen then return end
    
    isMenuOpen = true
    SetNuiFocus(true, true)
    
    local currentLocale = nil
    
    if Config.DefaultLanguage == 'en' and Locale_en then
        currentLocale = Locale_en.ui
    elseif Config.DefaultLanguage == 'tr' and Locale_tr then
        currentLocale = Locale_tr.ui
    end
    
    SendNUIMessage({
        action = 'showMenu',
        currentHeight = currentHeight,
        currentWeight = currentWeight,
        locale = currentLocale
    })
end

local function closeMenu()
    if not isMenuOpen then return end
    
    isMenuOpen = false
    SetNuiFocus(false, false)
    adminId = nil
    
    SendNUIMessage({
        action = 'hideMenu'
    })
end

RegisterCommand('pedscale', function()
    TriggerServerEvent('pedscale:checkPermission')
end)

RegisterCommand('ps', function()
    TriggerServerEvent('pedscale:checkPermission')
end)

RegisterNetEvent('pedscale:openMenu', function()
    adminId = nil
    openMenu()
end)

RegisterNetEvent('pedscale:openAdminMenu', function(fromAdminId, scale)
    adminId = fromAdminId
    currentScale = scale
    openMenu()
end)

RegisterNUICallback('previewScale', function(data, cb)
    local height = tonumber(data.height) or currentHeight
    local weight = tonumber(data.weight) or currentWeight
    
    if height >= 0.1 and height <= 3.0 and weight >= 0.1 and weight <= 3.0 then
        local ped = PlayerPedId()
        if DoesEntityExist(ped) then
            changeEntitySize(ped, height, weight)
        end
    end
    cb('ok')
end)

RegisterNUICallback('applyScale', function(data, cb)
    local height = tonumber(data.height) or currentHeight
    local weight = tonumber(data.weight) or currentWeight
    
    if height >= 0.1 and height <= 3.0 and weight >= 0.1 and weight <= 3.0 then
        currentHeight = height
        currentWeight = weight
        
        if adminId then
            TriggerServerEvent('pedscale:updateScaleByAdmin', {height = height, weight = weight}, adminId)
        else
            TriggerServerEvent('pedscale:updateScale', {height = height, weight = weight})
        end
        
        SendNUIMessage({
            action = 'updateScale',
            height = height,
            weight = weight
        })
    end
    
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    closeMenu()
    cb('ok')
end)

AddEventHandler('playerSpawned', function()
    Wait(1000)
    if currentScale ~= 1.0 then
    
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if isMenuOpen and IsControlJustPressed(0, 322) then
            closeMenu()
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    stopScaleSystem()
    playerScales = {}
    currentScale = 1.0
    
    if isMenuOpen then
        closeMenu()
    end
end)