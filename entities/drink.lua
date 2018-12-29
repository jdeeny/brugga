local class = require 'lib.middleclass'
local Entity = require 'entities.entity'
local rect = require 'physics.rect'

local Drink = class('Drink', Entity)

function Drink:initialize()
  Entity.initialize(self)

  self.drinkMix = {}

  -- Set properties
  self.props.isDrink = true;          -- Is a drink
  self.props.drinkMix = self.drinkMix
  self.props.state = "none"
  self.props.ref = self

  -- Create collision rectangle
  self.rect:set(0, 0, 24, 24)        -- Set position/size
  self.drawColor = { 1.0, 0.2, 0.2, 1.0 }
end

---- STATES ----

-- Set drink hold state position based on row. Called by Brugga entity
-- when changing rows.
function Drink:bartenderHold(row)
  self.row = row
  self.rect:setPos(1000 + (self.row * 40), 15 + (self.row * 185))
end

-- Send drink to the left on the bar
function Drink:sendLeft()
  self.props.state = "toCustomer" -- Set toCustomer state
  self.rect:setPos(780 + (self.row * 40), -30 + (self.row * 185))  -- Set position on row
end

-- Set drinking state when hitting patron
function Drink:patronHold()
  print("[drink] held, changing to drinking state")
  self.props.state = "drinking"
end

-- Set position while customer drinks
function Drink:startDrinking(x, y)
  print("[drink] starting drinking")
  self.rect:setPos(x, y)
end

-- Send drink to the right on the bar
function Drink:sendRight(x)
  self.rect:setPos(x, -30 + (self.row * 185))
  self.props.state = "toBartender"
end

---- BAR ACTIONS --

function Drink:slideOffBar()
  self:deactivate()
end

function Drink:deactivate()
  self.isActive = false
  self.props.state = "none"
  self.bumpWorld:remove(self.rect)
end

---- UPDATE ----

function Drink:update(dt)
  if self.isActive then
    if self.props.state == "held" then
      -- Nothing here
    elseif self.props.state == "toCustomer" then
      local actualX, actualY, cols, len = self.bumpWorld:move(self.rect, self.rect.x - (225 * dt), self.rect.y, self:collisionFilter())
      self.rect.x = actualX
      self.bumpWorld:update(self.rect, self.rect.x, self.rect.y)

      if len > 0 then self:startCollision(cols) end

    elseif self.props.state == "drinking" then
      -- Nothing here
    elseif self.props.state == "toBartender" then
      local actualX, actualY, cols, len = self.bumpWorld:move(self.rect, self.rect.x + (100 * dt), self.rect.y, self:collisionFilter())
      self.rect.x = actualX

      self.bumpWorld:update(self.rect, self.rect.x, self.rect.y)

      if len > 0 then self:endCollision(cols) end
    end


  end
end

---- DRAW ----

function Drink:draw()
  if self.isActive and self.props.state ~= "drinking" then
    love.graphics.setColor(1.0,1.0,1.0,1.0)
    love.graphics.draw(gameWorld.assets.sprites.game.tankard, self.rect.x, self.rect.y - 50)

    if self.props.drinkMix['a'] then
      love.graphics.setColor(1.0, 0.0, 0.0, 1.0)
      love.graphics.rectangle('fill', self.rect.x + 80, self.rect.y, 16, 16)
    end
    if self.props.drinkMix['b'] then
      love.graphics.setColor(0.0, 1.0, 0.0, 1.0)
      love.graphics.rectangle('fill', self.rect.x + 80, self.rect.y + 16, 16, 16)
    end
    if self.props.drinkMix['c'] then
      love.graphics.setColor(0.0, 0.0, 1.0, 1.0)
      love.graphics.rectangle('fill', self.rect.x + 80, self.rect.y + 32, 16, 16)
    end
  end

end

---- COLLISION ----

function Drink:collisionFilter()
  local filter = function(item, other)
    -- Empty drink hits bar end by bartender
    if other.props.isEnd and self.props.state == "toBartender" then
      return 'touch'

    -- Drink hits bar end by entrance
    elseif other.props.isStart and self.props.state == "toCustomer" then
      return 'touch'
    end

    return nil
  end

  return filter
end

-- Collision with bartender bar end
function Drink:endCollision(cols)
  for i,col in ipairs(cols) do
    local other = col.other
    if other.props.isEnd and self.props.state == "toBartender" then
      --endZone:drinkReachedEnd()
      self:slideOffBar()
      do return end
    end
  end
end

-- Collision with entrance bar end
function Drink:startCollision(cols)
  for i,col in ipairs(cols) do
    local other = col.other
    if other.props.isStart and self.props.state == "toCustomer" then
      --startZone:drinkReachedEnd()
      print("this is the end")
      self:slideOffBar()
      do return end
    end
  end
end

---- NEW OBJECT ----

return Drink
