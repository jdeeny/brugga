local class = require 'lib.middleclass'
local entity = require 'entities.entity'
local rect = require 'physics.rect'

---- INIT ----

local Enemy = class('Enemy', entityClass())

function Enemy:initialize()
  entityClass().initialize(self)  -- Run base class init

  self.drinkMix = { a = false, b = false, c = false, d = false} -- Desired drink
  self.state = "advance"  -- Current operational state
  self.hitDelay = 2       -- Hit state duration
  self.drinkDelay = .5    -- Drinking state duration
  -- Set properties
  self.props.isEnemy = true;          -- Is an enemy

  -- Create collision rectangle
  self.rect:set(300, 156, 64, 64)        -- Set position/size

  ---- Drink properties
  self.drink = nil
  -- Create drink position offsets for patron
  self.drinkHoldOffset = { x = self.rect.w, y = 0 }
  self.drinkDrinkingOffset = {x = self.rect.w / 2, y = self.rect.h / -2}
  -- Set current drink offset
  self.drinkOffset = self.drinkHoldOffset
  -- Return current drink offset + current position
  self.drinkAttachPoint = function()
    return self.rect.x + self.drinkOffset.x, self.rect.y + self.drinkOffset.y
  end
end

---- SPAWN ----

function Enemy:spawnEnemy(enemyType, row)
  self.isActive = true
  if (enemyType == "OnlyA") then self.drinkMix.a = true end   -- Enemy only wants drink A
  if (enemyType == "OnlyB") then self.drinkMix.b = true end   -- Enemy only wants drink B
  self.rect:setPos(320 - (20 * row), 120 + (100 * row) - self.rect.h) -- set at start of specific row
end

---- DRINK ACTIONS ----

function Enemy:drinkHit(drink)
    self.drink = drink  -- Store drink that collided
    self.state = "hit"  -- Set hit state
    self.drink:patronHold()   -- Set drink's drinking state
    self.drinkOffset = self.drinkHoldOffset -- Set the drink position offset
end

function Enemy:startDrinking()
  self.hitDelay = 2     -- Reset hit timer
  self.state = "drink"  -- Set drinking state
  self.drinkOffset = self.drinkDrinkingOffset   -- Set drinking drink offset
  self.drink:startDrinking(self.drinkAttachPoint)    -- Apply drinking position to drink
end

function Enemy:stopDrinking()
  self.drinkDelay = .5    -- Reset drink timer
  self.state = "advance"  -- Set advance state
  self.drink:sendRight(self.rect.x + self.rect.w) -- Slide drink back from end of patron
  self.drink = nil        -- Customer no longer holding drink
end

---- BAR ACTIONS ----
function Enemy:exited()
  self.isActive = false   -- Patron is no longer active
  self.drink:deactivate() -- Drink is no longer active
end

function Enemy:deactivate()
  self.isActive = false
  self.bumpWorld:remove(self.rect)
end

---- UPDATE ----

function Enemy:update(dt)
  if (self.isActive) then
    -- Advance towards the player
    if (self.state == "advance") then
      self.rect.x = self.rect.x + (20 * dt) -- Move forwards

    -- Fly backwards when hit by drink
    elseif (self.state == "hit") then
      if (self.hitDelay > 0) then
        self.rect.x = self.rect.x - (100 * dt)        -- Move backwards
        self.hitDelay = self.hitDelay - dt            -- Advance hold timer
        self.drink.rect:setPos(self.drinkAttachPoint) -- Set drink position
      else
        self:startDrinking()  -- Start drinking state when hold timer ends
      end

    -- Pause and drink after being hit
    elseif (self.state == "drink") then
      if (self.drinkDelay > 0) then
        self.drinkDelay = self.drinkDelay - dt  -- Advance drink timer
      else
        self:stopDrinking()   -- Start advancing state when done drinking
      end
    end

  end
end

---- DRAW ----

function Enemy:draw()
  if (self.isActive) then
    love.graphics:setColor(.2, 1, .2, 1)
    entityClass().draw(self)
  end
end

---- COLLISION ----

function Enemy:collisionFilter()
  local filter = function(item, other)
    -- Detected drink going out
    if other.props.isDrink and self.state == "advance" then
      return self:checkDrinkCollision(other)

    -- Reached end of bar
    elseif other.props.isEnd and self.state == "advance" then
      return self:endCollision(other)

    -- Reached beginning of bar in hit state
    elseif other.props.isStart and self.state == "hit" then
      return self:startCollision()
    end

    -- Ignore all other collisions
    return nil
  end

  return filter
end

-- Collision with drink
function Enemy:checkDrinkCollision(drink)
  -- If drink is heading out and matches patron's mix, register collision
  if drink.state == "toCustomer" and self.drinkMix == drink.drinkMix then
    print("bam")
    self:drinkHit(drink)
    return 'cross'
  end

  return nil
end

-- Collision with end of bar
function Enemy:endCollision(endZone)
  print("ay bartender")
  endZone:patronReachedEnd()
  self:reachedEnd()
  return 'cross'
end

-- Collision with start of bar
function Enemy:startCollision()
  print("i'm outs")
  self:exited()
  return 'cross'
end

---- NEW OBJECT ----

function newEnemy()
  return Enemy:new()
end
