Class = require 'libraries/hump/class'

Animation = Class {}

function Animation:init(key, sheet, frames, frameWidth, frameHeight, border, durations)

  self.key = key
  self.sheet = sheet
  self.grid = Anim8.newGrid(frameWidth, frameHeight, self.sheet:getWidth(), self.sheet:getHeight(), 0, 0, border)
  self.frames = Anim8.newAnimation(self.grid(frames, 1), durations)

end
