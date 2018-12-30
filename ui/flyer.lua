local class = require 'lib.middleclass'

local Flyer = class('Flyer')

function Flyer:initialize(drawable, start_x, start_y, dest_x, dest_y)
  self.drawable = drawable
  self.start_x = start_x
  self.start_y = y
  self.dest_x = x
  self.dest_y = y
end

function Flyer:setDest(x, y)
  self.dest_x = x
  self.dest_y = y
end

function Fly:draw()
  if self.dead then return end
  local x = self.start_x * (1-self.completion) + self.dest_x * self.completion
  local y = self.start_y * (1-self.completion) + self.dest_y * self.completion
  love.graphics.draw(self.drawable, x, y)
end

function Fly:destroy()
  self.dead = true
  self = nil
end
