local class = require 'lib.middleclass'
local Entity = require 'entities.entity'
local rect = require 'physics.rect'

---- INIT ----

local Enemy = class('Enemy', Entity)

function Enemy:initialize(data, overlay)
  Entity.initialize(self)  -- Run base class init

  -- Read enemy data
  self.tagsets = data.tagsets
  self.speed = data.speed
  self.row = data.row
  self.drinkMix = data.drink -- Desired drink
  self.overlay = overlay
  self.reward = data.threat

  self.animations = data.animations
  self.images = data.images

  -- Set properties
  self.isActive = true
  self.state = "advance"  -- Current operational state
  self.advanceState = "walk"
  self.advanceStateTimer = 2
  self.hitDelay = 1.5       -- Hit state duration
  self.drinkDelay = .5    -- Drinking state duration
  self.props.isEnemy = true          -- Is an enemy

  -- Create collision rectangle
  self.rect:set(300, 156, 64, 64)        -- Set position/size
  self.drawColor = { 0.2, 1.0, 0.2, 1.0 }

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

  self.rect:setPos(220 - (75 * self.row), 17 + (183 * self.row) - self.rect.h) -- set at start of specific row
end

---- DRINK ACTIONS ----

function Enemy:drinkHit(drink)
    self.drink = drink  -- Store drink that collided
    self.state = "hit"  -- Set hit state
    print("[enemy] now in hit state")
    self.drink:patronHold()   -- Set drink's drinking state
    self.drinkOffset = self.drinkHoldOffset -- Set the drink position offset
end

function Enemy:startDrinking()
  self.hitDelay = 2     -- Reset hit timer
  self.state = "drink"  -- Set drinking state
  self.drinkOffset = self.drinkDrinkingOffset   -- Set drinking drink offset
  self.drink:startDrinking(self.rect.x + self.drinkDrinkingOffset.x, self.rect.y + self.drinkDrinkingOffset.y)    -- Apply drinking position to drink
end

function Enemy:stopDrinking()
  -- Add tip flyer
  self.overlay:addFlyer(self.reward, self.rect.x + self.rect.w / 2, self.rect.y + self.rect.h / 2)

  self.drinkDelay = .8    -- Reset drink timer
  self.state = "advance"  -- Set advance state
  self.drink:sendRight(self.rect.x + self.rect.w) -- Slide drink back from end of patron
  self.drink = nil        -- Customer no longer holding drink
end

---- BAR ACTIONS ----
function Enemy:matchDrink(drinkMix)
  if self.drinkMix['a'] == drinkMix['a']
  and self.drinkMix['b'] == drinkMix['b']
  and self.drinkMix['c'] == drinkMix['c'] then
    print("match")
    return true
  else
    print("no match")
    return false
  end
end

function Enemy:reachedEnd()
  self:deactivate()
end

function Enemy:exited()
  self.overlay:addFlyer(self.reward, self.rect.x + self.rect.w / 2, self.rect.y + self.rect.h / 2)

  self.drink:deactivate() -- Drink is no longer active
  self:deactivate()
end

function Enemy:deactivate()
  self.isActive = false
  self.bumpWorld:remove(self.rect)
end

---- UPDATE ----

