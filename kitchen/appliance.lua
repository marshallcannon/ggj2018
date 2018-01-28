local Appliance = Class{

}

function Appliance:init(x, y)

    self.position = Vector(x, y)

    game.appliances:add(self)

end

function Appliance:update(dt)

end

function Appliance:draw()

end

function Appliance:use(chef)

end

function Appliance:getGridPosition()

    return math.floor((self.position.x-game.kitchen.offsetX)/32)+1, math.floor((self.position.y-game.kitchen.offsetY)/32)+1

end

return Appliance