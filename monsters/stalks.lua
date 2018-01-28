local Monster = require 'monsters/monster'
local MiniStalks = require 'monsters/miniStalks'

local Stalks = Class{
    __includes = Monster
}

function Stalks:init(x, y, direction)

    Monster.init(self, x, y, images.stalks, direction)

    self.moveSpeed = self.moveSpeed * 1.2

    self.jumpPower = 200
end

function Stalks:update(dt)

    Monster.update(self, dt)

    if self.onGround then
        self:jump()
    end

end


function Stalks:die()

    MiniStalks(self.position.x + 5, self.position.y - 10, "right")
    MiniStalks(self.position.x - 5, self.position.y - 10, "left")  
    self:destroy()

end

return Stalks