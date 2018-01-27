local Fighter = require 'players/fighter/fighter'
local Monster = require 'monsters/monster'

local GameState = {}

function GameState:enter(previous, level)

    game.objects = Group(true)
    game.monsters = Group(true)

    self.fighter = Fighter(300, 100)
    local newMonster = Monster(350, 100)

    self.walls = {}
    table.insert(self.walls, HC.rectangle(240, 0, 10, 270))
    table.insert(self.walls, HC.rectangle(240, 260, 90, 10))
    table.insert(self.walls, HC.rectangle(390, 260, 90, 10))
    table.insert(self.walls, HC.rectangle(470, 0, 10, 270))
    table.insert(self.walls, HC.rectangle(280, 220, 160, 10))
    for i,wall in ipairs(self.walls) do
        wall.static = true
    end

end

function GameState:update(dt)

    self.fighter:update(dt)
    game.objects:update(dt)
    game.monsters:update(dt)

end

function GameState:draw()

    love.graphics.scale(4, 4)
    love.graphics.setColor(200, 200, 200)
    love.graphics.rectangle('fill', 0, 0, 240, 270)
    love.graphics.setColor(100, 100, 100)
    love.graphics.rectangle('fill', 240, 0, 240, 270)

    love.graphics.setColor(255, 255, 255)
    for i,wall in ipairs(self.walls) do
        wall:draw('line')
    end

    game.objects:draw()
    game.monsters:draw()

    self.fighter:draw()

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

end

function GameState:keypressed(key)

    if key == 'escape' then love.event.quit() end

end

function GameState:joystickpressed(joystick, button)

    if joystick == game.controller.controllerList[1] then

    elseif joystick == game.controller.controllerList[2] then
        self.fighter:joystickpressed(button)
    end

end

return GameState