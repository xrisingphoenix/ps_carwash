local washingVehicle = false
local WaitingForWash = false
local donewashing = false

local ptfxData = { -- Credits to https://forum.cfx.re/u/ixhal/summary for the Prop / Animation
    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {0.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },
    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-0.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },
    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-1.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },
    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-1.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },
    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-2.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },
    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {0.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },
    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {1.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },
    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {1.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },
    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {2.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },
    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,0.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 2.0,
    },
    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,-1.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },
    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,1.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },
    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,-2.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },
    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,2.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },
}

RegisterNetEvent('ps_vehicleclean:startparticle_c')
AddEventHandler('ps_vehicleclean:startparticle_c', function(vehNet, washer, use_props)
    if NetworkDoesEntityExistWithNetworkId(vehNet) then
        if washer == GetPlayerServerId(PlayerId()) then
            WaitingForWash = true
            washer = true 
        end

        local vehicle = NetworkGetEntityFromNetworkId(vehNet)
        local ptfxHandles = {}
        local side_props = nil
        local min_offsets, max_offsets = GetModelDimensions(GetEntityModel(vehicle))

        if use_props then
            local _, max_prop_dim = GetModelDimensions(`prop_carwash_roller_vert`)
            local left_offest = GetOffsetFromEntityInWorldCoords(vehicle, min_offsets.x, min_offsets.y, min_offsets.z - 0.5);left_offest = vector3(left_offest.x + max_prop_dim.x, left_offest.y, left_offest.z)
            local right_offset = GetOffsetFromEntityInWorldCoords(vehicle, max_offsets.x, min_offsets.y, min_offsets.z - 0.5);right_offset = vector3(right_offset.x - max_prop_dim.x, right_offset.y, right_offset.z)

            side_props = {
                {prop = CreateProp(`prop_carwash_roller_vert`, left_offest), offset = vector3(min_offsets.x - (max_prop_dim.x - 0.2), min_offsets.y, max_prop_dim.z/2)},
                {prop = CreateProp(`prop_carwash_roller_vert`, right_offset), offset = vector3(max_offsets.x + (max_prop_dim.x - 0.2), min_offsets.y, max_prop_dim.z/2)},
            }

            for i =1, #side_props, 1 do
                Citizen.CreateThread(function()
                    while side_props and side_props[i] and DoesEntityExist(side_props[i].prop) do
                        if i == 1 then
                            SetEntityHeading(side_props[i].prop, ((GetEntityHeading(side_props[i].prop) + 0.75) + 360) %360)
                        elseif i == 2 then
                            SetEntityHeading(side_props[i].prop, ((GetEntityHeading(side_props[i].prop) - 0.75) + 360) %360)
                        end
                        Citizen.Wait(0)
                    end
                end)
            end
        end

        for index, ptfx in pairs(ptfxData) do
            RequestParticleFX(ptfx.dict)
            UseParticleFxAssetNextCall(ptfx.dict)
            local CreatedParticle = StartNetworkedParticleFxLoopedOnEntity(ptfx.name, vehicle, ptfx.offset[1], ptfx.offset[2], ptfx.offset[3], ptfx.rot[1], ptfx.rot[2], ptfx.rot[3], ptfx.scale, false, false, false)
            table.insert(ptfxHandles, CreatedParticle)
        end

        local offset = min_offsets.y
        local prop_offset = min_offsets.y

        while offset < max_offsets.y and DoesEntityExist(vehicle) do
            for i = 1, #ptfxHandles do
                SetParticleFxLoopedOffsets(ptfxHandles[i], ptfxData[i].offset[1], offset, ptfxData[i].offset[3], ptfxData[i].rot[1], ptfxData[i].rot[2], ptfxData[i].rot[3])
            end

            if side_props ~= nil then
                for i = 1, #side_props, 1 do
                    SetEntityCoordsNoOffset(side_props[i].prop, GetOffsetFromEntityInWorldCoords(vehicle, side_props[i].offset.x, prop_offset, side_props[i].offset.z))
                end
                prop_offset += 0.0055
            end

            offset += 0.0055
            Wait(0)
        end

        for i = 1, #ptfxHandles do StopParticleFxLooped(ptfxHandles[i], false) end

        if side_props ~= nil then
            for i = 1, #side_props, 1 do DeleteEntity(side_props[i].prop) end
            side_props = nil
        end
        
        if washer == true then
            RequestNetworkControlOfEntity(vehicle)
            SetVehicleDirtLevel(vehicle, 0.0)
            WashDecalsFromVehicle(vehicle, 1.0)
            donewashing = true
            Config.Notify(Translation[Config.Locale]['washed_veh'])
            -- Wait(1000)
            Wait(2500) -- Prevent not driving with the props until their deleted
            FreezeEntityPosition(vehicle, false)
            busy = false
            WaitingForWash = false
            washingVehicle = false
        end
    end
end)

