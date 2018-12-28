local class = require 'lib.middleclass'
local entity = require 'entities.entity'
local rect = require 'physics.rect'

local Drink = class('Drink', entityClass())

function Drink:initialize()
  entityClass().initialize(self)

  self.drinkMix = { a = false, b = false, c = false, d = false}
  self.state = "none"
  -- Set properties
  self.props.isDrink = true;          -- Is a drink

  -- Create collision rectangle
  self.rect:set(0, 0, 24, 24)        -- Set position/size
end

---- STATES ----

-- Set drink hold state position based on row. Called by Brugga entity
-- when changing rows.
function Drink:bartenderHold(row)
  self.row = row
  self.rect:setPos(1000 + (self.row * 20), 100 + (self.row * 100))
end

-- Send drink to the left on the bar
function Drink:sendLeft()
  self.state = "toCustomer" -- Set toCustomer state
  self.rect:setPos(950 + (self.row * 20), 80 + (self.row * 100))  -- Set position on row
end

-- Set drinking state when hitting patron
function Drink:patronHold()
  self.state = "drinking"
end

-- Set position while customer drinks
function Drink:startDrinking(x, y)
  self.rect:setPos(x, y)
end

-- Send drink to the right on the bar
function Drink:sendRight(x)
  self.rect:setPos(x, 80 + (self.row * 100))
  self.state = "toBartender"
end

---- BAR ACTIONS --

function Drink:slideOffBar()
  self:deactivate()
end

function Drink:deactivate()
  self.isActive = false
  self.bumpWorld:remove(self.rect)
end

---- UPDATE ----

function Drink:update(dt)
  if self.isActive then
    if self.state == "held" then
      -- Nothing here
    elseif self.state == "toCustomer" then
      self.x = self.x - (100 * dt)
    elseif self.state == "drinking" then
      -- Nothing here
    elseif self.state == "toBartender" then
      self.x = self.x + (75 * dt)
    end
  end
end

---- DRAW ----

function Drink:draw()
  if (self.isActive) then
    love.graphics:setColor(1, .2, .2, 1)
    entityClass().draw(self)
  end
end

---- COLLISION ----

function Drink:collisionFilter()
  local filter = function(item, other)
    -- Empty drink hits bar end by bartender
    if other.props.isEnd and self.state == "toBartender" then
      return self:endCollision(other)

    -- Drink hits bar end by entrance
    elseif other.props.isStart and self.state == "toCustomer" then
      return self:startCollision(other)
    end

    return nil
  end

  return filter
end

-- Collision with bartender bar end
function Drink:endCollision(endZone)
  print("empty drink, booo")
  endZone:drinkReachedEnd()
  self:slideOffBar()
  return 'touch'
end

-- Collision with entrance bar end
function Drink:startCollision(startZone)
  print("no one ordered this")
  startZone:drinkReachedEnd()
  self:slideOffBar()
  return 'touch'
end

function newDrink()
  return Drink:new()
end
