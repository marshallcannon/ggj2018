local Corpse = require 'monsters/corpse'

local Monster = Class{
    __includes = Sprite
}

function Monster:init(x, y, image, direction)

    self.image = images.wiggles
    self.imageDead = images.wiggles_dead

    Sprite.init(self, x, y, image)

    self.direction = direction or 'right'

    self.hp = 3
    self.moveSpeed = 30
    self.jumpPower = 100

    game.monsters:add(self)

end

function Monster:update(dt)

    if self.direction == 'right' then
        self.velocity.x = self.moveSpeed
    else
        self.velocity.x = -self.moveSpeed
    end
    Sprite.update(self, dt)

end

function Monster:draw()

    if self.image then
        love.graphics.setColor(255, 255, 255)
        if self.direction == 'right' then
            love.graphics.draw(self.image, self.position.x, self.position.y)
        elseif self.direction == 'left' then
            love.graphics.draw(self.image, self.position.x, self.position.y, 0, -1, 1, self.width)
        end
    else
        Sprite.draw(self)
    end

end

function Monster:distanceToFighter()

    return self.position:dist(game.fighter)

end

function Monster:onShot()

    self.hp = self.hp - 1
    if self.hp <= 0 then self:die() end

end

function Monster:onHitWall()

    if self.direction == 'left' then
        self.direction = 'right'
    else
        self.direction = 'left'
    end

end

function Monster:die()

    Corpse(self)
    self:destroy()

end

function Monster:hitSide()

    self:onHitWall()
    
end

return Monster