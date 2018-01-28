local Bullet = Class{
    __includes = Sprite
}

function Bullet:init(x, y, velocityX, velocityY, width, height)

    width = width or 6
    height = height or 6
    Sprite.init(self, x-width/2, y-height/2, nil, 5, 5)

    self.velocity.x = velocityX or 0
    self.velocity.y = velocityY or 0
    self.useGravity = false

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

    for i, collision in ipairs(collisions) do

        if collision.body.parent.onShot then
            self:destroy()
            collision.body.parent:onShot()
        end

    end

end

function Bullet:staticCollisions(collisions)

    if #collisions > 0 then self:destroy() end

end

return Bullet