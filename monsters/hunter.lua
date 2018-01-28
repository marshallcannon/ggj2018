local Monster = require 'monsters/monster'

local Hunter = Class{
    __includes = Monster
}

function Hunter:init(x, y, direction)

    Monster.init(self, x, y, images.teeth, direction)

    self.imageDead = images.teeth_dead

    self.hp = 5

    self.moveSpeed = self.moveSpeed * 1

    self.jumpPower = 200

    self.doubleJumpTimer = .2

    self.jumped = false
end

function Hunter:update(dt)

    Monster.update(self, dt)

    if not self.onGround then
        if not self.jumped then
            self.jumped = true
            self:jump()
        end
    else
        if self.hitWall then
            Monster.onHitWall(self)
            self.hitWall = false
        end
        self.jumped = false
    end

end


function Hunter:onShot()

    if self.position.x - game.fighter.position.x > 0 then
        self.direction = "left"
    else
        self.direction = "right"
    end

    self.moveSpeed = self.moveSpeed * 1.25
    self.jumped = true;
    self:jump()
    
    Monster.onShot(self)

end

function Hunter:jump()
    self.jumpPower = 200
    Monster.jump(self)
    Timer.after(self.doubleJumpTimer, function() 
        self.jumpPower = 125
        Monster.jump(self)
    end)
end

function Hunter:onHitWall()
    self.hitWall = true
end
return Hunter