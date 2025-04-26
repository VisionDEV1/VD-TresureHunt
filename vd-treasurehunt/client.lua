local isHunting = false
local currentStage = 0
local huntCoords = {}
local blip = nil


-- Configure these to your liking
local clues = {
    "The map shows an old tree by the coast...",
    "The map points to a rocky hilltop...",
    "The trail leads to a ruined shack...",
    "The map hints at a lonely bridge...",
    "The drawing shows a pier full of seagulls..."
}

-- Configure these to your liking
local locations = {
    vector3(-1600.0, 5260.0, 4.0),
    vector3(-1378.0, 6752.0, 3.0),
    vector3(2440.0, -1835.0, 51.5),
    vector3(2000.0, 3000.0, 45.0),
    vector3(-1000.0, 4400.0, 50.0)
}

-- Dont touch below here.

function StartTreasureHunt()
    if isHunting then
        QBCore.Functions.Notify("You are already on a hunt!", "error")
        return
    end

    isHunting = true
    currentStage = 1
    huntCoords = ShuffleLocations(Config.Stages)

    NextClue()
end

function NextClue()
    if currentStage > Config.Stages then
        -- Final treasure
        CreateTreasure(huntCoords[currentStage - 1])
        return
    end

    if blip then RemoveBlip(blip) end

    local coords = huntCoords[currentStage]
    blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, 587)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Treasure Clue")
    EndTextCommandSetBlipName(blip)

    local clueText = clues[math.random(#clues)]
    QBCore.Functions.Notify(clueText, "primary")

    CreateThread(function()
        local playerPed = PlayerPedId()
        while #(GetEntityCoords(playerPed) - coords) > 3.0 do
            Wait(1000)
        end

        currentStage = currentStage + 1
        NextClue()
    end)
end

function CreateTreasure(coords)
    if blip then RemoveBlip(blip) end

    local prop = nil
    if Config.SpawnProp then
        RequestModel(Config.PropModel)
        while not HasModelLoaded(Config.PropModel) do
            Wait(10)
        end
        prop = CreateObject(Config.PropModel, coords.x, coords.y, coords.z - 1.0, true, true, false)
        PlaceObjectOnGroundProperly(prop)
    end

    local treasureBlip = AddBlipForCoord(coords)
    SetBlipSprite(treasureBlip, 587)
    SetBlipScale(treasureBlip, 1.0)
    SetBlipColour(treasureBlip, 46)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Buried Treasure")
    EndTextCommandSetBlipName(treasureBlip)

    QBCore.Functions.Notify("You sense the treasure nearby!", "success")

    CreateThread(function()
        local playerPed = PlayerPedId()
        while #(GetEntityCoords(playerPed) - coords) > 3.0 do
            Wait(1000)
        end

        TriggerServerEvent("treasurehunt:reward")
        if prop then DeleteEntity(prop) end
        if treasureBlip then RemoveBlip(treasureBlip) end

        isHunting = false
    end)
end

function ShuffleLocations(amount)
    local temp = {}
    local copy = {table.unpack(locations)}
    for i = 1, amount do
        local index = math.random(#copy)
        table.insert(temp, copy[index])
        table.remove(copy, index)
    end
    return temp
end

RegisterNetEvent('treasurehunt:useMap', function()
    StartTreasureHunt()
end)

CreateThread(function()
    if Config.UseNPC then
        RequestModel(Config.NPCModel)
        while not HasModelLoaded(Config.NPCModel) do
            Wait(0)
        end
        local npc = CreatePed(0, Config.NPCModel, Config.NPCLocation.coords, Config.NPCLocation.heading, false, true)
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
                        end
                    }
                },
                distance = 2.5
            })
        else
            CreateThread(function()
                while true do
                    local sleep = 1000
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    if #(playerCoords - Config.NPCLocation.coords) < 2.0 then
                        sleep = 5
                        DrawText3D(Config.NPCLocation.coords.x, Config.NPCLocation.coords.y, Config.NPCLocation.coords.z + 1.0, "Press ~g~E~w~ to start Treasure Hunt")
                        if IsControlJustReleased(0, 38) then
                            StartTreasureHunt()
                        end
                    end
                    Wait(sleep)
                end
            end)
        end
    end
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end