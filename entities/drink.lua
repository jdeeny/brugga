local class = require 'lib.middleclass'
local entity = require 'entities.entity'
local rect = require 'physics.rect'

local Drink = class('Drink', entityClass())

function Drink:initialize()
  entityClass().initialize(self)

  self.drinkA, self.drinkB, self.drinkC, self.drinkD = false, false, false, false
  self.state = "none"
  -- Set properties
  self.props.isDrink = true;          -- Is a drink

  -- Create collision rectangle
  self.rect:set(0, 0, 24, 24)        -- Set position/size
end

function Drink:update(dt)
  if (self.isActive) then
    if (self.state == "held") then
      -- Update code for drink position while held by bartender
    end
  end
end

function Drink:collisionFilter()
  local filter = function(item, other)
    if (other.props.isEnemy) then

      print("bam")
      self.isActive = false
      return 'touch'
    end

    return nil
  end

  return filter
end

function newDrink()
  return Drink:new()
end
