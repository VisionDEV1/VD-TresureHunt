[![TREASURE-HUNT.png](https://i.postimg.cc/Kc3QPPDc/TREASURE-HUNT.png)](https://postimg.cc/nMZvZQWN)
# VD-TreasureHunt

An interactive treasure hunt script for QBCore.
start a treasure hunt either by using a custom Treasure Map item or talking to a pirate NPC. Follow clues across the map, find hidden locations, and dig up a randomized reward!


## Features

- Start treasure hunt via Treasure Map item or Pirate NPC (configurable)

- Supports ox_target / qb-target or 3D Text [E] for NPC interaction (configurable)

- Randomized clues and locations for each hunt

- Configurable number of stages before final treasure

- Treasure rewards: Cash and/or Random Items (configurable)

- Buried treasure prop spawn at final location (optional)

- Built-in cooldown system to prevent spam

- Clean, optimized, and easy to customize
## Requirements

 - [QBCORE Framework](https://github.com/qbcore-framework)

 - (Optional) ox_target or qb-target (falls back to 3D Text if not using target)



## Installation

Place the script in your resources folder ``(e.g., /resources/[qb]/vd-treasurehunt)``

Add ``ensure vd-treasurehunt`` to your server.cfg

Add the treasure_map item to your qb-core/shared/items.lua

```lua
["treasure_map"] = {"name": "treasure_map", "label": "Treasure Map", "weight": 50, "type": "item", "image": "treasure_map.png", "unique": true, "useable": true, "shouldClose": true, "combinable": nil, "description": "An ancient map leading to hidden treasure."},
```

Add the usable item handler to your server

```lua
QBCore.Functions.CreateUseableItem("treasure_map", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent('treasurehunt:useMap', source)
        Player.Functions.RemoveItem("treasure_map", 1)
    end
end)
```

(Optional) Configure the script in config.lua (rewards, stages, prop, target type, etc.)
    
## Support

For support, DM me on Discord - VisionGaming


## License

[GPL 3.0](https://choosealicense.com/licenses/gpl-3.0/)

