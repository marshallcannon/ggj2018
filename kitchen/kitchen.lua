local Trash = require 'kitchen/trash'
local CookingPot = require 'kitchen/cookingPot'
local OrderSlot = require 'kitchen/orderSlot'

local Kitchen = Class{

}

function Kitchen:init()
    
    self.tileSize = 32
    self.width = math.floor(240/self.tileSize)
    self.height = math.floor(228/self.tileSize)
    self.offsetX = (240-(self.tileSize*self.width))/2
    self.offsetY = 7

    self.slots = {}

    self.grid = {
        {1, 1, 1, 1, 1, 1, 1},
        {0, 0, 0, 0, 0, 0, 0},
        {1, 1, 0, 0, 0, 1, 1},
        {0, 0, 0, 0, 0, 0, 0},
        {1, 1, 0, 0, 0, 1, 1},
        {0, 0, 0, 0, 0, 0, 0},
        {1, 1, 1, 1, 1, 1, 1}
    }

    Trash(self.offsetX+0*32, self.offsetY+6*32)
    CookingPot(self.offsetX+0*32, self.offsetY+4*32)
    CookingPot(self.offsetX+6*32, self.offsetY+4*32)
    table.insert(self.slots, OrderSlot(self.offsetX+2*32, self.offsetY+6*32))
    table.insert(self.slots, OrderSlot(self.offsetX+4*32, self.offsetY+6*32))
    table.insert(self.slots, OrderSlot(self.offsetX+6*32, self.offsetY+6*32))

end

function Kitchen:draw()

    -- for x=0, self.width-1 do
    --     for y=0, self.height-1 do
    --         if (x*self.width+y) % 2 == 0 then love.graphics.setColor(255, 0, 0)
    --         else love.graphics.setColor(255, 255, 255) end
    --         love.graphics.rectangle('fill', self.offsetX + x * self.tileSize, self.offsetY + y * self.tileSize, self.tileSize, self.tileSize)
    --     end
    -- end

    love.graphics.setColor(150, 150, 150)
    love.graphics.rectangle('fill', self.offsetX, self.offsetY, 32*6, 32)

    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.table, self.offsetX+0*32, self.offsetY+2*32)
    love.graphics.draw(images.table, self.offsetX+0*32, self.offsetY+4*32)
    love.graphics.draw(images.table, self.offsetX+5*32, self.offsetY+2*32)
    love.graphics.draw(images.table, self.offsetX+5*32, self.offsetY+4*32)
    love.graphics.draw(images.portal, self.offsetX+6*32+16, self.offsetY+16, love.timer.getTime()*2, 1, 1, 16, 16)
    love.graphics.draw(images.plate, self.offsetX+2*32, self.offsetY+6*32)
    love.graphics.draw(images.plate, self.offsetX+4*32, self.offsetY+6*32)
    love.graphics.draw(images.plate, self.offsetX+6*32, self.offsetY+6*32)

end

function Kitchen:getEmptyOrderSlot()

    local openSlots = {}
    for i,slot in ipairs(self.slots) do
        if not slot.order then table.insert(openSlots, slot) end
    end

    return openSlots[love.math.random(#openSlots)]

end

function Kitchen:getEmptySpace()

    local spaceFree
    for x=0, 5 do
        spaceFree = true
        for i, item in ipairs(game.items:getAll()) do
            local gridX, gridY = item:getGridPosition()
            gridX = gridX - 1
            if gridX == x then
                spaceFree = false
            end
        end
        if spaceFree == true then
            return self.offsetX+x*32, self.offsetY
        end
    end

end

return Kitchen