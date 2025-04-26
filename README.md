# VD-TresureHunt
A QB-Core Treasure Hunt Script.

-- Add to qb-core/shared/items.lua
```lua
["treasure_map"] = {"name": "treasure_map", "label": "Treasure Map", "weight": 50, "type": "item", "image": "treasure_map.png", "unique": true, "useable": true, "shouldClose": true, "combinable": nil, "description": "An ancient map leading to hidden treasure."},
```

-- Add to your usable items
```lua
QBCore.Functions.CreateUseableItem("treasure_map", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent('treasurehunt:useMap', source)
        Player.Functions.RemoveItem("treasure_map", 1)
    end
end)
```