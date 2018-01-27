local Monster = Class{
    __includes = Sprite
}

function Monster:init(x, y, image, direction)

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

function Monster:distanceToFighter()

    return self.position:dist(game.states.game.fighter)

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

    self:destroy()

end

function Monster:hitSide()

    self:onHitWall()
    
end

return Monster