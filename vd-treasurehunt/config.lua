Config = {}

-- General Settings
Config.UseTreasureMapItem = true    -- true = use treasure_map item to start
Config.UseNPC = true                -- true = allow starting from NPC too
Config.UseTarget = true             -- true = use ox_target/qb-target, false = 3D Text [E]

Config.Cooldown = 600 -- seconds (10 min cooldown between hunts)
Config.Stages = 3     -- How many clue stages before final treasure

-- Rewards
Config.CashReward = {min = 1000, max = 2500} -- cash reward range
Config.ItemRewards = {
    "goldbar",
    "diamond",
    "rolex"
}

-- NPC Settings
Config.NPCModel = "s_m_m_pirate_01"  -- pirate ped model
Config.NPCLocation = {
    coords = vector3(-1604.664, 5257.087, 3.974),
    heading = 200.0
}

-- Treasure Props
Config.SpawnProp = true -- spawn a chest/prop at the final location
Config.PropModel = "prop_treasure_chest" -- adjust prop model