local GameState = {}

function GameState:enter()

end

function GameState:update(dt)

end

function GameState:draw()

    love.graphics.scale(4, 4)
    love.graphics.setColor(200, 200, 200)
    love.graphics.rectangle('fill', 0, 0, 240, 270)
    love.graphics.setColor(100, 100, 100)
    love.graphics.rectangle('fill', 240, 0, 240, 270)

end

return GameState