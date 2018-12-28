local class = require 'lib.middleclass'
local Entity = require 'entities.entity'
local rect = require 'physics.rect'

local Dude = class('Dude', Entity)

function Dude:initialize()
  Entity.initialize(self)
  self.props.isPlayer = true
  self.row = 1
  self.moveDir = "none"
  self.moveDelay = 0

  -- Create collision rectangle
  self.rect:set(80, 10, 64, 64)
end

function Dude:update(dt)
  if (self.moveDir ~= "none") then
    self:changeRow(dt)
  end
end

function Dude:changeRow(dt)
  if (self.moveDelay > 0) then
    self.moveDelay = self.moveDelay - dt
    do return end
  end

  if (self.moveDir == "up") then
    self.row = self.row - 1
  elseif (self.moveDir == "down") then
    self.row = self.row + 1
  end

  if (self.row <= 1) then
    self.row = 1
  elseif (self.row >= 4) then
    self.row = 4
  end

  self.moveDelay = 1/15
  self.rect.x = 1000 + (self.row * 20)
  self.rect.y = (self.row * 100) + 100
end

function Dude:moveUp()
  self.moveDir = "up"
end

function Dude:moveDown()
  self.moveDir = "down"
end

function Dude:moveNone()
  self.moveDir = "none"
end

function Dude:collisionFilter()
  local filter = function(item, other)
    if (other.props.isEnemy) then
      print("ow")
      return 'slide'
    end

    return nil
  end

  return filter
end

---- NEW OBJECT ----

return Dude
