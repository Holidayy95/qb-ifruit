local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-ifruit:client:Door', function()
    local ifruit = exports.ox_doorlock:getDoorFromName('ifruit')

    TriggerEvent('ox_doorlock:setState', ifruit.id, 0)
    
end)

RegisterNetEvent('qb-ifruit:server:UseThermite', function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return end

    Player.Functions.RemoveItem('thermite', 1)
end)
