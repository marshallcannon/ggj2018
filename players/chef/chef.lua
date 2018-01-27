local Chef = Class{

}

function Chef:init(x, y)

    self.position = Vector(x, y)
    self.width = 32
    self.height = 32
    self.moving = false
    self.goal = nil
    self.direction = 'down'

    self.speed = 150

    self.controller = game.controller.controllerList[1]

end

function Chef:update(dt)

    self:controllerUpdate()

    if self.goal and self.moving then
        if self.position:dist(self.goal) <= self.speed*dt then
            self.position = self.goal
            self.moving = false
            self.goal = nil
        else
            if self.position.x < self.goal.x then
                self.position.x = self.position.x + self.speed*dt
            elseif self.position.x > self.goal.x then
                self.position.x = self.position.x - self.speed*dt
            elseif self.position.y < self.goal.y then
                self.position.y = self.position.y + self.speed*dt
            elseif self.position.y > self.goal.y then
                self.position.y = self.position.y - self.speed*dt
            end
        end
    end

end

function Chef:draw()

    love.graphics.setColor(100, 0, 255)
    love.graphics.rectangle('fill', self.position.x+4, self.position.y+4, self.width-8, self.height-8)

    love.graphics.setColor(0, 255, 0)
    if self.direction == 'up' then
        love.graphics.rectangle('fill', self.position.x + 14, self.position.y + 2, 4, 4)
    elseif self.direction == 'right' then
        love.graphics.rectangle('fill', self.position.x + 26, self.position.y + 14, 4, 4)
    elseif self.direction == 'down' then
        love.graphics.rectangle('fill', self.position.x + 14, self.position.y + 26, 4, 4)
    elseif self.direction == 'left' then
        love.graphics.rectangle('fill', self.position.x + 2, self.position.y + 14, 4, 4)
    end

end

function Chef:controllerUpdate()

    local leftStickX = self.controller:getAxis(1)
    local leftStickY = self.controller:getAxis(2)

    if not self.moving then
        if math.abs(leftStickX) > math.abs(leftStickY) then
            if leftStickX > game.controller.deadZone then
                self:setGoal(self.position.x+32, self.position.y)
                self.direction = 'right'
            elseif leftStickX < -game.controller.deadZone then
                self:setGoal(self.position.x-32, self.position.y)
                self.direction = 'left'
            end
        else
            if leftStickY > game.controller.deadZone then
                self:setGoal(self.position.x, self.position.y+32)
                self.direction = 'down'
            elseif leftStickY < -game.controller.deadZone then
                self:setGoal(self.position.x, self.position.y-32)
                self.direction = 'up'
            end
        end
    end

end

function Chef:setGoal(x, y)

    local gridX = math.floor(x/game.kitchen.tileSize)+1
    local gridY = math.floor(y/game.kitchen.tileSize)+1

    print(gridX, gridY, game.kitchen.width, game.kitchen.height)
    if gridX > 0 and gridY > 0 and gridX <= game.kitchen.width and gridY <= game.kitchen.height then
        self.moving = true
        self.goal = Vector(x, y)
    end

end

return Chef