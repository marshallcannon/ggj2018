local Monster = require 'monsters/monster'

local Shelly = Class{
    __includes = Monster
}

function Shelly:init(x, y, direction)

    Monster.init(self, x, y, images.shelly, direction)

    self.imageDead = images.shelly_dead

    self.moveSpeed = self.moveSpeed 

    self.boost = {
        timer = 2,
        multiplier = 4
    }

    self.kitchenItem = game.itemList.Shelly

end

function Shelly:onShot(bullet)
    if self.direction ~= bulletDir(bullet) then
        Monster.onShot(self)
        --Monster.hitSide(self)
        Timer.tween(self.boost.timer,self,{moveSpeed = self.moveSpeed*self.boost.multiplier},"out-cubic", 
                function() Timer.tween(self.boost.timer,self,{moveSpeed = self.moveSpeed/self.boost.multiplier},"in-cubic") end)   
    end
end

function bulletDir(bullet)
    if bullet.velocity.x > 0 then
        return "right"
    else
        return "left"
    end
end

return Shelly