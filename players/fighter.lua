local Fighter = Class{}

function Fighter:init(x, y)

    self.position = Vector(x, y)

    self.width = 16
    self.height = 16
    self.velocity = Vector(0, 0)
    self.controller = game.controller.controllerList[2]

end

function Fighter:update(dt)

    self:joystickUpdate(dt)

    self.position.x = self.position.x + self.velocity.x*dt

end

function Fighter:draw()

    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', self.position.x, self.position.y, 16, 16)

end

function Fighter:joystickUpdate(dt)

    local value = self.controller:getAxis(1)
    print(value)
    if value > game.controller.deadZone then
        self.velocity.x = value*50
    elseif value < -game.controller.deadZone then
        self.velocity.x = value*50
    else
        self.velocity.x = 0
    end

end

function Fighter:joystickaxis(axis, value)

    if axis == 2 then
        print(value)
        if value > game.controller.deadZone then
            self.velocity.x = value
        elseif value < -game.controller.deadZone then
            self.velocity.x = value
        else
            self.velocity.x = 0
        end
    end

end

return Fighter