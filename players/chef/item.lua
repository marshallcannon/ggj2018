local Item = Class{

}

function Item:init(name, x, y, image)

    self.name = name or ''
    self.position = Vector(x, y)
    self.image = image

    self.held = false

    game.items:add(self)

end

function Item:update()

end

function Item:draw()

    if not self.held then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(self.image, self.position.x, self.position.y)
    end

end

function Item:moveTo(x, y)
    self.position.x = x
    self.position.y = y
end

function Item:destroy()

    self.dead = true

end

function Item:getGridPosition()

    if not self.held then
        return math.floor((self.position.x-game.kitchen.offsetX)/32)+1, math.floor((self.position.y-game.kitchen.offsetY)/32)+1
    end

end

return Item