local Appliance = require 'kitchen/appliance'
local PreparedFood = require 'players/chef/preparedFood'

local CookingPot = Class{
    __includes = Appliance
}

function CookingPot:init(x, y)

    Appliance.init(self, x, y)

    self.ingredients = {}
    self.cookingProgress = 0
    self.cookingTime = 5
    self.burnProgress = 0
    self.burnTime = 5
    self.doneCooking = false

end

function CookingPot:update(dt)

    if #self.ingredients > 0 and self.cookingProgress < self.cookingTime then
        self.cookingProgress = self.cookingProgress + dt
        if self.cookingProgress >= self.cookingTime then
            self.doneCooking = true
        end
    end

end

function CookingPot:draw()

    if #self.ingredients > 0 then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(images.pot_full, self.position.x, self.position.y)
        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle('fill', self.position.x+2, self.position.y + 24,
            28*(self.cookingProgress/self.cookingTime), 4)
    else
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(images.pot_empty, self.position.x, self.position.y)
    end

end

function CookingPot:use(chef)

    if chef.heldItem then
        self:addItem(chef.heldItem)
        chef.heldItem = nil
    else
        if self.doneCooking then
            chef.heldItem = PreparedFood(self.ingredients)
            self.ingredients = {}
            self.doneCooking = false
        end
    end

end

function CookingPot:addItem(item)
    table.insert(self.ingredients, item.__index)
end

return CookingPot