local class = require 'lib.middleclass'

local Flyer = class('Flyer')

function Flyer:initialize(drawable, start_x, start_y, dest_x, dest_y)
  self.drawable = drawable
  self.start_x = start_x
  self.start_y = start_y
  self.dest_x = dest_x
  self.dest_y = dest_y
  self.completion = 0
  self.w = drawable:getWidth()
  self.h = drawable:getHeight()
end

function Flyer:setDest(x, y)
  self.dest_x = x
  self.dest_y = y
end

function Flyer:draw()
  if self.dead then return end
  local x = self.start_x * (1-self.completion) + self.dest_x * self.completion
  local y = self.start_y * (1-self.completion) + self.dest_y * self.completion
  love.graphics.setColor(1.0,1.0,1.0,1.0)
  love.graphics.draw(self.drawable, x, y, self.rotation or 0, 0.6 + math.sqrt(self.completion) * 0.4, 0.6 + math.sqrt(self.completion) * 0.4, self.w/2, self.h/2)
end

function Flyer:destroy()
  self.dead = true
  self = nil
end

return Flyer
