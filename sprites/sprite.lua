Sprite = Class{}

function Sprite:init(x, y, image)

    self.position = Vector(x, y)
    self.image = image

    self.velocity = Vector(0, 0)
    self.onGround = false
    self.maxSpeed = 30
    self.jumpPower = 50

end

function Sprite:update(dt)

    if self.body then
        self:gravity(dt)
    end

    self:move(self.velocity.x*dt, self.velocity.y*dt)

    if self.body then
        local collisions, staticCollisions = self:getCollisions()
        self:collisions(collisions)
        self:staticCollisions(staticCollisions)
    end

end

function Sprite:draw()

    love.graphics.setColor(255, 255, 255)
    if self.image then love.graphics.draw(self.image, self.position.x, self.position.y) end

end

function Sprite:move(x, y)

    self.position.x = self.position.x + x
    self.position.y = self.position.y + y
    if self.body then
        self.body:moveTo(self.position.x+self.width/2, self.position.y+self.height/2)
    end

end

function Sprite:jump(jumpPower)

    jumpPower = jumpPower or self.jumpPower
    print(jumpPower)
    if self.onGround then
        self.velocity.y = self.velocity.y - jumpPower
    end

end

function Sprite:gravity(dt)

    self.velocity.y = self.velocity.y + game.gravity*dt

end

function Sprite:getCollisions()

    local allCollisions = HC.collisions(self.body)
    local collisions, staticCollisions = {}, {}

    for body, separatingVector in pairs(allCollisions) do

        if body.static then table.insert(staticCollisions, {body = body, separatingVector = separatingVector})
        else collisions[body] = separatingVector end

    end

    return collisions, staticCollisions

end

function Sprite:collisions(collisions)

    for other, separatingVector in pairs(collisions) do

    end

end

function Sprite:staticCollisions(collisions)

    self.onGround = false
    table.sort(collisions, function(a,b) return self:getOverlap(self.body, a.body)>self:getOverlap(self.body, b.body) end)
    for i, collision in pairs(collisions) do
        if self:getOverlap(self.body, collision.body) > 0 then
            self:move(collision.separatingVector.x, collision.separatingVector.y)
            if collision.separatingVector.y < 0 then
                self.velocity.y = 0
                self.onGround = true
            end
        end
    end

end

function Sprite:getOverlap(body1, body2)

    local axmin, aymin, axmax, aymax = body1:bbox()
    local bxmin, bymin, bxmax, bymax = body2:bbox()
    local dx = math.min(axmax, bxmax) - math.max(axmin, bxmin)
    local dy = math.min(aymax, bymax) - math.max(aymin, bymin)
    return dx*dy

end

return Sprite