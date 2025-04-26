QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('treasurehunt:reward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local cash = math.random(Config.CashReward.min, Config.CashReward.max)
    Player.Functions.AddMoney('cash', cash, 'treasure-hunt')

    local item = Config.ItemRewards[math.random(#Config.ItemRewards)]
    Player.Functions.AddItem(item, 1)
    TriggerClientEvent('QBCore:Notify', src, 'You found '..item..' and $'..cash..'!', 'success')
end)
