local MenuState = {}

function MenuState:enter(previous)

    self.anyKeyText = love.graphics.newText(fonts.mainSmall, 'Press Any Button To Start')
    self.levelNumber = 1
    self.levelText = love.graphics.newText(fonts.mainSmall, tostring('Level '..self.levelNumber))

end

function MenuState:update(dt)

end

function MenuState:draw()

    love.graphics.setColor(255, 255, 255)
    love.graphics.scale(4, 4)
    local scrollX = love.timer.getTime()*50%game.scaledWidth
    love.graphics.draw(images.menuBackground_tile, -scrollX, 0)
    love.graphics.draw(images.menuBackground_tile, game.scaledWidth-scrollX, 0)
    love.graphics.draw(images.menuBackground_noTile, 0, 0)
    love.graphics.draw(self.anyKeyText, 240, 220, 0, 0.5, 0.5, self.anyKeyText:getWidth()/2)
    love.graphics.draw(self.levelText, 240, 240, 0, 0.5, 0.5, self.levelText:getWidth()/2)


end

function MenuState:keypressed(key)

    if key == 'escape' then love.event.quit() end

end

function MenuState:joystickpressed(joystick, button)

    State.switch(game.states.game, game.levels[1])

end

function MenuState:gamepadpressed(joystick, button)

    if button == 'dpright' then
        self.levelNumber = self.levelNumber + 1
    elseif button == 'dpleft' then
        self.levelNumber = self.levelNumber - 1
    end

    if self.levelNumber < 1 then self.levelNumber = #game.levels
    elseif self.levelNumber > #game.levels then self.levelNumber = 1 end

    self.levelText:set('Level '..tostring(self.levelNumber))

end

return MenuState