local Appliance = require 'kitchen/appliance'

local Trash = Class{
    __includes = Appliance
}

function Trash:init(x, y)

    Appliance.init(self, x, y)

end

function Trash:draw()

    love.graphics.setColor(100, 100, 100)
    love.graphics.circle('fill', self.position.x+16, self.position.y+16, 16)

end

function Trash:use(chef)
    if chef.heldItem then
        chef.heldItem:destroy()
        chef.heldItem = nil
    end
end

return Trash