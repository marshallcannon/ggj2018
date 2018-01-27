Class = require 'libraries/hump/class'
Vector = require 'libraries/hump/vector'
require 'sprites/animationManager'

Sprite = Class {
  objectType = 'Sprite'
}

function Sprite:init(x, y, image, id, addBody)

  self.position = Vector(x, y)
  if type(image) == 'userdata' then
    self.image = image
  else
    self.image = image[1]
    self.quad = image[2]
  end
  if self.image then
    if self.quad then
      local quadX, quadY, quadWidth, quadHeight = self.quad:getViewport()
      self.width = quadWidth
      self.height = quadHeight
    else
      self.width = self.image:getWidth()
      self.height = self.image:getHeight()
    end
  else
    self.width = 50
    self.height = 50
  end
  self.id = id or love.math.random()
  self:changeRoom(game.world:getRoomAtCoordinates(self.position.x, self.position.y))

  if addBody ~= false then
    self.body = self:addBody()
  end

  self.animations = AnimationManager(self)

  self.rotation = 0
  self.velocity = Vector(0, 0)
  self.deceleration = 1
  self.drawOffset = Vector(0, 0)
  self.hitboxSize = {width = self.width, height = self.height}
  self.visible = true
  self.opacity = 255

  self.drawRed = false
  self.dead = false

  self.debugGroup = {}

end

function Sprite:update(dt)

  self:moveWithVelocity(dt)
  self:decelerate(dt)

  self:animationStates()
  self.animations:update(dt)

  self:updateRoom()

end

function Sprite:draw()

  if self.visible then

    if self.drawRed then love.graphics.setShader(Shaders.red) end

      local image, quad, x, y, rotation, scaleX, scaleY, offsetX, offsetY, opacity
      if self.image then image = self.image else image = nil end
      if self.quad then quad = self.quad else quad = nil end
      if self.position.x then x = self.position.x else x = 0 end
      if self.position.y then y = self.position.y else y = 0 end
      if self.rotation then rotation = self.rotation else rotation = 0 end
      if self.scale then scaleX = self.scale.x else scaleX = 1 end
      if self.scale then scaleY = self.scale.y else scaleY = 1 end
      if self.drawOffset then offsetX = self.drawOffset.x; offsetY = self.drawOffset.y; else offsetX = 0; offsetY = 0; end
      if self.opacity then opacity = self.opacity else opacity = 255 end

      --If we have any animation layers, play animations
      if #self.animations.layerList ~= 0 then
        self.animations:draw()
      --Otherwise draw our still image
      elseif image then
        if quad then
          love.graphics.setColor(255, 255, 255, opacity)
          love.graphics.draw(image, quad, x, y, rotation, scaleX, scaleY, self.width/2+offsetX, self.height+offsetY)
        else
          love.graphics.setColor(255, 255, 255, opacity)
          love.graphics.draw(image, x, y, rotation, scaleX, scaleY, self.width/2+offsetX, self.height+offsetY)
        end
      else
        love.graphics.setColor(255, 0, 0, opacity)
        love.graphics.rectangle('fill', x, y, self.width, self.height)
      end

      if game.debug then
        self:drawBody()
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.points(x, y)
        love.graphics.setColor(0, 255, 0, 255)
        for name,drawable in pairs(self.debugGroup) do
          love.graphics.setColor(drawable.r, drawable.g, drawable.b, drawable.a)
          if drawable.type == 'line' then
            love.graphics.line(drawable.x1, drawable.y1, drawable.x2, drawable.y2)
          elseif drawable.type == 'rectangle' then
            love.graphics.rectangle('fill', drawable.x, drawable.y, drawable.width, drawable.height)
          end
        end
      end

    if self.drawRed then love.graphics.setShader() end

  end

end

function Sprite:drawBody()

  if self.body then
    love.graphics.setColor(255, 255, 255, 255)
    self.body:draw()
  end

end

function Sprite:move(x, y)

  self.position.x = self.position.x + x; self.position.y = self.position.y + y
  if self.body then
    --The +1 keeps the origin inside the hitbox... probably a bad idea
    self.body:moveTo(self.position.x, self.position.y-self.hitboxSize.height/2+1)
  end

end

function Sprite:moveTo(x, y)

  if self.body then
    self.body:moveTo(x, y)
    self.position.x, self.position.y = self.body:center()
    self.position.y = self.position.y + self.hitboxSize.height/2
  else
    self.position.x = x; self.position.y = y
  end

end

function Sprite:moveTowards(dt, x, y, speed)

  local moveSpeed = speed or self.speed
  local goal = Vector(x, y)
  local directionVector = goal - self.position
  local movementVector = directionVector:trimmed(moveSpeed*dt)
  self:move(movementVector:unpack())

end

function Sprite:moveWithVelocity(dt)

  x = self.velocity.x * dt
  y = self.velocity.y * dt

  self:move(x, y)

end

function Sprite:stopMoving()

  self.velocity.x = 0
  self.velocity.y = 0

end

function Sprite:updateRoom()
  if self.room then
    if self.position.x < self.room.worldX or self.position.x > self.room.worldX + self.room.width or
    self.position.y < self.room.worldY or self.position.y > self.room.worldY + self.room.height then
      self:changeRoom(game.world:getRoomAtCoordinates(self.position.x, self.position.y))
    end
  else
    self:changeRoom(game.world:getRoomAtCoordinates(self.position.x, self.position.y))
  end
