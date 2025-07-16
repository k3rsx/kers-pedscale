function GetPlayerDiscord(playerId)
    for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
        local identifier = GetPlayerIdentifier(playerId, i)
        if string.find(identifier, 'discord:') then
            return identifier
        end
    end
    return 'Unknown'
end

local playerLicenses = {}

function GetPlayerLicense(playerId)
    if playerLicenses[playerId] then
        return playerLicenses[playerId]
    end
    
    local license = nil
    for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
        local identifier = GetPlayerIdentifier(playerId, i)
        if string.find(identifier, 'license:') then
            license = identifier
            break
        end
    end
    
    if license then
        playerLicenses[playerId] = license
    end
    
    return license
end

function HasPermission(playerId, permissionType)
    local license = GetPlayerLicense(playerId)
    if not license then return false end
    
    if permissionType == 'admin' then
        for _, adminLicense in ipairs(Config.Admins) do
            if license == adminLicense then
                return true
            end
        end
    elseif permissionType == 'user' then
        for _, userLicense in ipairs(Config.Users) do
            if license == userLicense then
                return true
            end
        end
    end
    
    return false
end

function _U(key, ...)
    return key
end

local function updateSql(source, height, weight)
    local identifier = GetPlayerLicense(source)
    if not identifier then return end

    local query = "INSERT INTO `kers_pedscale` (`character_scale`, `weight_scale`, `identifier`) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE `character_scale` = VALUES(`character_scale`), `weight_scale` = VALUES(`weight_scale`)"
    MySQL.update(query, { height, weight, identifier })
end

local function getPlayerScale(source)
    local query = "SELECT `character_scale`, `weight_scale` FROM `kers_pedscale` WHERE `identifier` = ?"
    local result = MySQL.single.await(query, { GetPlayerLicense(source) })
    return result and {height = result.character_scale, weight = result.weight_scale} or {height = 1.0, weight = 1.0}
end

local function setPlayerScale(source, scaleData, update)
    if GetPlayerPing(tostring(source)) <= 0 then
        return false, _U('player_not_found')
    end

    local height = scaleData.height or 1.0
    local weight = scaleData.weight or 1.0

    if height < 0.1 or height > 3.0 or weight < 0.1 or weight > 3.0 then
        return false, _U('invalid_scale')
    end

    local player = Player(source).state
    
    if height ~= 1.0 or weight ~= 1.0 then
        player:set("kersPedScale", {height = height, weight = weight}, true)
    else
        player:set("kersPedScale", nil, true)
    end

    if update then updateSql(source, height, weight) end
    return true
end

local function loadPlayerScale(source)
    local scale = getPlayerScale(source)
    setPlayerScale(source, scale)
end

RegisterNetEvent('pedscale:checkPermission', function()
    local source = source
    
    if not HasPermission(source, 'user') and not HasPermission(source, 'admin') then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {'System', _U('no_permission')}
        })
        return
    end
    
    TriggerClientEvent('pedscale:openMenu', source)
end)

RegisterNetEvent('pedscale:updateScale', function(scale)
    local source = source
    
    if not HasPermission(source, 'user') and not HasPermission(source, 'admin') then
        return
    end
    
    local success, errorMsg = setPlayerScale(source, scale, true)
    if not success then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {'System', errorMsg}
        })
        return
    end
    
    LogUserScaleChange(source, scale)
end)

RegisterNetEvent('pedscale:updateScaleByAdmin', function(scale, adminId)
    local source = source
    
    local success, errorMsg = setPlayerScale(source, scale, true)
    if not success then
        return
    end
    
    LogAdminScaleChange(adminId, source, scale)
end)

RegisterCommand('setpedscale', function(source, args)
    if source == 0 then
        if #args < 2 then
            return
        end
        
        local playerId = tonumber(args[1])
        local scale = tonumber(args[2])
        
        if not playerId or not scale then
            return
        end
        
        if not GetPlayerName(playerId) then
            return
        end
        
        local success = setPlayerScale(playerId, scale, true)
        if success then
            LogAdminScaleChange(0, playerId, scale)
        end
        return
    end
    
    if not HasPermission(source, 'admin') then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {'System', _U('no_permission')}
        })
        return
    end
    
    if #args < 2 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 0},
            args = {'System', 'Usage: /setpedscale <player_id> <scale>'}
        })
        return
    end
    
    local targetId = tonumber(args[1])
    local scale = tonumber(args[2])
    
    if not targetId or not scale then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {'System', 'Invalid arguments'}
        })
        return
    end
    
    if not GetPlayerName(targetId) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {'System', _U('player_not_found')}
        })
        return
    end
    
    local success, errorMsg = setPlayerScale(targetId, scale, true)
    if not success then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {'System', errorMsg}
        })
        return
    end
    
    TriggerClientEvent('pedscale:openAdminMenu', targetId, source, scale)
    LogAdminScaleChange(source, targetId, scale)
    
    local targetName = GetPlayerName(targetId)
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 0},
        args = {'System', string.format('Set %s scale to %.1f', targetName, scale)}
    })
end)

AddEventHandler('playerDropped', function()
    local playerId = source
    playerLicenses[playerId] = nil
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kers_pedscale (
            identifier varchar(50) NOT NULL PRIMARY KEY,
            character_scale float DEFAULT 1.0,
            weight_scale float DEFAULT 1.0,
            last_updated timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        );
    ]])
    
    SetTimeout(1000, function()
        for _, playerId in ipairs(GetPlayers()) do
            loadPlayerScale(tonumber(playerId))
        end
    end)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for _, playerId in ipairs(GetPlayers()) do
        Player(playerId).state:set("kersPedScale", nil, true)
    end
end)

AddEventHandler('playerJoining', function()
    local playerId = source
    SetTimeout(2000, function()
        loadPlayerScale(playerId)
    end)
end)

function GetPlayerScale(playerId)
    local player = Player(playerId).state
    return player["kersPedScale"] or 1.0
end

function SetPlayerScale(playerId, scale)
    return setPlayerScale(playerId, scale, true)
end

exports('GetPlayerScale', GetPlayerScale)
exports('SetPlayerScale', SetPlayerScale)