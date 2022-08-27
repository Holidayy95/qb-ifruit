local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-ifruit:client:Door', function()
    local ifruit = exports.ox_doorlock:getDoorFromName('ifruit')

    TriggerEvent('ox_doorlock:setState', ifruit.id, 0)
    
end)

RegisterNetEvent('qb-ifruit:server:RemoveDoorItem', function()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local item = Config.PaletoPacificDoor
    Player.Functions.RemoveItem(item, 1, false)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove')
end)

QBCore.Functions.CreateCallback('qb-ifruit:server:GetItemsNeeded', function(source, cb, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then 
        local Themite = Player.Functions.GetItemByName(item)
        if Themite ~= nil then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)