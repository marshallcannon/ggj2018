local Corpse = Class{
    __includes = Sprite
}

function Corpse:init(monster)

    Sprite.init(self, monster.position.x, monster.position.y, monster.imageDead)
    self.velocity = monster.velocity
    self.carried = false

    game.corpses:add(self)

end

function Corpse:update(dt)

    if not self.carried then
    
        Sprite.update(self, dt)

        if self.onGround then
            if math.abs(self.velocity.x) > 0 then
                if math.abs(self.velocity.x) < 0.5 then
                    self.velocity.x = 0
                else
                    self.velocity.x = self.velocity.x * 0.8
                end
            end
        end

    end

end

return Corpse