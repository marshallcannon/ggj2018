Class = require 'libraries/hump/class'
require 'sprites/animation'

AnimationManager = Class {}

function AnimationManager:init(parent)

  self.parent = parent
  self.animationList = {}
  self.layerList = {}
  self.activeAnimation = nil
  self.flippedH = false

end

function AnimationManager:update(dt)

  for i,layer in ipairs(self.layerList) do
    if layer.frames then
      layer.frames:update(dt)
    end
  end

end

function AnimationManager:add(key, sheet, frames, frameWidth, frameHeight, border, durations)

  border = border or 0
  durations = durations or 0.1

  local animation = Animation(key, sheet, frames, frameWidth, frameHeight, border, durations)
  self.animationList[key] = animation

end

function AnimationManager:addLayers(number)

  self.layerList = {}

end

function AnimationManager:play(animation, layer)
  
  if #self.layerList == 0 then self:addLayers(1) end
  layer = layer or 1

  if self.layerList[layer] ~= self:findAnimation(animation) then
    --Reset the currently playing animation
    if self.layerList[layer] then
      self.layerList[layer].frames:gotoFrame(1)
    end
    --Set the new animation to active
    self.layerList[layer] = self:findAnimation(animation)
  end

end

--Resets an animation and then plays it
function AnimationManager:playFresh(animation, layer)

  local anim = self:findAnimation(animation)
  anim.frames:gotoFrame(1)
  self:play(animation, layer)

end

function AnimationManager:findAnimation(animation)

  if animation then
    return self.animationList[animation]
  else
    return {}
  end

end

function AnimationManager:getCurrentAnimation(layer)

  layer = layer or 1
  for key,value in pairs(self.animationList) do
    if value == self.layerList[layer] then return key end
  end

end

function AnimationManager:draw(x, y)

  x = x or self.parent.position.x
  y = y or self.parent.position.y

  for i,layer in ipairs(self.layerList) do
    if layer.frames then
      love.graphics.setColor(255, 255, 255, self.parent.opacity)
      layer.frames.flippedH = self.flippedH
      local animationWidth, animationHeight = layer.frames:getDimensions()
      layer.frames:draw(layer.sheet, x, y, 0, 1, 1, animationWidth/2, animationHeight)
    end
  end

end
