ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('ps_vehicleclean:startparticle_s', function(vehNet, use_props)
    local src = source
    TriggerClientEvent('ps_vehicleclean:startparticle_c', -1, vehNet, src, use_props)
end)

RegisterServerEvent("SetVehicleWashed_s")
AddEventHandler("SetVehicleWashed_s", function(netveh ,level, time)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("SetVehicleWashed_c", source, netveh, level, time)
end)

ESX.RegisterServerCallback('ps_vehicleclean:hasmoney', function(source, cb, data, carwashname)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Config.Bypass.enable then
        for k,v in pairs(Config.Bypass.jobs) do
            if xPlayer.job.name == v.job and v.carwashname == v.carwashname then 
                cb(true)
                return
            end
        end
    end

    local money = xPlayer.getAccount(Config.Account.washvehicle).money
    if money >= data.price then 
        xPlayer.removeAccountMoney(Config.Account.washvehicle, data.price)
        if Config.UseOwnableCarWash then 
            MySQL.single('SELECT balance FROM ps_carwash WHERE carwashname = ?', 
            { data.washname }, function(result)
                if result then
                    preis = (data.price * data.prozent)
                    newbalance = (result.balance + preis)
                    MySQL.update('UPDATE ps_carwash SET balance = ? WHERE carwashname = ?', {newbalance, data.washname})
                end
            end)
        end
        cb(true)
    else 
        cb(false)
    end
end)

RegisterServerEvent("ps_carwash:trytobuycarwash")
AddEventHandler("ps_carwash:trytobuycarwash", function(carwashname, buyprice)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.single('SELECT carwashname FROM ps_carwash WHERE carwashname = ?', 
    { carwashname }, function(result)
        if not result then
            if xPlayer.getAccount(Config.Account.buycarwash).money >= buyprice then
                MySQL.Async.execute("INSERT INTO ps_carwash (identifier, name, balance, date, carwashname) VALUES (@identifier,@name,@balance,@date,@carwashname)", { 
                    ['@identifier'] = xPlayer.getIdentifier(source), 
                    ['@name'] = xPlayer.getName(source), 
                    ['@balance'] = 0,
                    ['@date'] = os.date('%d.%m.%Y'),
                    ['@carwashname'] = carwashname,
                })
                xPlayer.removeAccountMoney(Config.Account.buycarwash, buyprice)
                TriggerClientEvent("ps_carwash:notification", xPlayer.source, string.format(Translation[Config.Locale]['bought_carwash'], carwashname ))

                local text = string.format(Translation[Config.Locale]['webhook_bought_carwash'], xPlayer.getName(), carwashname)
                carwash_webhook(text)
            else 
                TriggerClientEvent("ps_carwash:notification", xPlayer.source, Translation[Config.Locale]['not_enough_money'])
            end
        else 
            print("CHEATER!")
        end 
    end)
end)

ESX.RegisterServerCallback('ps_carwash:isowner', function(source, cb, carwashnameconfig)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier(source)
    MySQL.single('SELECT carwashname FROM ps_carwash WHERE identifier = ?', 
    { identifier }, function(result)
        if result then
            if result.carwashname == carwashnameconfig then
                cb(true)
            else 
                cb(false)
            end
        else 
            cb(false)
        end 
    end)
end)

ESX.RegisterServerCallback('ps_carwash:isbuyable', function(source, cb, carwashname)
    MySQL.single('SELECT carwashname FROM ps_carwash WHERE carwashname = ?', 
    { carwashname }, function(result)
        if not result then
            cb(true)
        else 
            cb(false)
        end 
    end)
end)


ESX.RegisterServerCallback('ps_carwash:fetchcarwashdata', function(source, cb, carwashnameconfig)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM ps_carwash WHERE identifier = @identifier',{
        ['@identifier'] = xPlayer.identifier
    },function(result)
        cb(result)
    end)
end)

