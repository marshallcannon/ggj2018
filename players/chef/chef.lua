local Chef = Class{

}

function Chef:init(x, y)

    self.position = Vector(x, y)
    self.width = 32
    self.height = 32
    self.moving = false
    self.goal = nil
    self.midpoint = nil
    self.direction = 'down'

    self.startSpeed = 150
    self.speed = self.startSpeed
    self.tween = 1.3

    self.stored = nil

    self.controller = game.controller.controllerList[1]

end



function Chef:update(dt)

    self:controllerUpdate()

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

    local leftStickDir = getStickDirection(self.controller:getAxis(1), self.controller:getAxis(2))
    
    if self.storedDir then
        leftStickDir = self.storedDir
    end

    if not self.moving then
        if leftStickDir == 'right' then
            self:setGoal(self.position.x+32, self.position.y)
        elseif leftStickDir == 'left'  then
            self:setGoal(self.position.x-32, self.position.y)
        elseif leftStickDir == 'down' then
            self:setGoal(self.position.x, self.position.y+32)
        elseif leftStickDir == 'up' then
            self:setGoal(self.position.x, self.position.y-32)
        end
        self.storedDir = nil
        self.direction = leftstickDir
    else
        self.storedDir = getStickDirection(self.controller:getAxis(1), self.controller:getAxis(2))
        if self.storedDir == self.direction then
            self.storedDir =  nil
        end
    end

end

function getStickDirection(leftStickX, leftStickY)

    local output = nil

    if math.abs(leftStickX) > math.abs(leftStickY) then
        if leftStickX > game.controller.deadZone then
            output = 'right'
        elseif leftStickX < -game.controller.deadZone then
            output = 'left'
        end
    else
        if leftStickY > game.controller.deadZone then
            output = 'down'
        elseif leftStickY < -game.controller.deadZone then
            output= 'up'
        end
    end

    return output
end

function Chef:setGoal(x, y)

    local gridX = math.floor(x/game.kitchen.tileSize)+1
    local gridY = math.floor(y/game.kitchen.tileSize)+1

    print(gridX, gridY, game.kitchen.width, game.kitchen.height)
    if gridX > 0 and gridY > 0 and gridX <= game.kitchen.width and gridY <= game.kitchen.height then
        self.moving = true
        self.goal = Vector(x, y)

        Timer.tween(0.25,self,{position = {y = y, x = x}},'in-out-quart',
            function() self.moving=false end)
    end

end

return Chef