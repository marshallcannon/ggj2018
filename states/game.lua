local GameState = {}

function GameState:enter(previous, level)

    self.fighter = require('players/fighter')(300, 100)

    self.walls = {}
    table.insert(self.walls, HC.rectangle(240, 0, 10, 270))
    table.insert(self.walls, HC.rectangle(240, 260, 240, 10))
    table.insert(self.walls, HC.rectangle(470, 0, 10, 270))
    table.insert(self.walls, HC.rectangle(240, 0, 240, 10))
    for i,wall in ipairs(self.walls) do
        wall.static = true
    end

end

function GameState:update(dt)

    self.fighter:update(dt)

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

    self.fighter:draw()

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