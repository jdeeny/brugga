local class = require 'lib.middleclass'
local rect = require 'physics.rect'

local Entity = class('Entity')

function Entity:initialize()
  self.isActive = false
  self.rect = newRect()         -- Init rectangle
  self.props = {}               -- Init properties
  self.rect.props = self.props  -- Store property info in rect
end

function entityClass()
  return Entity
end

function Entity:addToWorld(world)
  world:add(self.rect, self.rect.x, self.rect.y, self.rect.w, self.rect.h)
end