RegisterServerEvent("ps_carwash:tryupdatebalance")
AddEventHandler("ps_carwash:tryupdatebalance", function(types, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local newbalance
    MySQL.single('SELECT * FROM ps_carwash WHERE identifier = ?', 
    { xPlayer.identifier }, function(result)
        if result then
            if types == 'deposit' then 
                if (xPlayer.getAccount('money').money) >= amount then
                    newbalance = (result.balance + amount)
                    xPlayer.removeAccountMoney('money', amount)
                    MySQL.update('UPDATE ps_carwash SET balance = ? WHERE identifier = ?', {newbalance, xPlayer.identifier})

                    TriggerClientEvent("ps_carwash:notification", xPlayer.source, string.format(Translation[Config.Locale]['deposit_success'], amount))

                    local text = string.format(Translation[Config.Locale]['webhook_deposit'], xPlayer.getName(), amount, result.carwashname)
                    carwash_webhook(text)
                else 
                    TriggerClientEvent("ps_carwash:notification", xPlayer.source, Translation[Config.Locale]['not_enough_money'])
                end
            elseif types == 'withdraw' then 
                if result.balance >= amount then
                    newbalance = (result.balance - amount)
                    xPlayer.addAccountMoney('money', amount)
                    MySQL.update('UPDATE ps_carwash SET balance = ? WHERE identifier = ?', {newbalance, xPlayer.identifier})

                    TriggerClientEvent("ps_carwash:notification", xPlayer.source, string.format(Translation[Config.Locale]['withdraw_success'], amount))

                    local text = string.format(Translation[Config.Locale]['webhook_withdraw'], xPlayer.getName(), amount, result.carwashname)
                    carwash_webhook(text)
                else 
                    TriggerClientEvent("ps_carwash:notification", xPlayer.source, Translation[Config.Locale]['not_enough_money'])
                end
            end
        else 
            TriggerClientEvent("ps_carwash:notification", xPlayer.source, "There is a Issue with your Database Entry. Check your Database")
        end 
    end)
end)

RegisterServerEvent("ps_carwash:deleteOwnership")
AddEventHandler("ps_carwash:deleteOwnership", function(washname, sellprice)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute(
        'DELETE FROM ps_carwash WHERE carwashname = @carwashname LIMIT 1', {
        ["@carwashname"]          = washname,
    })

    xPlayer.addAccountMoney('money', sellprice)

    local text = string.format(Translation[Config.Locale]['webhook_sold'], xPlayer.getName(), washname)
    carwash_webhook(text)
end)

RegisterServerEvent("ps_carwash:setnewownership")
AddEventHandler("ps_carwash:setnewownership", function(targetid, carwashname)
    local tplayer = ESX.GetPlayerFromId(targetid)
    local xPlayer = ESX.GetPlayerFromId(source)
    if tplayer ~= nil then
        local identifier = tplayer.identifier
        MySQL.update('UPDATE ps_carwash SET identifier = ? WHERE carwashname = ?', {identifier, carwashname})
        MySQL.update('UPDATE ps_carwash SET name = ? WHERE carwashname = ?', {tplayer.getName(), carwashname})

        TriggerClientEvent("ps_carwash:notification", xPlayer.source, string.format(Translation[Config.Locale]['given_to_player'], tPlayer.getName()))

        local text = string.format(Translation[Config.Locale]['webhook_given_to_player'], xPlayer.getName(), washname)
        carwash_webhook(text)

        TriggerClientEvent("ps_carwash:notification", tplayer.source, string.format(Translation[Config.Locale]['received_carwash_from_player'], carwashname, xPlayer.getName()))
    else 
        TriggerClientEvent("ps_carwash:notification", xPlayer.source, string.format(Translation[Config.Locale]['no_player_online'], targetid))
    end
end)

function carwash_webhook(text)
    local xPlayer = ESX.GetPlayerFromId(source)
	local webhook = Config.Webhook
	local information = {
		{
			["color"] = '6684876',
			["author"] = {
				["icon_url"] = 'https://i.ibb.co/DgtFmvr6/ps-logo-1-circle.png',
				["url"] = 'https://discord.com/invite/CUXK7CWx3P',
				["name"] = 'Phoenix Studios',
			},
			
			['url'] = 'https://github.com/xrisingphoenix/ps_carwash',
			["title"] = 'Carwash Logs',
	
			["description"] = text,
	
			["footer"] = {
				["text"] = os.date('%d/%m/%Y [%X] • PHOENIX STUDIOS'),
				["icon_url"] = 'https://i.ibb.co/60rCYFmk/logo2.png',
			}
		}
	}
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = 'PHOENIX STUDIOS', embeds = information, avatar_url = 'https://i.ibb.co/mV504dFz/ps-logo-2-circle.png' }), {['Content-Type'] = 'application/json'}) 
end

