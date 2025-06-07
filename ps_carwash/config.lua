Config = {}

Config.Webhook = ''

Config.Locale = 'en' -- 'de' 'en'

Config.UseOwnableCarWash = true

Config.Notify = function(text)
    ESX.ShowNotification(text)
end

Config.Account = { -- 'money' 'bank'
    washvehicle = 'bank',
    buycarwash = 'money'
}

Config.Bypass = {
    enable = true,
    jobs = { -- If you use custom Carwashlocations, the job not paying money
        {job = 'mechanic', carwashname = 'Little Soul'}, -- carwashname has to be identical to the carwashname in Config.Stations
        -- {job = 'police', carwashname = 'Southside'},
    },
}

Config.Stations = {
    {
        pos = vector3(24.3741, -1391.8601, 28.8696),
        heading = 90.3742, 
        
        buymanage = vector3(43.8578, -1394.8524, 29.9779),
        carwashname = 'Southside',
        buyprice = 89000, -- Buy Price 1 time
        sell = 45000, -- Hoch much Cash do you get back after selling Carwash
        percentage = 0.7, -- How many is he getting from the paid wash ( 0.7 = 70% , so the Owner Account gets 70% of the paid Money from User )
    },
    {
        pos = vector3(-699.84, -934.0, 19.0),
        heading = nil,
        
        buymanage = vector3(-703.9005, -924.7248, 19.0139),
        carwashname = 'Little Soul',
        buyprice = 89000,
        sell = 40000,
        percentage = 0.7,
    },
}

Config.CarWash = {
    default = {
        price = 100,
    },
    silver = {
        price = 500,
        time = {min = 30, max = 60}, -- in Minutes how long should it stay
    },
    gold = {
        price = 750,
        time = {min = 60, max = 90},
    },
    platin = {
        price = 1250,
        time = {min = 90, max = 120},
    },
}

