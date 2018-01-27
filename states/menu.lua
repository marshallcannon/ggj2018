local MenuState = {}

function MenuState:enter(previous)

end

function MenuState:update(dt)

end

function MenuState:draw()

    love.graphics.print('menu', 50, 50)

end

return MenuState