function Enemy:update(dt)
  if self.isActive then
    -- Advance towards the player
    if self.state == "advance" then
      self.advanceStateTimer = self.advanceStateTimer - dt
      local actualX, actualY, cols, len = 0, 0, {}, 0
      if self.advanceState == "walk" then
        actualX, actualY, cols, len = self.bumpWorld:move(self.rect, self.rect.x + (self.speed * 50 * dt), self.rect.y, self:collisionFilter())
        self.rect.x = actualX -- Move forwards
        self.bumpWorld:update(self.rect, self.rect.x, self.rect.y)
        if self.advanceStateTimer <= 0 then
          self.advanceState = "stand"
          self.advanceStateTimer = 2.5
        end
      elseif self.advanceState == "stand" then
        actualX, actualY, cols, len = self.bumpWorld:check(self.rect, self.rect.x, self.rect.y, self:collisionFilter())
        if self.advanceStateTimer <= 0 then
          self.advanceState = "walk"
          self.advanceStateTimer = 2
        end
      end
      -- Check collisions
      if len > 0 then self:checkDrinkCollision(cols) end
      if len > 0 then self:checkEndCollision(cols) end
    -- Fly backwards when hit by drink
    elseif self.state == "hit" then
      if self.hitDelay > 0 then
        self.hitDelay = self.hitDelay - dt            -- Advance hold timer

        -- Move backwards
        local actualX, actualY, cols, len = self.bumpWorld:move(self.rect, self.rect.x - (125 * dt), self.rect.y, self:collisionFilter())
        self.rect.x = actualX
        self.bumpWorld:update(self.rect, self.rect.x, self.rect.y)

        -- Set held drink position
        self.drink.rect:setPos(self.rect.x + self.drinkHoldOffset.x, self.rect.y + self.drinkHoldOffset.y) -- Set drink position

        -- Check collisions
        if len > 0 then self:checkStartCollision(cols) end
      else
        self:startDrinking()  -- Start drinking state when hold timer ends
      end

    -- Pause and drink after being hit
    elseif self.state == "drink" then
      if self.drinkDelay > 0 then
        self.drinkDelay = self.drinkDelay - dt  -- Advance drink timer
      else
        self:stopDrinking()   -- Start advancing state when done drinking
      end
    end

  end
  for n, anim in pairs(self.animations) do
    anim:update(dt)
  end
end

---- DRAW ----

function Enemy:draw()
  if self.isActive then
    if self.animations[self.state] then
      love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
      local image = self.images[self.state]
      self.animations[self.state]:draw(image, self.rect.x - 100, self.rect.y - 173)
    else
      Entity.draw(self)
    end
    if self.state == "advance" then
      local speechOffset = { x = self.rect.x + 100, y = self.rect.y - 114 }
      local drinkOffset = { x = speechOffset.x + 20, y = speechOffset.y + 18 }

      love.graphics.draw(gameWorld.assets.sprites.game.speechbubble, speechOffset.x, speechOffset.y)

      if self.drinkMix['a'] then
        love.graphics.draw(gameWorld.assets.sprites.game.gem_PURPLE, drinkOffset.x, drinkOffset.y)
      end
      if self.drinkMix['b'] then
        love.graphics.draw(gameWorld.assets.sprites.game.gem_GREEN, drinkOffset.x, drinkOffset.y + 32)
      end
      if self.drinkMix['c'] then
        love.graphics.draw(gameWorld.assets.sprites.game.gem_CYAN, drinkOffset.x, drinkOffset.y + 64)
      end
    end
  end
end

---- COLLISION ----

function Enemy:collisionFilter()
  local filter = function(item, other)
    -- Detected matching drink going out
    if other.props.isDrink and self.state == "advance" then
      if other.props.state == "toCustomer" and self:matchDrink(other.props.drinkMix) then
        return 'touch'
      end

    -- Reached end of bar
    elseif other.props.isEnd and self.state == "advance" then
      return 'touch'

    -- Reached beginning of bar in hit state
    elseif other.props.isStart and self.state == "hit" then
      return 'touch'
    end

    -- Ignore all other collisions
    return nil
  end

  return filter
end

-- Collision with drink
function Enemy:checkDrinkCollision(cols)
  for i,col in ipairs(cols) do
    local other = col.other
    if other.props.isDrink then
      -- If drink is heading out and matches patron's mix, register collision
      self:drinkHit(other.props.ref)
      do return end
    end
  end
end

-- Collision with end of bar
function Enemy:checkEndCollision(cols)
  for i,col in ipairs(cols) do
    local other = col.other
    if other.props.isEnd and self.state == "advance" then
      --endZone:patronReachedEnd()
      self:reachedEnd()
      do return end
    end
  end
end

-- Collision with start of bar
function Enemy:checkStartCollision(cols)
  for i,col in ipairs(cols) do
    local other = col.other
    if other.props.isStart and self.state == "hit" then
      --startZone:patronReachedEnd()
      self:exited()
      do return end
    end
  end
end

---- NEW OBJECT ----

return Enemy
