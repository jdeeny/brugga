local class = require 'lib.middleclass'
local anim8 = require 'lib.anim8'
local Entity = require 'entities.entity'
local rect = require 'physics.rect'

local Dude = class('Dude', Entity)

function Dude:initialize()
  Entity.initialize(self)
  self.archetype = require('entities.archetypes.brugga')
  self.animations = {}
  self.images = {}

  for name, anim in pairs(self.archetype.animations) do
    self.animations[name] = anim8.newAnimation(anim.grid, anim.rate)
    self.images[name] = anim.image
  end

  self.servetags = {{'brugga'}, {'serve'}}

  self.tempAnim = 'none'
  self.tempAnimTimer = 0
  self.scale = { x = 1, y = 1 }

  self.props.isPlayer = true
  self.row = 1
  self.moveDir = "none"
  self.moveDelay = 0

  -- Drinks
  self.drinkPool = nil
  self.drinkPour = nil
  self.drinkPourOffset = { x=112, y=-8}
  self.drinkSend = nil
  self.drinkSendOffset = { x=-48, y=-8}

  -- Create collision rectangle
  self.rect:set(0, 0, 256, 128)
end

---- SPAWN ----
function Dude:spawn(drinkPool)
  self.drinkPool = drinkPool
  self.isActive = true
  self.rect.x = 750 + (self.row * 40)
  self.rect.y = 15 + (self.row * 185)
end

---- DRINK ACTIONS ----

function Dude:getEmptyDrink()
  self.drinkPour = self.drinkPool:getNewDrink()
  if self.drinkPour ~= nil then
    self:updateHeldDrinks()
  end
end

function Dude:updateHeldDrinks()
  if self.drinkPour ~= nil then
    self.drinkPour.rect:setPos(self.rect.x + self.drinkPourOffset.x + (self.row * 20), self.rect.y + self.drinkPourOffset.y - (self.row * 5))
    self.drinkPour.row = self.row
  end
  if self.drinkSend ~= nil then
    self.drinkSend.rect:setPos(self.rect.x + self.drinkSendOffset.x + (self.row * 20), self.rect.y + self.drinkSendOffset.y - (self.row * 5))
    self.drinkSend.row = self.row
  end
end

function Dude:swapDrinks()
  if self.drinkSend or self.drinkPour then
    local prevSend, prevPour = self.drinkSend, self.drinkPour
    gameWorld.sound:playSfx('drinkSwap')
    self.drinkSend = prevPour
    self.drinkPour = prevSend
    self:updateHeldDrinks()
    self:haltTempAnim()
  end
end

function Dude:pour()
  if self.drinkPour == nil then
      self:getEmptyDrink()
  end

  if self.drinkPour ~= nil then
    if self.row == 1 and self.drinkPour.props.drinkMix['a'] == nil then
      self.drinkPour.props.drinkMix['a'] = true
    elseif self.row == 2 and self.drinkPour.props.drinkMix['b'] == nil then
      self.drinkPour.props.drinkMix['b'] = true
    elseif self.row == 3 and self.drinkPour.props.drinkMix['c'] == nil then
      self.drinkPour.props.drinkMix['c'] = true
    end
    gameWorld.sound:playSfx('drinkPour')
  end

  self.tempAnim = 'pour'
  self.tempAnimTimer = 1
end

function Dude:send()
  if self.drinkSend ~= nil then     -- Send drink in sending hand
    self.drinkSend:sendLeft()
    self.drinkSend = nil
    self.tempAnim = 'throw'
    self.tempAnimTimer = .5
  elseif self.drinkPour ~= nil then -- Send drink in pouring hand
    self.drinkPour:sendLeft()
    self.drinkPour = nil
    self.tempAnim = 'throw'
    self.tempAnimTimer = .5
  end
  if gameWorld.random:random(1, 5) == 1 then gameWorld.sound:playVoice(self.servetags) end
end

---- UPDATE ----

function Dude:update(dt)
  if self.moveDelay > 0 then self.moveDelay = self.moveDelay - dt end
  if self.tempAnimTimer > 0 then self.tempAnimTimer = self.tempAnimTimer - dt end
  if self.tempAnimTimer <= 0 then self:haltTempAnim() end

  if (self.moveDir ~= "none") then
    self:changeRow(dt)
  end
end

---- DRAW ----
function Dude:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  local imageState = 'idle'
  if self.drinkPour or self.drinkSend then imageState = 'hold' end
  if self.tempAnim ~= 'none' then
    imageState = self.tempAnim
  end

  local image = self.images[imageState]
  self.animations[imageState]:draw(image, self.rect.x - 60 + (self.row * 20), self.rect.y - 195 - (self.row * 5), 0, self.scale.x, self.scale.y)
end

function Dude:haltTempAnim()
  self.tempAnim = 'none'
  self.tempAnimTimer = 0
end
---- MOVEMENT --

function Dude:changeRow(dt)
  if (self.moveDelay > 0) then
    do return end
  end

  if (self.moveDir == "up") then
    flux.to(self.scale, .05, {y = .98}):after(self.scale, .1, {y = 1})
    self.row = self.row - 1
  elseif (self.moveDir == "down") then
    flux.to(self.scale, .05, {y = 1.02}):after(self.scale, .1, {y = 1})
    self.row = self.row + 1
  end

  if (self.row <= 1) then
    self.row = 1
  elseif (self.row >= 3) then
    self.row = 3
  end

  self.moveDelay = 1/6
  self.rect.x = 750 + (self.row * 40)
  self.rect.y = 15 + (self.row * 185)

  self.bumpWorld:move(self.rect, self.rect.x, self.rect.y, function() return 'cross' end)

  self:updateHeldDrinks()
  self:haltTempAnim()
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

---- COLLISION ----

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
