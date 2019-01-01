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

  self.speech_offset = data.speech_offset

  self.animations = data.animations
  self.images = data.images

  self.tagsets = data.tagsets or {}
  self.drinktags = tablex.copy(self.tagsets)
  table.insert(self.drinktags, { 'drink' })

  self.ordertags = tablex.copy(self.tagsets)
  table.insert(self.ordertags, { 'order' })

  self.entertags = tablex.copy(self.tagsets)
  table.insert(self.entertags, { 'enter' })

  self.yucktags = tablex.copy(self.tagsets)
  table.insert(self.yucktags, { 'yuck' })

  self.thankstags = tablex.copy(self.tagsets)
  table.insert(self.thankstags, { 'thanks' })



  self.swaps_in  = data.swaps_in or {} -- { 0, 0, 0, 1}, {1,0,0,1} }
  --pretty.dump(self.swaps_in)

  self.swaps_out = { { gameWorld.random:randomNormal(0.08, 0) + self.swaps_in[1][1], gameWorld.random:randomNormal(0.08, 0) + self.swaps_in[1][2], gameWorld.random:randomNormal(0.08, 0) + self.swaps_in[1][3], 1 }}
  --pretty.dump(self.swaps_out)

  -- Set properties
  self.isActive = true
  self.state = "advance"  -- Current operational state
  self.advanceState = "walk"
  self.advanceStateTimer = 2
  self.hitDelayMax = 1
  self.hitDelay = self.hitDelayMax       -- Hit state duration
  self.drinkDelayMax = .75
  self.drinkDelay = self.drinkDelayMax    -- Drinking state duration
  self.props.isEnemy = true          -- Is an enemy
  self.props.inLine = true  -- Patron is waiting in line (not drinking)

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

  self.drinkfoam = require('ui.drinkfoam'):new()

  self.rect:setPos(220 - (75 * self.row), 17 + (183 * self.row) - self.rect.h) -- set at start of specific row

  if gameWorld.random:random(1,2) == 1 then
    gameWorld.sound:playVoice(self.entertags)
  else
    gameWorld.sound:playVoice(self.ordertags)
  end

  self.starttime = love.timer.getTime()
  self.last_yuck = self.starttime

  self.speechscale_x = 1.0
  self.speechscale_y = 1.0

end

---- DRINK ACTIONS ----

function Enemy:drinkHit(drink)
    self.drink = drink        -- Store drink that collided
    self.state = "hit"        -- Set hit state
    self.props.inLine = false -- Patron no longer considered waiting in line
    self.drink:patronHold()   -- Set drink's drinking state
    self.drinkOffset = self.drinkHoldOffset -- Set the drink position offset
end

function Enemy:startDrinking()
  self.hitDelay = self.hitDelayMax         -- Reset hit timer
  self.state = "drink"      -- Set drinking state
  self.props.inLine = false -- Patron no longer considered waiting in line
  self.drinkOffset = self.drinkDrinkingOffset   -- Set drinking drink offset
  self.drink:startDrinking(self.rect.x + self.drinkDrinkingOffset.x, self.rect.y + self.drinkDrinkingOffset.y)    -- Apply drinking position to drink
  self.drinkfoam:createFoam(self.rect.x + self.drinkOffset.x, self.rect.y + self.drinkOffset.y, self.drinkMix)
  gameWorld.sound:playVoice(self.drinktags)
end

function Enemy:stopDrinking()
  self.drinkDelay = self.drinkDelayMax      -- Reset drink timer
  self.state = "advance"    -- Set advance state
  self.props.inLine = true  -- Patron now considered waiting in line
  self.drink:sendRight(self.rect.x + self.rect.w) -- Slide drink back from end of patron
  self.drink = nil        -- Customer no longer holding drink


end

---- BAR ACTIONS ----
function Enemy:matchDrink(drinkMix)
  if self.drinkMix['a'] == drinkMix['a']
  and self.drinkMix['b'] == drinkMix['b']
  and self.drinkMix['c'] == drinkMix['c'] then
    return true
  else
    return false
  end
end

function Enemy:reachedEnd()
  self:deactivate()
  if gameWorld.playerData:livesDecrease(1) then gameWorld.gameState:setState('ending') end
end

function Enemy:exited()
  gameWorld.sound:playVoice(self.thankstags)
  self.drink:deactivate() -- Drink is no longer active
  self:deactivate()
  -- Add tip flyer
  --local endtime = love.timer.getTime()
  --local delta = endtime - self.starttime
  local reward = self.reward * (1 + math.floor(gameWorld.playerData.wave / 3))
  --reward = reward / (delta * .5)
  --if delta <= 1 then delta = 1 end
  --if delta >= 2 then delta = 2 end
  --reward = math.floor(reward * 100 * delta) / 100
  self.overlay:addTipFlyer(reward, self.rect.x + self.rect.w / 2, self.rect.y + self.rect.h / 2)