function RequestNetworkControlOfEntity(entity)
    NetworkRequestControlOfEntity(entity)
    local timeout = 2000
    while timeout > 0 and not NetworkHasControlOfEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end
    timeout = 2000
    SetEntityAsMissionEntity(entity, true, true)
    while timeout > 0 and not IsEntityAMissionEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end
end

function RequestParticleFX(dict)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do Wait(0) end
end

function LoadPropDict(model)
    if not IsModelInCdimage(model) then
        print('ERROR: The model that is required does not exist, Contact a developer of the server.')
        return
    end
    local time = 30
    while not HasModelLoaded(model) and time > 0 do RequestModel(model) Wait(100) time -= 1 end
    if time <= 0 then print('ERROR: loading required model failed, Contact a server developer.') end
end

function CreateProp(model, coords)
    if not HasModelLoaded(model) then; LoadPropDict(model); end
    local prop = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, false, false, false)
    SetEntityAsMissionEntity(prop, true, true)
    FreezeEntityPosition(prop, true)
    SetEntityCollision(prop, false, true)
    return prop
end

function WashVehicle(vehicle, use_props)
    if washingVehicle then 
        return 
    end
    washingVehicle = true
    FreezeEntityPosition(vehicle, true)
    TriggerServerEvent('ps_vehicleclean:startparticle_s', VehToNet(vehicle), true)
end

Citizen.CreateThread(function()
   for k,v in pairs(Config.Stations) do
        local blip = AddBlipForCoord(v.pos)
        SetBlipSprite(blip, 100)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 3)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Translation[Config.Locale]['blip'])
        EndTextCommandSetBlipName(blip)
   end
end)

AddEventHandler('onClientResourceStart', function(ressourceName)
    if(GetCurrentResourceName() ~= ressourceName) then 
        return 
    end 
    print("" ..ressourceName.." started sucessfully")
end)

ESX = exports["es_extended"]:getSharedObject()

local keepclean = false
local busy = false
local currentlevel
local tempcleanveh = {}


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(Config.Stations) do
            local playerPed = PlayerPedId()
            local plcoords = GetEntityCoords(playerPed)
            local dist = #(plcoords - v.pos)
            if dist < 7 and IsPedInAnyVehicle(PlayerPedId(), true) then 
                DrawMarker(1, v.pos.x, v.pos.y, v.pos.z-1.0, 0, 0, 0, 0, 0, 0, 3.5,3.5,0.8, 64,224,208, 150, 0, 0, 2, 0, 0, 0, 0)
                if dist < 2 then 
                    if IsControlJustReleased(0, 38) then 
                        if not busy then
                            openwashmenu(v, v.carwashname, v.percentage)
                        end
                    end 
                end
            end
        end
    end
end)

function openwashmenu(vehpos, carwashname, percentage)
    local playerPed = PlayerPedId()
    vehicle = GetVehiclePedIsIn(playerPed)
    busy = false
    local dialog = lib.inputDialog(Translation[Config.Locale]['menu_title'], {
        { type = 'select', label = Translation[Config.Locale]['menu_desc'], options = {
            { value = 'default',label = string.format(Translation[Config.Locale]['default_text'], Config.CarWash.default.price)},
            { value = 'silver', label = string.format(Translation[Config.Locale]['silver_text'], Config.CarWash.silver.price)},
            { value = 'gold',   label = string.format(Translation[Config.Locale]['gold_text'], Config.CarWash.gold.price)},
            { value = 'platin', label = string.format(Translation[Config.Locale]['platin_text'], Config.CarWash.platin.price)},
        }, 
        description= Translation[Config.Locale]['menu_choose'],
        default = 'default',
        icon = 'fa-solid fa-car'}})
    if dialog ~= nil then 
        donewashing = false
        if dialog[1] == 'default' then 
            startwash('Default', Config.CarWash.default, vehpos, carwashname, percentage)
        elseif dialog[1] == 'silver' then 
            startwash('Silber', Config.CarWash.silver, vehpos, carwashname, percentage)
        elseif dialog[1] == 'gold' then 
            startwash('Gold', Config.CarWash.gold, vehpos, carwashname, percentage)
        elseif dialog[1] == 'platin' then 
            startwash('Platin', Config.CarWash.platin, vehpos, carwashname, percentage)
        end
    end
end

