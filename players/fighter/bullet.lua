local Bullet = Class{
    __includes = Sprite
}

function Bullet:init(x, y, velocityX, velocityY)

    Sprite.init(self, x, y, nil, 5, 5)

    self.velocity.x = velocityX or 0
    self.velocity.y = velocityY or 0
    print(self.velocity.x, self.velocity.y)
    self.useGravity = false

    game.objects:add(self)

end

function Bullet:update(dt)

    Sprite.update(self, dt)

end

function Bullet:draw()

    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle('fill', self.position.x, self.position.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255)

end

function Bullet:collisions(collisions)



end

function Bullet:staticCollisions(collisions)

    if #collisions > 0 then self:destroy() end

end

return Bullet