end

function Enemy:deactivate()
  self.isActive = false
  self.bumpWorld:remove(self.rect)
end

---- UPDATE ----

function Enemy:update(dt)
  self.drinkfoam:update(dt)
  if self.isActive then
    -- Advance towards the player
    if self.state == "advance" then
      self.advanceStateTimer = self.advanceStateTimer - dt
      local actualX, actualY, cols, len = 0, 0, {}, 0
      if self.advanceState == "walk" then
        actualX, actualY, cols, len = self.bumpWorld:move(self.rect, self.rect.x + (self.speed * 50 * dt), self.rect.y, self:collisionFilter())
        local eCols, eLen = self.bumpWorld:queryRect(self.rect.x + self.rect.w * 1.1, self.rect.y, self.rect.w, self.rect.h, self:enemyFilter())

        self.rect.x = actualX -- Move forwards
        self.bumpWorld:update(self.rect, self.rect.x, self.rect.y)

        -- Check if other patrons are in the way
        local patronsAhead = false
        for i,col in ipairs(eCols) do
          if col.props.inLine then patronsAhead = true end
        end

        -- Change state if timer up or patron detected
        if self.advanceStateTimer <= 0 or patronsAhead then
          self.advanceState = "stand"

          local r = gameWorld.random:random(1, 400)
          local d = (love.timer.getTime() - self.last_yuck)
          if r < d then
            if gameWorld.random:random(1,5) < 3 then
              gameWorld.sound:playVoice(self.yucktags)
            else
              gameWorld.sound:playVoice(self.ordertags)
            end
            self.last_yuck = love.timer.getTime()
          end
          if patronsAhead then
            self.advanceStateTimer = .1
          else
            self.advanceStateTimer = 2
          end
        end

      elseif self.advanceState == "stand" then
        actualX, actualY, cols, len = self.bumpWorld:check(self.rect, self.rect.x, self.rect.y, self:collisionFilter())
        local eCols, eLen = self.bumpWorld:queryRect(self.rect.x + self.rect.w * 1.1, self.rect.y, self.rect.w, self.rect.h, self:enemyFilter())

        -- Check if other patrons are in the way
        local patronsAhead = false
        for i,col in ipairs(eCols) do
          if col.props.inLine then patronsAhead = true end
        end

        -- Change state if timer up
        if self.advanceStateTimer <= 0 then
          if patronsAhead then  -- Stay in stand state if patron detected
            self.advanceStateTimer = .5
          else
            self.advanceState = "walk"
            self.advanceStateTimer = 2.5
         end
        end
      end
      -- Check collisions
      if len > 0 then self:checkDrinkCollision(cols) end
      if len > 0 then self:checkEndCollision(cols) end
    -- Fly backwards when hit by drink
    elseif self.state == "hit" then
      if self.hitDelay >= 0 then
        self.hitDelay = self.hitDelay - dt            -- Advance hold timer

        -- Move backwards
        local actualX, actualY, cols, len = self.bumpWorld:move(self.rect, self.rect.x - (250 * dt), self.rect.y, self:collisionFilter())
        self.rect.x = actualX

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
      gameWorld.paletteswap:setSwap(self.swaps_in, self.swaps_out)
        self.animations[self.state]:draw(image, math.floor(self.rect.x + 0.5) - 100, math.floor(self.rect.y + 0.5) - 173)
      gameWorld.paletteswap:clearSwap()

    else
      Entity.draw(self)
    end
    if self.state == "advance" then
      local speechOffset = { x = self.speech_offset.x + self.rect.x, y = self.speech_offset.y + self.rect.y }
      local drinkOffset = { x = speechOffset.x + 20, y = speechOffset.y + 18 }

      local w = gameWorld.assets.sprites.game.speechbubble:getWidth()
      local h = gameWorld.assets.sprites.game.speechbubble:getHeight()

      love.graphics.draw(gameWorld.assets.sprites.game.speechbubble, speechOffset.x + w/2, speechOffset.y + h/2, 0, self.speechscale_x, self.speechscale_y, w/2, h/2)

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
    self.drinkfoam:draw()
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

-- Check for patrons in front of current patron
function Enemy:enemyFilter()
  local filter = function(item)
    if item.props.isEnemy and self.rect ~= item then
      return 'cross'
    end

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
