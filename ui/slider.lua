local class = require 'lib.middleclass'
local colors = require 'ui.colors'
local text = require 'ui.text'


local Slider = class('Slider')

function Slider:initialize(min, max, segments, value)
  self.min = min or 0.0
  self.max = max or 1.0
  self.segments = segments or 10
  self.persegment = (self.max - self.min) / self.segments
  self.value = value or 0.0
  self.filled = gameWorld.assets.sprites.ui.segmentFilled
  self.empty = gameWorld.assets.sprites.ui.segmentEmpty
  self.segmentWidth = self.filled:getWidth()
  self.pad = 10
end


function Slider:getWidth()
  return self.segmentWidth * self.segments
end

function Slider:getHeight()
  return self.filled:getHeight()
end

function Slider:lower()
  self.value = self.value - self.persegment
  if self.value < self.min then self.value = self.min end
end

function Slider:raise()
  self.value = self.value + self.persegment
  if self.value > self.max then self.value = self.max end
end

function Slider:draw(x, y)
  -- draw text
  -- draw segments
  local discrete_value = math.floor(self.value / self.persegment + 0.5)
  for seg=0, self.segments - 1 do
    local spr = self.empty
    if seg < discrete_value then
      spr = self.filled
    end
    love.graphics.draw(spr, x + seg * self.segmentWidth, y)
  end
end


return Slider
