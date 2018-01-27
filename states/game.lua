local GameState = {}

function GameState:enter(previous, level)

    self.fighter = require('players/fighter')(100, 100)

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

    self.fighter:draw()

end

return GameState