local QBCore = exports['qb-core']:GetCoreObject()
local firstAlarm = false
local smashing = false

-- Functions

local function validItem()
    local hasItem = QBCore.Functions.HasItem('advancedlockpick')

    if hasItem then
        return true
    else
        return false
    end
    -- local ped = PlayerPedId()
    -- local pedWeapon = GetSelectedPedWeapon(ped)

    -- for k, _ in pairs(Config.WhitelistedWeapons) do
    --     if pedWeapon == k then
    --         return true
    --     end
    -- end
    -- return false

end

local function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == `mp_m_freemode_01` then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

local function smashVitrine(k)

    QBCore.Functions.TriggerCallback('qb-ifruit:server:getCops', function(cops)
        if cops >= Config.RequiredCops then
            local animDict = "missheist_jewel"
            local animName = "smash_case"
            local ped = PlayerPedId()
            local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
            local pedWeapon = GetSelectedPedWeapon(ped)
            if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
                TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
            elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
                TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
                QBCore.Functions.Notify(Lang:t('error.fingerprints'), "error")
            end
            smashing = true
            QBCore.Functions.Progressbar("smash_vitrine", Lang:t('info.progressbar'), 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                TriggerServerEvent('qb-ifruit:server:setVitrineState', "isOpened", true, k)
                TriggerServerEvent('qb-ifruit:server:setVitrineState', "isBusy", false, k)
                TriggerServerEvent('qb-ifruit:server:vitrineReward')
                TriggerServerEvent('qb-ifruit:server:setTimeout')

                local data = exports['cd_dispatch']:GetPlayerInfo()
                TriggerServerEvent('cd_dispatch:AddNotification', {
                    job_table = {'police'}, 
                    coords = data.coords,
                    title = '10-31B - iFruit Robbery',
                    message = 'A '..data.sex..' robbing the iFruit Store at '..data.street, 
                    flash = 1,
                    unique_id = tostring(math.random(0000000,9999999)),
                    blip = {
                        sprite = 521, 
                        scale = 0.9, 
                        colour = 59,
                        flashes = true, 
                        text = '911 - iFruit Robbery',
                        time = (5*60*1000),
                        sound = 1,
                    }
                })

                smashing = false
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            end, function() -- Cancel
                TriggerServerEvent('qb-ifruit:server:setVitrineState', "isBusy", false, k)
                smashing = false
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            end)
            TriggerServerEvent('qb-ifruit:server:setVitrineState', "isBusy", true, k)

            CreateThread(function()
                while smashing do
                    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic4"})
                    Wait(2500)
                end
            end)
        else
            QBCore.Functions.Notify(Lang:t('error.minimum_police', {value = Config.RequiredCops}), 'error')
        end
    end)
end

-- Events

RegisterNetEvent('qb-ifruit:client:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
end)

-- Threads

CreateThread(function()
    local iFruit = AddBlipForCoord(Config.IfruitLocation["coords"]["x"], Config.IfruitLocation["coords"]["y"], Config.IfruitLocation["coords"]["z"])
    SetBlipSprite (iFruit, 521)
    SetBlipDisplay(iFruit, 4)
    SetBlipScale  (iFruit, 0.7)
    SetBlipAsShortRange(iFruit, true)
    SetBlipColour(iFruit, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("iFruit Store")
    EndTextCommandSetBlipName(iFruit)
end)

local listen = false
local function Listen4Control(case)
    listen = true
    CreateThread(function()
        while listen do
            if IsControlJustPressed(0, 38) then
                listen = false
                if not Config.Locations[case]["isBusy"] and not Config.Locations[case]["isOpened"] then
                    exports['qb-core']:KeyPressed()
                        if validItem() then
                            smashVitrine(case)
                        else
                            QBCore.Functions.Notify(Lang:t('error.wrong_weapon'), 'error')
                        end
                    else
                        exports['qb-core']:DrawText(Lang:t('general.drawtextui_broken'), 'left')
                    end
                end
            Wait(1)
        end
    end)
end

CreateThread(function()
    if Config.UseTarget then
        for k, v in pairs(Config.Locations) do
            exports["qb-target"]:AddBoxZone("ifruitstore" .. k, v.coords, 1, 1, {
                name = "ifruitstore" .. k,
                heading = 245.0,
                minZ = v.coords.z - 0.5,
                maxZ = v.coords.z + 0.5,
                debugPoly = false
            }, {
                options = {
                    {
                        type = "client",
                        icon = "fa fa-hand",
                        label = Lang:t('general.target_label'),
                        action = function()
                            if validItem() then
                                smashVitrine(k)
                            end
                        end,
                        canInteract = function()
                            if v["isOpened"] or v["isBusy"] then
                                return false
                            end
                            return true
                        end,
                    }
                },
                distance = 1.5
            })
        end
    else
        for k, v in pairs(Config.Locations) do
            local boxZone = BoxZone:Create(v.coords, 1, 1, {
                name="ifruitstore"..k,
                heading = 40,
                minZ = v.coords.z - 1,
                maxZ = v.coords.z + 1,
                debugPoly = false
            })
            boxZone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    Listen4Control(k)
                    exports['qb-core']:DrawText(Lang:t('general.drawtextui_grab'), 'left')
                else
                    listen = false
                    exports['qb-core']:HideText()
                end
            end)
        end
    end
end)
