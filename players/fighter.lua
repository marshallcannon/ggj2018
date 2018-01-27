local Fighter = Class{
    __includes = Sprite
}

function Fighter:init(x, y)

    Sprite.init(self, x, y)

    self.width = 16
    self.height = 16
    self.body = HC.rectangle(self.position.x, self.position.y, self.width, self.height)
    self.body.parent = self
    self.controller = game.controller.controllerList[2]
    self.color = {255, 255, 255}

    self.maxSpeed = 200
    self.jumpPower = 300

end

function Fighter:update(dt)

    self:joystickUpdate(dt)

    Sprite.update(self, dt)

    if self.onGround then self.color = {0, 255, 0}
    else self.color = {0, 0, 255} end

end

function Fighter:draw()

    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.position.x, self.position.y, 16, 16)

end

function Fighter:joystickUpdate(dt)

    local value = self.controller:getAxis(1)

    if value > game.controller.deadZone then
        self.velocity.x = value*self.maxSpeed
    elseif value < -game.controller.deadZone then
        self.velocity.x = value*self.maxSpeed
    else
        self.velocity.x = 0
    end

end

function Fighter:joystickpressed(button)

    if button == 1 then
        self:jump()
    end

end

return Fighter