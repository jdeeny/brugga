local class = require 'lib.middleclass'
local entity = require 'entities.entity'
local rect = require 'physics.rect'

local Enemy = class('Enemy', entityClass())

function Enemy:initialize()
  entityClass().initialize(self)

  self.drinkA, self.drinkB, self.drinkC, self.drinkD = false, false, false, false
  self.state = "advance"
  self.hitDelay = 2
  self.drinkDelay = .5
  -- Set properties
  self.props.isEnemy = true;          -- Is an enemy

  -- Create collision rectangle
  self.rect:set(300, 156, 64, 64)        -- Set position/size
end

function Enemy:spawnEnemy(enemyType, row)
  self.isActive = true
  if (enemyType == "OnlyA") then drinkA = true end
  if (enemyType == "OnlyB") then drinkB = true end
  self.rect:setPos(320 - (20 * row), 120 + (100 * row) - self.rect.h) -- set at start of specific row
end

function Enemy:update(dt)
  if (self.isActive) then
    -- Advance towards the player
    if (self.state == "advance") then
      self.rect.x = self.rect.x + (20 * dt)
    -- Fly backwards when hit by drink
    elseif (self.state == "hit") then
      if (self.hitDelay > 0) then
        self.rect.x = self.rect.x - (100 * dt)
        self.hitDelay = self.hitDelay - dt
      else
        self.state = "drink"
        self.hitDelay = 2
      end
    -- Pause and drink after being hit
    elseif (self.state == "drink") then
      if (self.drinkDelay > 0) then
        self.drinkDelay = self.drinkDelay - dt
      else
        self.state = "advance"
        self.drinkDelay = .5
      end
    end
  end
end

function newEnemy()
  return Enemy:new()
end
