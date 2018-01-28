local Appliance = require 'kitchen/appliance'

local Trash = Class{
    __includes = Appliance
}

function Trash:init(x, y)

    Appliance.init(self, x, y)

end

function Trash:draw()

    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.trashcan, self.position.x, self.position.y)

end

function Trash:use(chef)
    if chef.heldItem then
        chef.heldItem:destroy()
        chef.heldItem = nil
    end
end

return Trash