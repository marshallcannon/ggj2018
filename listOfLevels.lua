local Level = require 'level'

local Levels = {}

Levels[1] = Level()
Levels[1]:addOrder({game.itemList.MiniStalk, game.itemList.Wiggles}, 3)

Levels[2] = Level()

return Levels