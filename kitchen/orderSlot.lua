local Appliance = require 'kitchen/appliance'

local OrderSlot = Class{
    __includes = Appliance
}

function OrderSlot:init(x, y)

    Appliance.init(self, x, y)

    self.order = nil

end

function OrderSlot:update(dt)

    if self.order then self.order:update(dt) end

end

function OrderSlot:draw()

    love.graphics.setColor(188, 138, 84)
    love.graphics.rectangle('fill', self.position.x-32, self.position.y, 64, 32)

    if self.order then
        self.order:draw()
    end

end

function OrderSlot:setOrder(order)

    self.order = order
    self.order:activate(self.position.x-32)
    self.order.slot = self

end

function OrderSlot:use(chef)

    if chef.heldItem and chef.heldItem.ingredients then
        if self.order:checkIfIngredientsMatch(chef.heldItem.ingredients) then
            self.order:complete()
        else
            self.order:fail()
        end
        chef.heldItem:destroy()
        chef.heldItem = nil
    end

end

return OrderSlot