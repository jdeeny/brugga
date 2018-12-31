local class = require 'lib.middleclass'
local Entity = require 'entities.entity'
local rect = require 'physics.rect'

local Drink = class('Drink', Entity)

function Drink:initialize(overlay)
  Entity.initialize(self)

  self.drinkMix = {}

  self.overlay = overlay

  -- Set properties
  self.props.isDrink = true;          -- Is a drink
  self.props.drinkMix = self.drinkMix
  self.props.state = "none"
  self.props.ref = self
  self.tween = {}

  -- Create collision rectangle
  self.rect:set(0, 0, 64, 64)        -- Set position/size
  self.drawColor = { 1.0, 0.2, 0.2, 1.0 }

  self.drawOffset = { x = 0, y = 0 }
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
  self.rect:setPos(780 + (self.row * 20), (self.row * 185) - 30)  -- Set position on row
  self.bumpWorld:update(self.rect, self.rect.x, self.rect.y, self.rect.w, self.rect.h)
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
  self.rect:setPos(x, (self.row * 185) - 30)
  self.props.state = "toBartender"
  self.props.drinkMix = {}
end

---- BAR ACTIONS --
function Drink:caught()
  if self.props.state == "falling" then self:stopFall() end -- Stop fall tweens
  self.overlay:addTipFlyer(.5, self.rect.x + self.rect.w / 2, self.rect.y + self.rect.h / 2)
  self:deactivate()
end

function Drink:slideOffBar()
  self.props.state = "falling"
  self.tween.fallMove = flux.to(self.rect, .5, { x = self.rect.x + 100, y = self.rect.y + 150 }):ease("circin"):oncomplete(function()
    self.overlay:addTipFlyer(-0.25, self.rect.x + self.rect.w / 2, self.rect.y + self.rect.h / 2)
    self:deactivate()
  end)
  self.tween.fallSpin = flux.to(self.rect, .5, { spin = 2 * math.pi }):ease('circin'):oncomplete(function() self.rect.spin = 0 end)
end

function Drink:deactivate()
  self.isActive = false
  self.props.state = "none"
  self.bumpWorld:remove(self.rect)
end

function Drink:stopFall()
  self.tween.fallMove:stop()
  self.tween.fallSpin:stop()
end
---- UPDATE ----

function Drink:update(dt)
  if self.isActive then
    if self.props.state == "held" then
      -- Nothing here
    elseif self.props.state == "toCustomer" then
      local actualX, actualY, cols, len = self.bumpWorld:move(self.rect, self.rect.x - (300 * dt), self.rect.y, self:collisionFilter())
      self.rect.x = actualX

      if len > 0 then self:startCollision(cols) end

    elseif self.props.state == "drinking" then
      -- Nothing here
    elseif self.props.state == "toBartender" then
      local actualX, actualY, cols, len = self.bumpWorld:move(self.rect, self.rect.x + (100 * dt), self.rect.y, self:collisionFilter())
      self.rect.x = actualX

      local player, pLen = self.bumpWorld:queryRect(self.rect.x, self.rect.y, self.rect.w, self.rect.h, self:playerFilter())
      if pLen > 0 then self:caught() end

      if len > 0 then self:endCollision(cols) end
    elseif self.props.state == "falling" then
      local player, pLen = self.bumpWorld:queryRect(self.rect.x, self.rect.y, self.rect.w, self.rect.h, self:playerFilter())
      if pLen > 0 then self:caught() end
    end

  end
end

---- DRAW ----

function Drink:draw()
  if self.isActive and self.props.state ~= "drinking" then
    love.graphics.setColor(1.0,1.0,1.0,1.0)
    love.graphics.draw(
    gameWorld.assets.sprites.game.tankard,
    self.rect.x + gameWorld.assets.sprites.game.tankard:getWidth() / 2 + self.drawOffset.x,
    self.rect.y + gameWorld.assets.sprites.game.tankard:getHeight() / 2 + self.drawOffset.y,
    self.rect.spin,
    1, 1,
    gameWorld.assets.sprites.game.tankard:getWidth() / 2, gameWorld.assets.sprites.game.tankard:getHeight() / 2)

    local drinkOffset = { x = self.rect.x + 30, y = self.rect.y + 15 }

    if self.props.drinkMix['a'] then
      love.graphics.draw(gameWorld.assets.sprites.game.tankard_PURPLE,
      self.rect.x + gameWorld.assets.sprites.game.tankard:getWidth() / 2 + self.drawOffset.x,
      self.rect.y + gameWorld.assets.sprites.game.tankard:getHeight() / 2 + self.drawOffset.y,
      self.rect.spin,
      1, 1,
      gameWorld.assets.sprites.game.tankard:getWidth() / 2, gameWorld.assets.sprites.game.tankard:getHeight() / 2)
    end
    if self.props.drinkMix['b'] then
      love.graphics.draw(gameWorld.assets.sprites.game.tankard_GREEN,
      self.rect.x + gameWorld.assets.sprites.game.tankard:getWidth() / 2 + self.drawOffset.x,
      self.rect.y + gameWorld.assets.sprites.game.tankard:getHeight() / 2 + self.drawOffset.y,
      self.rect.spin,
      1, 1,
      gameWorld.assets.sprites.game.tankard:getWidth() / 2, gameWorld.assets.sprites.game.tankard:getHeight() / 2)
    end
    if self.props.drinkMix['c'] then
      love.graphics.draw(gameWorld.assets.sprites.game.tankard_CYAN,
      self.rect.x + gameWorld.assets.sprites.game.tankard:getWidth() / 2 + self.drawOffset.x,
      self.rect.y + gameWorld.assets.sprites.game.tankard:getHeight() / 2 + self.drawOffset.y,
      self.rect.spin,
      1, 1,
      gameWorld.assets.sprites.game.tankard:getWidth() / 2, gameWorld.assets.sprites.game.tankard:getHeight() / 2)
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

function Drink:playerFilter()
  local filter = function(item)
    -- Empty drink caught by bartender
    if item.props.isPlayer and (self.props.state == "toBartender" or self.props.state == "falling") then
      return 'cross'
    end

    return nil
  end

  return filter
end



-- Collision with bartender bar end
function Drink:endCollision(cols)
  -- Check for bartender first
  for i,col in ipairs(cols) do
    local other = col.other
    if other.props.isPlayer and self.props.state == "toBartender" then
      self:caught()
      do return end
    end
  end
  -- Then check for end of bar
  for i,col in ipairs(cols) do
    local other = col.other
    if other.props.isEnd and self.props.state == "toBartender" then
      self:slideOffBar()
      do return end
    end
  end
end

-- Falling collision
function Drink:fallCollision(cols)
  -- Check for bartender first
  for i,col in ipairs(cols) do
    local other = col.other
    if other.props.isPlayer and self.props.state == "toBartender" then
      self:caught()
      do return end
    end
  end
end

-- Collision with entrance bar end
function Drink:startCollision(cols)
  for i,col in ipairs(cols) do
    local other = col.other
    if other.props.isStart and self.props.state == "toCustomer" then
      print("this is the end")
      self:slideOffBar()
      do return end
    end
  end
end

---- NEW OBJECT ----

return Drink
