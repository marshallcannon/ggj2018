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
    self.heldItem = nil

    self.tweenSpeed = 0.2

    self.controller = game.controller.controllerList[1]

end

function Chef:update(dt)

    self:controllerUpdate()

end

function Chef:draw() 

    if self.direction == 'up' then
        love.graphics.setColor(255, 255, 255)
        if self.heldItem then
            love.graphics.draw(self.heldItem.image, self.position.x, self.position.y, 0, 0.5, 0.5)
        end
        love.graphics.draw(images.chef.sheet, images.chef.up, self.position.x, self.position.y)
    elseif self.direction == 'right' then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(images.chef.sheet, images.chef.right, self.position.x, self.position.y)
        if self.heldItem then
            love.graphics.draw(self.heldItem.image, self.position.x, self.position.y, 0, 0.5, 0.5)
        end
    elseif self.direction == 'down' then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(images.chef.sheet, images.chef.down, self.position.x, self.position.y)
        if self.heldItem then
            love.graphics.draw(self.heldItem.image, self.position.x, self.position.y, 0, 0.5, 0.5)
        end
    elseif self.direction == 'left' then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(images.chef.sheet, images.chef.left, self.position.x, self.position.y)
        if self.heldItem then
            love.graphics.draw(self.heldItem.image, self.position.x, self.position.y, 0, 0.5, 0.5)
        end
    end

end

function Chef:controllerUpdate()

    local leftStickDir = self:getStickDirection(self.controller:getAxis(1), self.controller:getAxis(2))
    
    if self.storedDir then
        leftStickDir = self.storedDir
    end

    if leftStickDir and not self.moving then
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
        self.direction = leftStickDir
    else
        self.storedDir = self:getStickDirection(self.controller:getAxis(1), self.controller:getAxis(2))
        if self.storedDir == self.direction then
            self.storedDir =  nil
        end
    end

end

function Chef:joystickpressed(button)

    local gridX, gridY = self:getGridPosition()
    local lookingX, lookingY = self:getLookingPosition()

    if button == 1 then
        if self.heldItem then

            --Try to use appliance
            local appliance = self:findAppliance(lookingX, lookingY)
            if appliance then
                self:useAppliance(appliance)
                return
            end

            --Drop item
            if not self:findItem(lookingX, lookingY) then
                self:dropItem(lookingX, lookingY)
            end

        else

            --Try to pick up item
            print(lookingX, lookingY)
            local item = self:findItem(lookingX, lookingY)
            if item then
                self:pickUp(item)
                return
            end

            --Try to use appliance
            local appliance = self:findAppliance(lookingX, lookingY)
            if appliance then
                self:useAppliance(appliance)
                return
            end

            --Try to pick up item directly below
            local item = self:findItem(gridX, gridY)
            if item then
                self:pickUp(item)
                return
            end

        end
        
    end

end

function Chef:pickUp(item)

    self.heldItem = item
    self.heldItem.held = true

end

function Chef:dropItem(x, y)
    x = x - 1
    y = y - 1
    self.heldItem:moveTo(x*32+game.kitchen.offsetX, y*32+game.kitchen.offsetY)
    self.heldItem.held = false
    self.heldItem = nil
end

function Chef:findItem(x, y)
    for i, item in ipairs(game.items:getAll()) do
        local gridX, gridY = item:getGridPosition()
        if gridX == x and gridY == y then
            return item
        end
    end
end

function Chef:findAppliance(x, y)
    for i, appliance in ipairs(game.appliances:getAll()) do
        local gridX, gridY = appliance:getGridPosition()
        if gridX == x and gridY == y then
            return appliance
        end
    end
end

function Chef:useAppliance(appliance)
    appliance:use(self)
end

function Chef:getStickDirection(leftStickX, leftStickY)

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

    local gridX, gridY = self:getGridPosition()
    local goalX = math.floor(x/32)+1
    local goalY = math.floor(y/32)+1

    if gridX > 0 and gridY > 0 and gridX <= game.kitchen.width and gridY <= game.kitchen.height then
        if game.kitchen.grid[goalY][goalX] == 0 then

            self.moving = true
            self.goal = Vector(x, y)

            Timer.tween(self.tweenSpeed,self,{position = {y = y, x = x}},'in-out-quart',
                function() self.moving=false end)

        end
    end

end

function Chef:getGridPosition()
    return math.floor(self.position.x/game.kitchen.tileSize)+1, math.floor(self.position.y/game.kitchen.tileSize)+1
end

function Chef:getLookingPosition()

    local gridX, gridY = self:getGridPosition()
    local lookingX, lookingY
    if self.direction == 'up' then
        lookingX = gridX
        lookingY = gridY - 1
    elseif self.direction == 'right' then
        lookingX = gridX + 1
        lookingY = gridY
    elseif self.direction == 'down' then
        lookingX = gridX
        lookingY = gridY+1
    elseif self.direction == 'left' then
        lookingX = gridX-1
        lookingY = gridY
    end

    return lookingX, lookingY

end

return Chef