Config = {}

-- General Settings
Config.UseTreasureMapItem = false    -- true = use treasure_map item to start
Config.UseNPC = true                -- true = allow starting from NPC too
Config.UseTarget = true             -- true = use ox_target/qb-target, false = 3D Text [E]

Config.Cooldown = 600 -- seconds (10 min cooldown between hunts)
Config.Stages = 3     -- How many clue stages before final treasure

Config.HuntLocations = {
    vector3(-1590.0, 5190.0, 4.0),
    vector3(-1580.0, 5180.0, 4.0),
    -- add more spots
}

-- Rewards
Config.CashReward = {min = 1000, max = 2500} -- cash reward range
Config.ItemRewards = {
    "goldbar",
    "diamond",
    "rolex"
}

-- NPC Settings
Config.NPCModel = "s_m_y_dockwork_01"
Config.NPCLocation = {
    coords = vector3(-1604.64, 5257.08, 2.08),
    heading = 200.0
}

-- Treasure Props
Config.SpawnProp = true -- spawn a chest/prop at the final location
Config.PropModel = "prop_treasure_chest" -- adjust prop model