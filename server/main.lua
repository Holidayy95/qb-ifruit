local QBCore = exports['qb-core']:GetCoreObject()
local timeOut = false

-- Callback

QBCore.Functions.CreateCallback('qb-ifruit:server:getCops', function(_, cb)
	local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)

-- Events

RegisterNetEvent('qb-ifruit:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('qb-ifruit:client:setVitrineState', -1, stateType, state, k)
end)

RegisterNetEvent('qb-ifruit:server:vitrineReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local luck = math.random(1, 100)
    local getfucked = math.random(1,100)

    if luck < 60 then
        local item = math.random(1, #Config.FruitRewards)
        local amount = math.random(Config.FruitRewards[item]["amount"]["min"], Config.FruitRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.FruitRewards[item]["item"], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.FruitRewards[item]["item"]], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.to_much'), 'error')
        end
        local amount2 = math.random(2, 8)
        if Player.Functions.AddItem("iphone", amount2) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["iphone"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.to_much'), 'error')
        end
    else
        local amount = math.random(2, 8)
        if Player.Functions.AddItem("iphone", amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["iphone"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.to_much'), 'error')
        end
    end
    if getfucked < 10 then
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return end
        if not (itemName == "advancedlockpick") then return end
        if Player.Functions.RemoveItem(itemName, 1) then
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[itemName], "remove")
            TriggerClientEvent('QBCore:Notify', src, "Your lockpick broke!", 'error')
        end
    end
end)

RegisterNetEvent('qb-ifruit:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        CreateThread(function()
            Wait(Config.Timeout)
            
            local ifruit = exports.ox_doorlock:getDoorFromName('ifruit')
            TriggerEvent('ox_doorlock:setState', ifruit.id, 1)
            for k, _ in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('qb-ifruit:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('qb-ifruit:client:setAlertState', -1, false)
                TriggerEvent('qb-scoreboard:server:SetActivityBusy', "jewellery", false)
            end
            timeOut = false
        end)
    end
end)