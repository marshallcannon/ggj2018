local Kitchen = Class{

}

function Kitchen:init()
    
    self.tileSize = 32
    self.width = math.floor(240/self.tileSize)
    self.height = math.floor(270/self.tileSize)
    self.offsetX = (240-(self.tileSize*self.width))/2
    self.offsetY = (270-(self.tileSize*self.height))/2

end

function Kitchen:draw()

    for x=0, self.width-1 do
        for y=0, self.height-1 do
            if (x*self.width+y) % 2 == 0 then love.graphics.setColor(255, 0, 0)
            else love.graphics.setColor(255, 255, 255) end
            love.graphics.rectangle('fill', self.offsetX + x * self.tileSize, self.offsetY + y * self.tileSize, self.tileSize, self.tileSize)
        end
    end

end

return Kitchen