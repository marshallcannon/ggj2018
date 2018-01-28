local Appliance = require 'kitchen/appliance'
local PreparedFood = require 'players/chef/preparedFood'

local CookingPot = Class{
    __includes = Appliance
}

function CookingPot:init(x, y)

    Appliance.init(self, x, y)

    self.ingredients = {}
    self.cookingProgress = 0
    self.cookingTime = 10
    self.burnProgress = 0
    self.burnTime = 10
    self.burnt = false
    self.doneCooking = false
    self.color = {255, 255, 255}

end

function CookingPot:update(dt)

    if #self.ingredients > 0 then
        if self.cookingProgress < self.cookingTime then
            self.cookingProgress = self.cookingProgress + dt
            if self.cookingProgress >= self.cookingTime then
                self.doneCooking = true
            end
        elseif not self.burnt then
            self.burnProgress = self.burnProgress + dt
            self.color[2] = 255 * (1-self.burnProgress/self.burnTime)
            self.color[3] = 255 * (1-self.burnProgress/self.burnTime)
            if self.burnProgress >= self.burnTime then
                self.burnt = true
            end
        end
    end

end

function CookingPot:draw()

    if #self.ingredients > 0 then
        if self.doneCooking then

            if self.burnt then
                love.graphics.setColor(255, 255, 255)
                love.graphics.draw(images.pot_burnt, self.position.x, self.position.y)
            else
                love.graphics.setColor(self.color)
                love.graphics.draw(images.pot_done, self.position.x, self.position.y)
                for i,ingredient in pairs(self.ingredients) do
                    love.graphics.draw(ingredient.image, self.position.x+6+((i-1)%2)*8, self.position.y+7+math.floor((i-1)/2)*8,
                        0.25, 0.25)
                end
            end

        else

            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(images.pot_cooking, self.position.x, self.position.y)

            for i,ingredient in pairs(self.ingredients) do
                love.graphics.draw(ingredient.image, self.position.x+6+((i-1)%2)*8, self.position.y+7+math.floor((i-1)/2)*8,
                    0.25, 0.25)
            end

            love.graphics.setColor(0, 255, 0)
            love.graphics.rectangle('fill', self.position.x+2, self.position.y + 24,
                28*(self.cookingProgress/self.cookingTime), 4)

        end
    else
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(images.pot_empty, self.position.x, self.position.y)
    end

end

function CookingPot:use(chef)

    if self.burnt then
        self.ingredients = {}
        self.burnt = false
    else
        if chef.heldItem then
            if #self.ingredients < 4 then
                self:addItem(chef.heldItem)
                chef.heldItem = nil
            end
        else
            if self.doneCooking then
                chef.heldItem = PreparedFood(0, 0, self.ingredients)
                chef.heldItem.held = true
                self.ingredients = {}
                self.doneCooking = false
            end
        end
    end

end

function CookingPot:addItem(item)
    table.insert(self.ingredients, item.__index)
    self.cookingProgress = 0
    self.burnProgress = 0
    self.doneCooking = false
end

return CookingPot