Translation = {
    ['de'] = {
        ['washed_veh'] = "Fahrzeug gewaschen",
        ['menu_title'] = "Autowäsche",
        ['menu_desc'] = "Welche Autowäsche möchtest du anwenden?",
        ['menu_choose'] = "Wähle eine Option",
        ['no_money'] = "Du hast nicht genug Geld",
        ['default_text'] = "Standard Autowäsche %s $",
        ['silver_text'] = "Silber Autowäsche %s $",
        ['gold_text'] = "Gold Autowäsche %s $",
        ['platin_text'] = "Platin Autowäsche %s $",
        ['blip'] = "Waschanlage",
        ['press_to_wash'] = "~INPUT_PICKUP~ Menü",
        ['desc_silver'] = "Dein Auto wird nun vor Staub/Dreck geschützt und hält %s Minuten",
        ['desc_gold'] = "Dein Auto wird nun vor Staub/Dreck/Schlamm geschützt und hält %s Minuten",
        ['desc_platin'] = "Dein Auto wird nun vollständig vor Staub/Dreck/Schlamm geschützt und hält %s Minuten",
        ['menu_buy_carwash'] = "Kaufe die Waschanlage für %s$",
        ['menu_buy_title'] = "Kaufen",
        ['menu_already_bought'] = "Bereits gekauft",
        ['menu_already_bought_desc'] = "Diese Waschanlage ist bereits vergeben!",
        ['menu_account'] = "Konto",
        ['menu_account_desc'] = "Konto: %s$",
        ['menu_account_deposit'] = "Geld einzahlen",
        ['menu_account_deposit_desc'] = "Zahle Geld ein",
        ['menu_account_withdraw'] = "Geld Abheben",
        ['menu_account_withdraw_desc'] = "Hebe Geld ab",
        ['menu_sell_carwash'] = "Waschanlage verkaufen",
        ['menu_sell_carwash_desc'] = "Diese Waschanlage verkaufen",
        ['menu_sell_carwash_title'] = "Abgeben",
        ['menu_sell_carwash_confirm'] = "Bist du dir sicher, dass du die Waschanlage abgeben möchtest? | Geld zurück: %s",
        ['menu_sell_carwash_to_player_title'] = "AN SPIELER ABGEBEN",
        ['menu_sell_carwash_to_player_desc'] = "Gebe die Waschanlage an einen Spieler weiter",
        ['dialog_sell_player_id'] = "Spieler-ID",
        ['dialog_amount'] = "Menge",
        ['dialog_amount_desc'] = "Betrag eingeben",
        ['not_enough_money'] = "Du hast nicht genug Geld",
        ['bought_carwash'] = "Du hast die Waschanlage %s erfoglreich gekauft",
        ['webhook_bought_carwash'] = "Der Spieler **%s** hat die Waschanlage %s gekauft",
        ['webhook_deposit'] = "Der Spieler **%s** hat **%s$** in die Waschanlage %s eingezahlt",
        ['webhook_withdraw'] = "Der Spieler **%s** hat **%s$** aus der Waschanlage %s ausgezahlt",
        ['webhook_sold'] = "Der Spieler **%s** hat die Waschanlage %s verkauft",
        ['given_to_player'] = "Du hast die Waschanlage an %s abgegeben",
        ['webhook_given_to_player'] = "Der Spieler **%s** hat die Waschanlage %s an **%s** abgegeben",
        ['received_carwash_from_player'] = "Du hast die Waschanlage %s von %s erhalten",
        ['no_player_online'] = "Kein Spieler mit der ID: %s online",
        ['sold'] = "Waschanlage abgegeben. Du hast %s$ wiederbekommen",
        ['deposit_success'] = "%s$ erfolgreich eingezahlt",
        ['withdraw_success'] = "%s$ erfolgreich ausgezahlt",  
    },
    ['en'] = {
        ['washed_veh'] = "Vehicle washed",
        ['menu_title'] = "Carwash",
        ['menu_desc'] = "Which carwash do you want to use?",
        ['menu_choose'] = "Choose an option",
        ['no_money'] = "You do not have enough money",
        ['default_text'] = "Default Carwash %s $",
        ['silver_text'] = "Silver Carwash %s $",
        ['gold_text'] = "Gold Carwash %s $",
        ['platin_text'] = "Platinum Carwash %s $",
        ['blip'] = "Carwash Station",
        ['press_to_wash'] = "~INPUT_PICKUP~ Menu",
        ['desc_silver'] = "Your car is now protected from dust and dirt for %s minutes",
        ['desc_gold'] = "Your car is now protected from dust, dirt, and mud for %s minutes",
        ['desc_platin'] = "Your car is now fully protected from dust, dirt, and mud for %s minutes",
        ['menu_buy_carwash'] = "Buy the carwash for %s$",
        ['menu_buy_title'] = "Purchase",
        ['menu_already_bought'] = "Already bought",
        ['menu_already_bought_desc'] = "This carwash has already been bought!",
        ['menu_account'] = "Account",
        ['menu_account_desc'] = "Balance: %s$",
        ['menu_account_deposit'] = "Deposit Money",
        ['menu_account_deposit_desc'] = "Deposit your Money",
        ['menu_account_withdraw'] = "Withdraw Money",
        ['menu_account_withdraw_desc'] = "Withdraw your Money",
        ['menu_sell_carwash'] = "Sell Carwash",
        ['menu_sell_carwash_desc'] = "Sell this carwash",
        ['menu_sell_carwash_title'] = "Sell",
        ['menu_sell_carwash_confirm'] = "Are you sure you want to sell the carwash? | Refund: %s",
        ['menu_sell_carwash_to_player_title'] = "TRANSFER TO PLAYER",
        ['menu_sell_carwash_to_player_desc'] = "Transfer the carwash to another player",
        ['dialog_sell_player_id'] = "Player ID",
        ['dialog_amount'] = "Amount",
        ['dialog_amount_desc'] = "Enter amount",
        ['not_enough_money'] = "You do not have enough money",
        ['bought_carwash'] = "You have successfully bought the carwash %s",
        ['webhook_bought_carwash'] = "Player **%s** has bought the carwash %s",
        ['webhook_deposit'] = "Player **%s** deposited **%s$** into the carwash %s",
        ['webhook_withdraw'] = "Player **%s** withdrew **%s$** from the carwash %s",
        ['webhook_sold'] = "Player **%s** sold the carwash %s",
        ['given_to_player'] = "You transferred the carwash to %s",
        ['webhook_given_to_player'] = "Player **%s** transferred the carwash %s to **%s**",
        ['received_carwash_from_player'] = "You received the carwash %s from %s",
        ['no_player_online'] = "No player online with ID: %s",
        ['sold'] = "Carwash sold. You received %s$ back",
        ['deposit_success'] = "%s$ successfully deposited",
        ['withdraw_success'] = "%s$ successfully withdrawn",
    }
    
    

}