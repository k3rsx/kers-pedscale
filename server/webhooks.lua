Config.Webhook = {
    enable = true,
    userUrl = 'https://discord.com/api/webhooks/1394625050916687974/XurUPFbPm3vJNMiz6xl0QAe6sjtLwMz9bYh0tq0-bFdsjFxdgfe9e6OfO_uGHQrGPEIh',
    adminUrl = 'https://discord.com/api/webhooks/1394625133796261919/hDjwMDLIjP-LNjcPN5VeiBMbN-1scRXQ9PAD8sa0MNhJ_YBxksyAuZGvL83_AkrW8pQ-',
    botName = 'Ped Scale System',
    color = 3447003,
    userColor = 3066993,
    adminColor = 15158332
}

function LogUserScaleChange(playerId, height, weight)
    if not Config.Webhook.enable or not Config.Webhook.userUrl then
        return
    end
    
    local playerName = GetPlayerName(playerId) or "Unknown"
    local playerLicense = GetPlayerLicense(playerId) or "Unknown"
    local playerDiscord = GetPlayerDiscord(playerId) or "Unknown"
    
    local heightValue = tonumber(height) or 1.0
    local weightValue = tonumber(weight) or 1.0
    
    local embed = {
        {
            title = "Kullanıcı Boyut Değişikliği",
            description = playerName .. " karakterinin boyutunu değiştirdi",
            color = Config.Webhook.userColor,
            fields = {
                {
                    name = "Oyuncu",
                    value = playerName .. " (ID: " .. playerId .. ")",
                    inline = true
                },
                {
                    name = "License",
                    value = playerLicense,
                    inline = true
                },
                {
                    name = "Discord",
                    value = playerDiscord,
                    inline = true
                },
                {
                    name = "Boy",
                    value = string.format("%.2f", heightValue),
                    inline = true
                },
                {
                    name = "Kilo", 
                    value = string.format("%.2f", weightValue),
                    inline = true
                },
                {
                    name = "Tip",
                    value = "Kullanıcı Değişikliği",
                    inline = true
                }
            },
            thumbnail = {
                url = 'https://cdn-icons-png.flaticon.com/512/1177/1177568.png'
            },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%S.000Z')
        }
    }
    
    local data = {
        username = Config.Webhook.botName,
        embeds = embed
    }
    
    PerformHttpRequest(Config.Webhook.userUrl, function(err, text, headers)
    end, 'POST', json.encode(data), {['Content-Type'] = 'application/json'})
end

function LogAdminScaleChange(adminId, targetId, height, weight)
    if not Config.Webhook.enable or not Config.Webhook.adminUrl then
        return
    end
    
    local adminName = "Unknown"
    local adminLicense = "Unknown"
    local adminDiscord = "Unknown"
    
    if adminId == 0 then
        adminName = "Console"
        adminLicense = "Console"
        adminDiscord = "Console"
    else
        adminName = GetPlayerName(adminId) or "Unknown"
        adminLicense = GetPlayerLicense(adminId) or "Unknown"
        adminDiscord = GetPlayerDiscord(adminId) or "Unknown"
    end
    
    local targetName = GetPlayerName(targetId) or "Unknown"
    local targetLicense = GetPlayerLicense(targetId) or "Unknown"
    local targetDiscord = GetPlayerDiscord(targetId) or "Unknown"
    
    local heightValue = tonumber(height) or 1.0
    local weightValue = tonumber(weight) or 1.0
    
    local embed = {
        {
            title = "Admin Boyut Değişikliği",
            description = adminName .. " bir oyuncunun boyutunu değiştirdi",
            color = Config.Webhook.adminColor,
            fields = {
                {
                    name = "Admin",
                    value = adminName .. " (ID: " .. adminId .. ")",
                    inline = true
                },
                {
                    name = "Admin License",
                    value = adminLicense,
                    inline = true
                },
                {
                    name = "Admin Discord",
                    value = adminDiscord,
                    inline = true
                },
                {
                    name = "Hedef Oyuncu",
                    value = targetName .. " (ID: " .. targetId .. ")",
                    inline = true
                },
                {
                    name = "Hedef License",
                    value = targetLicense,
                    inline = true
                },
                {
                    name = "Hedef Discord",
                    value = targetDiscord,
                    inline = true
                },
                {
                    name = "Boy",
                    value = string.format("%.2f", heightValue),
                    inline = true
                },
                {
                    name = "Kilo",
                    value = string.format("%.2f", weightValue),
                    inline = true
                },
                {
                    name = "Tip",
                    value = "Admin Değişikliği",
                    inline = true
                }
            },
            thumbnail = {
                url = 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'
            },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%S.000Z')
        }
    }
    
    local data = {
        username = Config.Webhook.botName,
        embeds = embed
    }
    
    PerformHttpRequest(Config.Webhook.adminUrl, function(err, text, headers)
    end, 'POST', json.encode(data), {['Content-Type'] = 'application/json'})
end