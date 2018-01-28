local HellPortal = Class{
    __includes = Sprite
}

function HellPortal:init(x, y)

    Sprite.init(self, x, y, images.portal)
    self.useGravity = false

    game.objects:add(self)

end

function HellPortal:draw()

    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.portal, self.position.x+16, self.position.y+16, love.timer.getTime()*2, 1, 1, 16, 16)

end

function HellPortal:collisions(collisions)
    
    for i, collision in ipairs(collisions) do

        if collision.body.parent.isCorpse and game.kitchen:getEmptySpace() then
            local kitchenX, kitchenY = game.kitchen:getEmptySpace()
            collision.body.parent.kitchenItem(kitchenX, kitchenY)
            if game.fighter.carryObject and game.fighter.carryObject == collision.body.parent then
                game.fighter:throw()
            end
            collision.body.parent:destroy()
        end

    end

end

return HellPortal