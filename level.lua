local Order = require 'kitchen/order'

local Level = Class{

}

function Level:init(platforms)

    self.orders = {}
    self.orderTimings = {3, 4, 5, 6, 7, 8}
    self.timeLimit = 80
    self.levelTime = 0
    self.timeText = love.graphics.newText(fonts.mainSmall, tostring(self.timeLimit))
    self.currentOrder = 1
    self.backOrders = {}

    self.scale = 10

    self.platformList = platforms or {
        --[[Walls]]
        {0,0,1,27},
        {23,0,1,27},
        --[[Bottom Floor]]
        {0,26,9,1},
        {14,26,9,1},
        --[[Long Center Platforms]]
        {4,21,16,1},
        {4,11,16,1},
        --[[Small Side Platforms]]
        {0,16,4,1},
        {20,16,4,1},
        {0,6,4,1},
        {20,6,4,1}
    }

    self.platformFunction = function()
        local output = {}
        for i,object in ipairs(self.platformList) do
            table.insert(output, HC.rectangle(object[1] * self.scale + 240, object[2]  * self.scale, object[3] * self.scale, object[4] * self.scale))
        end
        return output
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