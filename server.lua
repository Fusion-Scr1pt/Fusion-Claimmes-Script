local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Function to send Discord webhook log
function sendDiscordLog(playerName, playerId, discordID, playerLicense, actionType, webhookURL)
    local embed = {
        {
            ["color"] = actionType == "Mes Claim" and 65280 or 16711680, -- Green for claim, Red for reset
            ["author"] = {
                ["name"] = "Mes Action Log",
                ["icon_url"] = "https://media.discordapp.net/attachments/1362897907048775832/1371952594091511948/fusionlogo2.png?ex=6832d9ac&is=6831882c&hm=259fccedb3f6e8a8fc041b8bf27d46caf4c83a26799bb3a1f1ef658948f6f012&=&format=webp&quality=lossless"
            },
            ["title"] = string.format("**%s Action**", actionType),
            ["description"] = string.format("**%s** (ID: `%d`) has %s the mes.", playerName, playerId, actionType),
            ["fields"] = {
                {["name"] = "Discord", ["value"] = string.format("<%s>", discordID), ["inline"] = true},
                {["name"] = "License", ["value"] = "License: " .. playerLicense, ["inline"] = true}
            },
            ["footer"] = {
                ["text"] = "https://discord.gg/W7HrHBUPWW"
            },
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }
    }

    -- Use the dynamic webhook URL passed to the function
    PerformHttpRequest(webhookURL, function() end, 'POST', json.encode({
        username = "Server Logs",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- Command to claim mes (Switchblade)
RegisterCommand("claimmes", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerIdentifier = xPlayer.identifier
    local playerLicense = xPlayer.getIdentifier()
    local playerName = xPlayer.getName()
    local discordID = "@" .. (GetDiscordID(source) or "Onbekend")

    -- Check if mes has already been claimed
    exports.oxmysql:fetch('SELECT claimed_mes FROM users WHERE identifier = @identifier', {
        ['@identifier'] = playerIdentifier
    }, function(result)
        if result[1] and result[1].claimed_mes == true then
            TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'Je hebt dit mes al geclaimed.'})
            return
        end

        -- Add the item (weapon_switchblade) to the player's inventory
        exports.ox_inventory:AddItem(source, 'weapon_switchblade', 1)

        -- Update the database to mark mes as claimed
        exports.oxmysql:execute('UPDATE users SET claimed_mes = TRUE WHERE identifier = @identifier', {
            ['@identifier'] = playerIdentifier
        })

        TriggerClientEvent('ox_lib:notify', source, {type = 'success', description = 'Je hebt een Switchblade geclaimed!'})

        -- Send Discord log for claiming the mes
        if Config.EnableClaimWebhook then
            sendDiscordLog(playerName, source, discordID, playerLicense, "Mes Claim", Config.ClaimWebhookURL)
        end
    end)
end, false)

-- Command to reset mes claim
RegisterCommand("resetmes", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Controleer of de speler admin is
    if xPlayer.getGroup() ~= "admin" then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'Je hebt geen toestemming om dit commando uit te voeren.'})
        return
    end

    local playerIdentifier = xPlayer.identifier
    local playerName = xPlayer.getName()
    local discordID = "@" .. (GetDiscordID(source) or "Onbekend")

    -- Reset de mes-claim status naar FALSE in de database
    exports.oxmysql:execute('UPDATE users SET claimed_mes = FALSE WHERE identifier = @identifier', {
        ['@identifier'] = playerIdentifier
    })

    TriggerClientEvent('ox_lib:notify', source, {type = 'info', description = 'Je mes-claim is gereset!'})

    -- Stuur een Discord-log voor het resetten van de mes-claim
    if Config.EnableResetWebhook then
        sendDiscordLog(playerName, source, discordID, playerIdentifier, "Mes Reset", Config.ResetWebhookURL)
    end
end, false)

-- Get Discord ID for a player
function GetDiscordID(src)
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 8) == "discord:" then
            return string.sub(v, 9)
        end
    end
    return nil
end