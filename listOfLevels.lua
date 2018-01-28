local Level = require 'level'
local Wiggles = require 'monsters/wiggles'
local Shelly = require 'monsters/shelly'
local Stalks = require 'monsters/stalks'
local Hunter = require 'monsters/hunter'

local Levels = {}

Levels[1] = Level({
    --[[Walls]]
    {0,0,1,27},
    {23,0,1,27},
    --[[Bottom Floor]]
    {0,26,9,1},
    {14,26,9,1},
    --[[Long Center Platforms]]
    {4,21,16,1},
    {4,11,16,1},
    --[[Small Side Platforms]]
    {0,16,4,1},
    {20,16,4,1},
    {0,6,4,1},
    {20,6,4,1}
})
Levels[1]:addOrder({game.itemList.Wiggles, game.itemList.Wiggles})
Levels[1]:addOrder({game.itemList.Wiggles})
Levels[1]:addOrder({game.itemList.Wiggles})
Levels[1]:addOrder({game.itemList.Wiggles})
Levels[1]:addOrder({game.itemList.Wiggles})
Levels[1]:addOrder({game.itemList.Wiggles})
Levels[1].spawnList = {Wiggles}

Levels[2] = Level({
    --[[Walls]]
    {0,0,1,27},
    {23,0,1,27},
    --[[Long Center Platforms]]
    {4,26,16,1},
    {4,16,16,1},
    {4,6,16,1},
    --[[Small Side Platforms]]
    {0,21,4,1},
    {20,21,4,1},
    {0,11,4,1},
    {20,11,4,1},
    {0,2,3,1},
    {21,2,3,1}
})
Levels[2]:addOrder({game.itemList.Wiggles, game.itemList.Wiggles})
Levels[2]:addOrder({game.itemList.Hunter, game.itemList.Hunter})
Levels[2]:addOrder({game.itemList.Wiggles, game.itemList.Wiggles})
Levels[2]:addOrder({game.itemList.Hunter, game.itemList.Hunter})
Levels[2]:addOrder({game.itemList.Wiggles, game.itemList.Hunter})
Levels[2].spawnList = {Wiggles,Hunter}
Levels[2].spawnRate = 8

Levels[3] = Level({
    --[[Walls]]
    {0,0,1,27},
    {23,0,1,27},
    --[[Long Center Platforms]]
    {3,26,5,1},
    {12,26,7,1},
    {7,16,7,1},
    {18,16,5,1},
    {3,6,5,1},
    {12,6,7,1},
    --[[Small Side Platforms]]
    {0,21,4,1},
    {21,21,4,1},
    {0,11,4,1},
    {21,11,4,1},
    {0,1,4,1},
    {21,1,4,1}
})
Levels[3]:addOrder({game.itemList.MiniStalks,game.itemList.MiniStalks})
Levels[3]:addOrder({game.itemList.MiniStalks})
Levels[3]:addOrder({game.itemList.MiniStalks,game.itemList.MiniStalks, game.itemList.MiniStalks})
Levels[3]:addOrder({game.itemList.Shelly})
Levels[3].spawnList = {Stalks,Stalks,Shelly}
Levels[3].spawnRate = 8

return Levels
