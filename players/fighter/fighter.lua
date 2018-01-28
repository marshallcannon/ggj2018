local Bullet = require 'players/fighter/bullet'

local Fighter = Class{
    __includes = Sprite
}

function Fighter:init(x, y)

    Sprite.init(self, x, y, images.wizard_shoot, 16, 16)

    self.controller = game.controller.controllerList[2]
    self.color = {255, 255, 255}

    self.direction = 'right'

    self.maxSpeed = 200
    self.jumpPower = 300
    self.bulletTimerMax = 0.3
    self.bulletTimer = 0
    self.stunned = false
    self.stunnedTime = 1.5
    self.stunnedTimerMax = 0.05
    self.stunnedTimer = self.stunnedTimerMax
    
    game.objects:remove(self)

end

function Fighter:update(dt)

    if self.bulletTimer > 0 then
        self.bulletTimer = self.bulletTimer - dt
    end

    if not self.stunned then
        self:controllerUpdate(dt)
    end

    Sprite.update(self, dt)

    if self.carryObject then
        self.image = images.wizard_hold
        self.carryObject:moveTo(self.position.x+self.width/2-self.carryObject.width/2, self.position.y - 6 - self.carryObject.height)
    else
        self.image = images.wizard_shoot
    end

    if self.stunned then
        self.stunnedTimer = self.stunnedTimer - dt
        if self.stunnedTimer <= 0 then
            self.stunnedTimer = self.stunnedTimerMax
            if self.color[4] == 255 then self.color[4] = 100
            else self.color[4] = 255 end
        end
        if self.onGround then
            if math.abs(self.velocity.x) > 0 then
                if math.abs(self.velocity.x) < 0.5 then
                    self.velocity.x = 0
                else
                    self.velocity.x = self.velocity.x * 0.8
                end
            end
        end
    else
        self.color[4] = 255
    end

end

function Fighter:draw()

    love.graphics.setColor(self.color)
    print(self.color[1])
    if self.direction == 'left' then
        love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1, 1, 0, 4)
    elseif self.direction == 'right' then
        love.graphics.draw(self.image, self.position.x, self.position.y, 0, -1, 1, self.width, 4)
    end

end

function Fighter:controllerUpdate(dt)

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
        if not self.carryObject then
            self:shoot()
        end
    end

end

function Fighter:joystickpressed(button)

    if not self.stunned then
        if button == 1 then
            if self.onGround then
                self:jump()
            end
        elseif button == 3 then
            if self.carryObject then
                self:throw()
            else
                self:pickUp()
            end
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

function Fighter:pickUp()

    local closestCorpse = nil
    local closestDistance = nil
    for i, corpse in ipairs(game.corpses:getAll()) do
        if not closestCorpse then
            closestCorpse = corpse
            closestDistance = self:getCenter():dist(corpse:getCenter())
        else
            if self.position:dist(corpse:getCenter()) < closestDistance then
                closestCorpse = corpse
                closestDistance = self.position:dist(corpse:getCenter())
            end
        end
    end

    if closestCorpse and closestDistance < 20 then
        self.carryObject = closestCorpse
        self.carryObject.carried = true
    end

end

function Fighter:throw()

    if self.direction == 'left' then
        self.carryObject.velocity = Vector(self.velocity.x-100, self.velocity.y-30)
    elseif self.direction == 'right' then
        self.carryObject.velocity = Vector(self.velocity.x+100, self.velocity.y-30)
    end
    self.carryObject.carried = false
    self.carryObject = nil

end

function Fighter:collisions(collisions)

    for i, collision in ipairs(collisions) do
        if collision.body.parent.isMonster then
            if not self.stunned then
                self:getHurt()
                local bounceVector = self:getCenter() - collision.body.parent:getCenter()
                bounceVector = bounceVector:normalizeInplace()
                self.velocity.x = bounceVector.x*200
                self.velocity.y = bounceVector.y*200
            end
        end
    end

end

function Fighter:getHurt()

    self.stunned = true
    Timer.after(self.stunnedTime, function() self.stunned = false; print('stop invincibility') end)

end

return Fighter