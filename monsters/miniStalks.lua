local Monster = require 'monsters/monster'

local MiniStalks = Class{
    __includes = Monster
}

function MiniStalks:init(x, y, direction)

    Monster.init(self, x, y, images.miniStalks, direction)

    self.imageDead = images.miniStalks_dead

    self.moveSpeed = self.moveSpeed * 1.4

    self.jumpPower = 225

    self.kitchenItem = game.itemList.MiniStalk
end

function MiniStalks:update(dt)

    Monster.update(self, dt)

    if self.onGround then
        self:jump()
    end

end

return MiniStalks