function startwash(level, typ, vehpos, carwashname, percentage)
    local data = {
        price = typ.price, 
        washname = carwashname,
        prozent = percentage
    }
    ESX.TriggerServerCallback("ps_vehicleclean:hasmoney", function(hasmoney)
        if hasmoney then
            busy = true
            WashVehicle(vehicle, true)
            local vehicle = GetVehiclePedIsIn(PlayerPedId())
            SetEntityCoords(vehicle, vehpos.pos)
            if vehpos.heading == nil then
                --print("nil")
            else  
                SetEntityHeading(vehicle, vehpos.heading)
            end
            if level == 'Default' then
                while not donewashing do 
                    Citizen.Wait(50)
                end
                SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId()), 0.0)
                busy = false
                return
            end

            while not donewashing do 
                Citizen.Wait(50)
            end
            local dauer = math.random(typ.time.min, typ.time.max)

            if level == 'Silber' then 
                Config.Notify(string.format(Translation[Config.Locale]['desc_silver'], dauer))
            elseif level == 'Gold' then 
                Config.Notify(string.format(Translation[Config.Locale]['desc_gold'], dauer))
            elseif level == 'Platin' then 
                Config.Notify(string.format(Translation[Config.Locale]['desc_platin'], dauer))
            end
            
            busy = false
            local playerPed = PlayerPedId()
            vehicle = GetVehiclePedIsIn(playerPed)
            TriggerServerEvent("SetVehicleWashed_s", VehToNet(vehicle), level, dauer)
        else

            Config.Notify(Translation[Config.Locale]['no_money'])
            washingVehicle = false
            return
        end
    end, data, carwashname) 
end

RegisterNetEvent("SetVehicleWashed_c")
AddEventHandler("SetVehicleWashed_c", function(netveh, level, time)
    globalveh = NetToVeh(netveh)
    currentlevel = level
    keepclean = true 
    
    Citizen.Wait(time * 1000 * 60)
    keepclean = false 
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if keepclean then 
            if currentlevel == 'Silber' or currentlevel == 'Gold' or currentlevel == 'Platin' then
                SetVehicleDirtLevel(globalveh, 0.0)
            end 
            if currentlevel == 'Gold' or currentlevel == 'Platin' then 
                WashDecalsFromVehicle(globalveh, 1.0)
            end 
            if currentlevel == 'Platin' then
                RemoveDecalsFromVehicle(globalveh)
            end
        end
    end
end)

if Config.UseOwnableCarWash then 
    Citizen.CreateThread(function()
      while true do
        Citizen.Wait(0)
         for k,v in pairs(Config.Stations) do
            local playerPed = PlayerPedId()
            local plcoords = GetEntityCoords(playerPed)
            local dist = #(plcoords - v.buymanage)
            if dist < 7 then 
                DrawMarker(1, v.buymanage.x, v.buymanage.y, v.buymanage.z-1.0, 0, 0, 0, 0, 0, 0, 1.5,1.5,0.75, 64,224,208, 100, 0, 0, 2, 0, 0, 0, 0)
                if dist < 1 then 
                    ESX.ShowHelpNotification('~INPUT_PICKUP~ ' ..Translation[Config.Locale]['menu_title'])
                    if IsControlJustReleased(0, 38) and not IsPedInAnyVehicle(PlayerPedId(), false) then 
                        ESX.TriggerServerCallback('ps_carwash:isbuyable', function(isbuyable) 
                            if isbuyable then
                                local desc =  string.format(Translation[Config.Locale]['menu_buy_carwash'], v.buyprice)
                                lib.registerContext({
                                    id = 'carwash',
                                    title = Translation[Config.Locale]['menu_title'],
                                    icon = 'user',
                                    options = {
                                        {
                                            title = Translation[Config.Locale]['menu_buy_title'], 
                                            colorScheme = 'green',
                                            description = desc,
                                            icon = 'fa-solid fa-cart-shopping',
                                            iconColor = 'green',
                                            progress = 100,
                                            colorScheme = 'green',
                                            onSelect = function()
                                                TriggerServerEvent("ps_carwash:trytobuycarwash", v.carwashname, v.buyprice)
                                            end
                                        }, 
                                    }
                                })
                                lib.showContext('carwash')
                            else 
                                ESX.TriggerServerCallback('ps_carwash:isowner', function(isowner) 
                                    if isowner then 
                                        showbusinessmenu()
                                    else 
                                        lib.registerContext({
                                            id = 'carwash3',
                                            title = Translation[Config.Locale]['menu_title'],
                                            icon = 'user',
                                            options = {
                                                {
                                                    title = Translation[Config.Locale]['menu_already_bought'],
                                                    colorScheme = 'green',
                                                    description = Translation[Config.Locale]['menu_already_bought_desc'],
                                                    icon = 'fa-solid fa-car',
                                                    iconColor = 'orange',
                                                    progress = 100,
                                                    colorScheme = 'orange',
                                                    readonly = true
                                                }, 
                                            }
                                        })
                                        lib.showContext('carwash3')
                                    end
                                end, v.carwashname)
                            end
                        end, v.carwashname)
                    end 
                end
            end
         end
       end
    end)
