local Level = require 'level'

local Levels = {}

Levels[1] = Level()
Levels[1]:addOrder({game.itemList.Wiggles, game.itemList.Wiggles, game.itemList.Wiggles, game.itemList.Wiggles})
Levels[1]:addOrder({game.itemList.Wiggles})

return Levels