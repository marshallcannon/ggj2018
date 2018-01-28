local Order = require 'kitchen/order'

local Level = Class{

}

function Level:init()

    self.orders = {}
    self.orderTimings = {3, 4, 5, 6, 7, 8}
    self.timeLimit = 80
    self.levelTime = 0
    self.timeText = love.graphics.newText(fonts.mainSmall, tostring(self.timeLimit))
    self.currentOrder = 1
    self.backOrders = {}
    self.hellPortalX = 350
    self.hellPortalY = 50
    
    self.platformFunction = function()
        local platforms = {}
        table.insert(platforms, HC.rectangle(240, 0, 10, 270))
        table.insert(platforms, HC.rectangle(240, 260, 90, 10))
        table.insert(platforms, HC.rectangle(390, 260, 90, 10))
        table.insert(platforms, HC.rectangle(470, 0, 10, 270))
        table.insert(platforms, HC.rectangle(280, 210, 160, 10))
        table.insert(platforms, HC.rectangle(240, 160, 40, 10))
        table.insert(platforms, HC.rectangle(440, 160, 40, 10))
        table.insert(platforms, HC.rectangle(280, 110, 160, 10))
        table.insert(platforms, HC.rectangle(240, 60, 40, 10))
        table.insert(platforms, HC.rectangle(440, 60, 40, 10))
        return platforms
    end

    self.spawnList = {}

end

function Level:update(dt)

    self.levelTime = self.levelTime + dt
    self.timeText:set(tostring(math.floor(self.timeLimit-self.levelTime)))

    --If a new order time is up
    if self.orderTimings[self.currentOrder] and self.levelTime >= self.orderTimings[self.currentOrder] then
        local slot = game.kitchen:getEmptyOrderSlot()
        if slot then
            slot:setOrder(self.orders[love.math.random(#self.orders)]:clone())
        else
            table.insert(self.backOrders, self.orders[love.math.random(#self.orders)])
        end
        self.currentOrder = self.currentOrder + 1
    end

    --If we have back orders
    if #self.backOrders > 0 and game.kitchen:getEmptyOrderSlot() then
        local slot = game.kitchen:getEmptyOrderSlot()
        slot:setOrder(self.orders[love.math.random(#self.orders)]:clone())
    end

    --If we're out of time
    if self.levelTime >= self.timeLimit then
        game.states.game:levelOver()
    end

end

function Level:draw()

    love.graphics.setColor(0, 0, 0)
    love.graphics.draw(self.timeText, 480-self.timeText:getWidth(), 10, 0, 1, 1, self.timeText:getWidth()/2)

end

--Add a food order to the level
function Level:addOrder(ingredients, time)

    time = time or 20
    table.insert(self.orders, Order(ingredients, time))

end

--Set the timestamps for orders
function Level:setOrderTimings(...)

    for i, timing in ipairs(arg) do
        table.insert(self.orderTimings, timing)
    end

end

--Set the function for setting platforms
function Level:setPlatformFunction(platformFunction)

    self.platformFunction = platformFunction

end

return Level