end

function Sprite:changeRoom(room)

  if self.room then
    self.room:removeObject(self)
  end
  self.room = room
  self.room:addObject(self)

end

function Sprite:handleCollisions(dt)

  local collisions = Collision.collisions(self.body)
  local wallCollisions = {}
  for other, separatingVector in pairs(collisions) do
    if other.parent then
      if other.parent.objectType == 'Wall' then table.insert(wallCollisions, {wall = other, sv = separatingVector})
      elseif other.parent.objectType == 'Door' then table.insert(wallCollisions, {wall = other, sv = separatingVector})
      else
        --Only server handles non-solid collisions
        if game.online.isHost then
          self:collide(dt, other.parent, separatingVector)
        end
      end
    else end
  end
  table.sort(wallCollisions, function(a,b) return self:overlap(a.wall)>self:overlap(b.wall) end)
  self:collideWalls(wallCollisions)

end

function Sprite:collide(dt, objectHit, separatingVector)

end

function Sprite:collideWalls(wallCollisions)

end

function Sprite:addBody(width, height)

  local bodyWidth, bodyHeight
  if self.scale then
    bodyWidth = self.width * self.scale.x
    bodyHeight = self.height * self.scale.y
  else
    bodyWidth = self.width
    bodyHeight = self.height
  end

  if width then bodyWidth = width end
  if height then bodyHeight = height end

  local body = Collision.rectangle(self.position.x-self.width/2, self.position.y-self.height, bodyWidth, bodyHeight)
  body.parent = self
  return body

end

function Sprite:setDimensions(width, height)

  self.width = width
  self.height = height

end

function Sprite:resizeBody(width, height)

  if self.body then

    Collision.remove(self.body)
    self.body = nil

  end

  local newBody = Collision.rectangle(self.position.x-self.width, self.position.y-self.height*2, width, height)
  newBody.parent = self
  self.body = newBody
  self.hitboxSize.width = width
  self.hitboxSize.height = height

end

function Sprite:setDrawOffset(x, y)

  self.drawOffset.x = x
  self.drawOffset.y = y

end

function Sprite:destroy()

  if self.body then
    Collision.remove(self.body)
    self.body = nil
  end
  self.dead = true
  game.online:destroy(self)

end

function Sprite:setVelocity(x, y)

  if not self.velocity then self.velocity = {x = 0, y = 0} end

  self.velocity.x = x
  self.velocity.y = y

end

function Sprite:addToVelocity(x, y)

  self.velocity.x = self.velocity.x + x
  self.velocity.y = self.velocity.y + y

end

function Sprite:getAngleFromVector(vector)

  local angleRadians = math.atan2(vector.y, vector.x)
  return angleRadians

end

function Sprite:getVectorFromAngle(angle)

  local vector = Vector(0, 0)
  vector.x = math.cos(angle)
  vector.y = math.sin(angle)
  return vector

end

function Sprite:stop()

  self.velocity.x = 0
  self.velocity.y = 0

end

function Sprite:decelerate(dt, deceleration)

  if deceleration == nil then deceleration = self.deceleration end
  deceleration = deceleration * dt

  if self.velocity.x > 0 then
    if self.velocity.x - deceleration < 0 then self.velocity.x = 0
    else self.velocity.x = self.velocity.x - deceleration end
  elseif self.velocity.x < 0 then
    if self.velocity.x + deceleration > 0 then self.velocity.x = 0
    else self.velocity.x = self.velocity.x + deceleration end
  end

  if self.velocity.y > 0 then
    if self.velocity.y - deceleration < 0 then self.velocity.y = 0
    else self.velocity.y = self.velocity.y - deceleration end
  elseif self.velocity.y < 0 then
    if self.velocity.y + deceleration > 0 then self.velocity.y = 0
    else self.velocity.y = self.velocity.y + deceleration end
  end

end

function Sprite:overlap(other)

  local axmin, aymin, axmax, aymax = self.body:bbox()
  local bxmin, bymin, bxmax, bymax = other:bbox()
  local dx = math.min(axmax, bxmax) - math.max(axmin, bxmin)
  local dy = math.min(aymax, bymax) - math.max(aymin, bymin)
  return dx*dy

end

function Sprite:animationStates()

end

function Sprite:getCenter()
  local centerX = self.position.x + self.width/2
  local centerY = self.position.y + self.height/2
  return centerX, centerY
end

function Sprite:getCenterVector()

  local centerX, centerY = self:getCenter()
  return Vector(centerX, centerY)

end

--Convert the Sprite into a table for serialization
function Sprite:serialize()

  --TODO figure out how to send image
  local addBody = false
  if self.body then addBody = true end
  return {objectType = self.objectType, x = self.position.x, y = self.position.y, id = self.id, addBody = addBody}

end

--Create the Sprite from a table
function Sprite:create(data)

  return Sprite(data.x, data.y, nil, data.id, data.addBody)

end

--Make a table of the relevant attributes for updating the Sprite
function Sprite:serializeUpdate()

  return {objectType='sprite', x=self.position.x, y=self.position.y}

end

--Update the Sprite from a table
function Sprite:updateFromData(data)

  --TODO figure out how to implement image
  self.x = data.x
  self.y = data.y

end

function Sprite:runCommand(command)

end