end

function showbusinessmenu()
    ESX.TriggerServerCallback('ps_carwash:fetchcarwashdata', function(fetcheddata) 
        local sellprice
        for k,v in pairs(fetcheddata) do
            local desc = string.format(Translation[Config.Locale]['menu_account_desc'], v.balance)
            for _,data in pairs(Config.Stations) do
               if data.carwashname == v.carwashname then 
                    sellprice = data.sell
               end
            end
            lib.registerContext({
                id = 'carwash3',
                title = Translation[Config.Locale]['menu_title'],
                icon = 'user',
                options = {
                    {
                        title = Translation[Config.Locale]['menu_account'],
                        colorScheme = 'green',
                        description = desc,
                        icon = 'fa-solid fa-cash-register',
                        iconColor = 'green',
                        progress = 100,
                        colorScheme = 'green',
                        readonly = true
                    },  
                    { 
                        title = Translation[Config.Locale]['menu_account_deposit'],
                        colorScheme = 'green',
                        description = Translation[Config.Locale]['menu_account_deposit_desc'],
                        icon = 'fa-solid fa-money-bill-transfer',
                        iconColor = 'green',
                        progress = 100,
                        colorScheme = 'green',
                        onSelect = function()
                            selectinput('deposit')
                        end 
                    }, 
                    {
                        title = Translation[Config.Locale]['menu_account_withdraw'],
                        colorScheme = 'green',
                        description = Translation[Config.Locale]['menu_account_withdraw_desc'],
                        icon = 'fa-solid fa-money-bill-transfer',
                        iconColor = 'green',
                        progress = 100,
                        colorScheme = 'green',
                        onSelect = function()
                            selectinput('withdraw')
                        end
                    },
                    { 
                        title = Translation[Config.Locale]['menu_sell_carwash'],
                        colorScheme = 'orange',
                        description = Translation[Config.Locale]['menu_sell_carwash_desc'],
                        icon = 'fa-solid fa-hand-holding-hand',
                        iconColor = 'orange',
                        progress = 100,
                        colorScheme = 'orange',
                        onSelect = function()
                            lib.registerContext({
                                id = 'carwash4',
                                title = Translation[Config.Locale]['menu_title'],
                                icon = 'user',
                                menu = 'carwash3',
                                options = {
                                    {
                                        title = Translation[Config.Locale]['menu_sell_carwash_title'],
                                        colorScheme = 'green',
                                        description = string.format(Translation[Config.Locale]['menu_sell_carwash_confirm'], sellprice),
                                        icon = 'fa-solid fa-money-bill',
                                        iconColor = 'green',
                                        progress = 100,
                                        colorScheme = 'green',
                                        onSelect = function()
                                            Config.Notify(string.format(Translation[Config.Locale]['sold'], sellprice))
                                            TriggerServerEvent("ps_carwash:deleteOwnership", v.carwashname, sellprice)
                                        end
                                    }, 
                                    {
                                        title = Translation[Config.Locale]['menu_sell_carwash_to_player_title'],
                                        colorScheme = 'green',
                                        description = Translation[Config.Locale]['menu_sell_carwash_to_player_desc'],
                                        icon = 'fa-solid fa-money-bill',
                                        iconColor = 'green',
                                        progress = 100,
                                        colorScheme = 'green',
                                        onSelect = function()
                                            local input = lib.inputDialog(Translation[Config.Locale]['dialog_sell_player_id'], {
                                                {type = 'number',   label = Translation[Config.Locale]['dialog_sell_player_id'], description = 'ID', icon = 'hashtag'},
                                            })
                                            if input[1] then 
                                                TriggerServerEvent("ps_carwash:setnewownership", input[1], v.carwashname)
                                            end
                                        end
                                    },     
                                }
                            })
                            lib.showContext('carwash4')
                        end
                    },
                }
            })
            lib.showContext('carwash3')
        end
    end)
end

function selectinput(types)
    local input = lib.inputDialog(Translation[Config.Locale]['dialog_amount'], {
        {type = 'number',   label = Translation[Config.Locale]['dialog_amount'], description = Translation[Config.Locale]['dialog_amount_desc'], icon = 'hashtag'},
    })
    if input[1] then 
        TriggerServerEvent("ps_carwash:tryupdatebalance", types, input[1])
    end
end

RegisterNetEvent("ps_carwash:notification")
AddEventHandler("ps_carwash:notification", function(text)
   Config.Notify(text)
end)