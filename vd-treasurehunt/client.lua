local QBCore = exports['qb-core']:GetCoreObject()

local isHunting = false
local currentStage = 0
local huntCoords = {}
local blip = nil


function StartTreasureHunt()
    if isHunting then
        QBCore.Functions.Notify('You are already on a treasure hunt!', 'error')
        return
    end

    isHunting = true
    currentStage = 0
    huntCoords = GenerateHuntLocations()
    NextClue()
end

function NextClue()
    currentStage = currentStage + 1

    if blip then
        RemoveBlip(blip)
    end

    if currentStage <= #huntCoords then
        local coords = huntCoords[currentStage]
        blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 280)
        SetBlipColour(blip, 5)
        SetBlipScale(blip, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Treasure Clue")
        EndTextCommandSetBlipName(blip)

        CreateThread(function()
            local reached = false
            while not reached do
                Wait(500)
                local playerCoords = GetEntityCoords(PlayerPedId())
                if #(playerCoords - vector3(coords.x, coords.y, coords.z)) < 3.0 then
                    reached = true
                    QBCore.Functions.Notify('You found a clue!', 'success')
                    Wait(1500)
                    NextClue()
                end
            end
        end)

    else
        FinishHunt()
    end
end

function FinishHunt()
    if blip then
        RemoveBlip(blip)
    end

    local finalCoords = huntCoords[#huntCoords]

    RequestModel(GetHashKey(Config.TreasureProp))
    while not HasModelLoaded(GetHashKey(Config.TreasureProp)) do
        Wait(10)
    end

    local chest = CreateObject(GetHashKey(Config.TreasureProp), finalCoords.x, finalCoords.y, finalCoords.z - 1.0, true, true, true)
    SetEntityHeading(chest, math.random(0, 360))
    FreezeEntityPosition(chest, true)

    if Config.UseTarget then
        exports['qb-target']:AddTargetEntity(chest, {
            options = {
                {
                    label = 'Open Treasure',
                    action = function()
                        ClaimReward(chest)
                    end,
                }
            },
            distance = 2.5
        })
    else
        CreateThread(function()
            local opened = false
            while not opened do
                local playerCoords = GetEntityCoords(PlayerPedId())
                if #(playerCoords - GetEntityCoords(chest)) < 2.0 then
                    DrawText3D(finalCoords.x, finalCoords.y, finalCoords.z + 1.0, "Press ~g~E~w~ to open the treasure")
                    if IsControlJustReleased(0, 38) then
                        opened = true
                        ClaimReward(chest)
                    end
                end
                Wait(0)
            end
        end)
    end
end

function ClaimReward(chest)
    DeleteEntity(chest)
    TriggerServerEvent('vd-treasurehunt:giveReward')
    QBCore.Functions.Notify('You found the treasure!', 'success')
    isHunting = false
end

function GenerateHuntLocations()
    local locations = {}
    local all = Config.HuntLocations
    local used = {}

    for i = 1, Config.LocationsAmount do
        local rand = math.random(1, #all)
        while used[rand] do
            rand = math.random(1, #all)
        end
        used[rand] = true
        table.insert(locations, all[rand])
    end

    return locations
end

CreateThread(function()
    if Config.UseNPC then
        RequestModel(Config.PirateNPCModel)
        while not HasModelLoaded(Config.PirateNPCModel) do
            Wait(10)
        end

        local npc = CreatePed(0, Config.PirateNPCModel, Config.PirateNPCLocation.x, Config.PirateNPCLocation.y, Config.PirateNPCLocation.z - 1.0, Config.PirateNPCLocation.w, false, true)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)

        if Config.UseTarget then
            exports['qb-target']:AddTargetEntity(npc, {
                options = {
                    {
                        label = 'Start Treasure Hunt',
                        action = function()
                            StartTreasureHunt()
                        end,
                    }
                },
                distance = 2.5
            })
        else
            CreateThread(function()
                while true do
                    Wait(0)
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    if #(playerCoords - Config.PirateNPCLocation.xyz) < 2.0 then
                        DrawText3D(Config.PirateNPCLocation.x, Config.PirateNPCLocation.y, Config.PirateNPCLocation.z + 1.0, "Press ~g~E~w~ to start treasure hunt")
                        if IsControlJustReleased(0, 38) then
                            StartTreasureHunt()
                        end
                    end
                end
            end)
        end
    end
end)


RegisterNetEvent('vd-treasurehunt:useMap', function()
    StartTreasureHunt()
end)


function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
