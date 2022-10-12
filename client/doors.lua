local  QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    exports['qb-target']:AddBoxZone("fruitgate", vector3(363.62, 74.79, 97.97), 0.6, 0.6, {
    name = "fruitgate",
    heading = 340.0,
    debugPoly = false,
    minZ= 97.17,
    maxZ= 98.37,
    }, {
        options = {
            {
            type = "client",
            event = "qb-ifruit:client:thermitebox2",
            icon = 'fas fa-bug',
            label = 'Thermite Box',
            }
        },
        distance = 1.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })

end)

RegisterNetEvent('qb-ifruit:client:ElectricBox', function()

    QBCore.Functions.Notify("Box Destroyed, doors should be open!", 'success')

    if Config.Doorlock == "ox" then
        TriggerServerEvent('qb-ifruit:client:Door')
    elseif Config.Doorlock == "qb" then
        TriggerServerEvent('qb-doorlock:server:updateState', Config.DoorName, false, false, false, true)
    end

    if math.random(1,100) < 80 then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'police'}, 
            coords = data.coords,
            title = '10-36 - Suspicious Activity',
            message = 'A '..data.sex..' robbing a store at '..data.street, 
            flash = 0,
            unique_id = tostring(math.random(0000000,9999999)),
            blip = {
                sprite = 769, 
                scale = 0.9, 
                colour = 0,
                flashes = true, 
                text = '911 - Suspicious Activity',
                time = (5*60*1000),
                sound = 1,
            }
        })
    end

end)

RegisterNetEvent('qb-ifruit:client:thermitebox2', function()
    QBCore.Functions.TriggerCallback('qb-ifruit:server:getCops', function(cops)
        if cops >= Config.RequiredCops then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            for k,v in pairs(Config.Ifruit['thermite']) do
                local Dist = #(coords - vector3(v['coords'].x, v['coords'].y, v['coords'].z))
                if Dist <= 1.5 then
                    local hasItem = QBCore.Functions.HasItem('thermite')
                    if hasItem then
                        SetEntityHeading(ped, Config.Ifruit['thermite'][k]['coords'].w)
                        exports['memorygame']:thermiteminigame(8, 3, 6, 15,
                        function() -- success
                            QBCore.Functions.Notify("Placing Charge...", 'success', 4500)
                            local loc = Config.Ifruit['thermite'][k]['anim']
                            local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(ped)))
                            local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
                            local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), loc.x, loc.y, loc.z,  true,  true, false)
                            SetEntityCollision(bag, false, true)
                            NetworkAddPedToSynchronisedScene(ped, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'thermal_charge', 1.5, -4.0, 1, 16, 1148846080, 0)
                            NetworkAddEntityToSynchronisedScene(bag, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'bag_thermal_charge', 4.0, -8.0, 1)
                            NetworkStartSynchronisedScene(bagscene)
                            Wait(1500)
                            local x, y, z = table.unpack(GetEntityCoords(ped))
                            local thermal_charge = CreateObject(GetHashKey('hei_prop_heist_thermite'), x, y, z + 0.2,  true,  true, true)

                            TriggerServerEvent('qb-ifruit:server:UseThermite')
                            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['thermite'], 'remove')
                        
                            SetEntityCollision(thermal_charge, false, true)
                            AttachEntityToEntity(thermal_charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
                            Wait(4000)
                        
                            DetachEntity(thermal_charge, 1, 1)
                            FreezeEntityPosition(thermal_charge, true)
                            Wait(100)
                            DeleteObject(bag)
                            ClearPedTasks(ped)
                        
                            Wait(100)
                            RequestNamedPtfxAsset('scr_ornate_heist')
                            while not HasNamedPtfxAssetLoaded('scr_ornate_heist') do
                                Wait(1)
                            end
                            -- ptfx = vector3(Config.Ifruit['thermite'][k]['effect'].x, Config.Ifruit['thermite'][k]['effect'].y, Config.Ifruit['thermite'][k]['effect'].z)
                            local termcoords = GetEntityCoords(thermal_charge)
                            ptfx = vector3(termcoords.x, termcoords.y + 1.0, termcoords.z)

                            SetPtfxAssetNextCall('scr_ornate_heist')
                            local effect = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', ptfx, 0, 0, 0, 0x3F800000, 0, 0, 0, 0)
                            Wait(3000)
                            StopParticleFxLooped(effect, 0)
                            DeleteObject(thermal_charge)
                            TriggerEvent('qb-ifruit:client:ElectricBox')
                        end,
                        function() -- failure
                            QBCore.Functions.Notify("You Failure!", 'error', 4500)
                        end)
                    else
                        QBCore.Functions.Notify("You don't have the correct items!", 'error')
                    end
                end
            end
        else
            QBCore.Functions.Notify("Something doesn't seem to be right..", 'error', 5000)
        end
    end)
end)
