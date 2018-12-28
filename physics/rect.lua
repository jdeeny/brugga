local class = require 'lib.middleclass'

local Rect = class('Rect')

Rect.dimensions = function()
  return self.x, self.y, self.w, self.h
end

function Rect:initialize()
  self.name = "rect"
  self:set(0,0,0,0)
  self.props = {}
end

function Rect:set(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
end

function Rect:setPos(x, y)
  self:set(x, y, self.w, self.h)
end

function Rect:setSize(w, h)
  self:set(self.x, self.y, w, h)
end

function Rect:dimensions()
  return self.x, self.y, self.w, self.h
end

return Rect
