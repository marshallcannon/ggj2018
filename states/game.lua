local Fighter = require 'players/fighter/fighter'
local Chef = require 'players/chef/chef'
local Wiggles = require 'monsters/wiggles'
local Shelly = require 'monsters/shelly'
local Stalks = require 'monsters/stalks'
local Hunter = require 'monsters/hunter'
local Kitchen = require 'kitchen/kitchen'
local HellPortal = require 'players/fighter/hellPortal'

local GameState = {}

function GameState:enter(previous, level)

    game.currentLevel = level
    game.score = 0

    --Cooking
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

    self.walls = game.currentLevel:platformFunction()
    for i,wall in ipairs(self.walls) do
        wall.static = true
    end

    HellPortal(game.currentLevel.hellPortalX, game.currentLevel.hellPortalY)

    game.fighter = Fighter(300, 100)
    Wiggles(350, 100)
    Shelly(450, 100)
    Stalks(400, 100)
    Hunter(450, 150)


end

function GameState:update(dt)

    Timer.update(dt)
    game.currentLevel:update(dt)

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
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.background1, 0, 0)
    game.kitchen:draw()
    game.appliances:draw()
    game.items:draw()

    game.chef:draw()

    --Combat Screen
    love.graphics.origin()
    love.graphics.scale(4, 4)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.background2, 240, 0)

    love.graphics.setColor(75, 75, 75)
    for i,wall in ipairs(self.walls) do
        wall:draw('fill')
    end

    game.objects:draw()
    game.monsters:draw()

    game.fighter:draw()

    --Draw timer
    game.currentLevel:draw()

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

function GameState:levelOver()
    print('It\'s over!')
end

return GameState