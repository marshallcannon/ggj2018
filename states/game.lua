local Fighter = require 'players/fighter/fighter'
local Chef = require 'players/chef/chef'
local Wiggles = require 'monsters/wiggles'
local Kitchen = require 'kitchen/kitchen'

local GameState = {}

function GameState:enter(previous, level)

    --Cooking
    game.itemList = require 'players/chef/items'
    game.items = Group(true)
    game.appliances = Group(true)

    game.kitchen = Kitchen()
    game.chef = Chef(32*3+game.kitchen.offsetX, 32*2+game.kitchen.offsetY)

    game.itemList.Wiggles(game.kitchen.offsetX, game.kitchen.offsetY)
    game.itemList.Wiggles(game.kitchen.offsetX+32, game.kitchen.offsetY)
    game.itemList.Wiggles(game.kitchen.offsetX+64, game.kitchen.offsetY)
    game.itemList.Wiggles(game.kitchen.offsetX+96, game.kitchen.offsetY)
    
    --Combat
    game.objects = Group(true)
    game.monsters = Group()
    game.corpses = Group()

    game.fighter = Fighter(300, 100)
    Wiggles(350, 100)

    self.walls = {}
    table.insert(self.walls, HC.rectangle(240, 0, 10, 270))
    table.insert(self.walls, HC.rectangle(240, 260, 90, 10))
    table.insert(self.walls, HC.rectangle(390, 260, 90, 10))
    table.insert(self.walls, HC.rectangle(470, 0, 10, 270))
    table.insert(self.walls, HC.rectangle(280, 210, 160, 10))
    table.insert(self.walls, HC.rectangle(240, 160, 40, 10))
    table.insert(self.walls, HC.rectangle(440, 160, 40, 10))
    table.insert(self.walls, HC.rectangle(280, 110, 160, 10))
    table.insert(self.walls, HC.rectangle(240, 60, 40, 10))
    table.insert(self.walls, HC.rectangle(440, 60, 40, 10))
    for i,wall in ipairs(self.walls) do
        wall.static = true
    end

end

function GameState:update(dt)

    Timer.update(dt)

    --Cooking
    game.chef:update(dt)
    game.items:update(dt)
    game.appliances:update(dt)

    --Combat
    game.fighter:update(dt)
    game.objects:update(dt)
    game.monsters:update(dt)

end

function GameState:draw()

    --Cooking Screen
    love.graphics.scale(4, 4)
    love.graphics.setColor(200, 200, 200)
    love.graphics.rectangle('fill', 0, 0, 240, 270)
    game.kitchen:draw()
    game.appliances:draw()
    game.items:draw()

    game.chef:draw()

    --Combat Screen
    love.graphics.origin()
    love.graphics.scale(4, 4)

    love.graphics.setColor(100, 100, 100)
    love.graphics.rectangle('fill', 240, 0, 240, 270)

    love.graphics.setColor(255, 255, 255)
    for i,wall in ipairs(self.walls) do
        wall:draw('line')
    end

    game.objects:draw()
    game.monsters:draw()

    game.fighter:draw()

end

function GameState:keypressed(key)

    if key == 'escape' then love.event.quit() end

end

function GameState:joystickpressed(joystick, button)

    if joystick == game.controller.controllerList[1] then
        game.chef:joystickpressed(button)
    elseif joystick == game.controller.controllerList[2] then
        game.fighter:joystickpressed(button)
    end

end

return GameState