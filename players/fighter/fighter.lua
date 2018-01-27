local Bullet = require 'players/fighter/bullet'

local Fighter = Class{
    __includes = Sprite
}

function Fighter:init(x, y)

    Sprite.init(self, x, y, nil, 16, 16)

    self.controller = game.controller.controllerList[2]
    self.color = {255, 255, 255}

    self.maxSpeed = 200
    self.jumpPower = 300
    self.bulletTimerMax = 0.3
    self.bulletTimer = 0

end

function Fighter:update(dt)

    if self.bulletTimer > 0 then
        self.bulletTimer = self.bulletTimer -dt
    end

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

    local leftStickX = self.controller:getAxis(1)
    local rightTrigger = self.controller:getAxis(6)

    if leftStickX > game.controller.deadZone then
        self.velocity.x = leftStickX*self.maxSpeed
        self.direction = 'right'
    elseif leftStickX < -game.controller.deadZone then
        self.velocity.x = leftStickX*self.maxSpeed
        self.direction = 'left'
    else
        self.velocity.x = 0
    end

    if rightTrigger > 0 then
        self:shoot()
    end

end

function Fighter:joystickpressed(button)

    if button == 1 then
        if self.onGround then
            self:jump()
        end
    end

end

function Fighter:shoot()

    local dt = love.timer.getDelta()
    if self.bulletTimer <= 0 then
        if self.direction == 'left' then
            Bullet(self.position.x+self.width/2, self.position.y+self.height/2, -300)
        else
            Bullet(self.position.x+self.width/2, self.position.y+self.height/2, 300)
        end
        self.bulletTimer = self.bulletTimerMax
    end

end

return Fighter