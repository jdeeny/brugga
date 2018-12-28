local class = require 'lib.middleclass'
local bump = require 'lib.bump'
local Dude = require 'entities.dude'
local Enemy = require 'entities.enemy'
local Drink = require 'entities.drink'
local Generator = require 'entities.generator'
local Zone = require 'entities.zone'
local Gamestate = require 'gamestates.gamestate'

local Gameplay = class('Gameplay', Gamestate)

-- Collision world
local bumpWorld = bump.newWorld(50)
-- Entities
local drink = Drink:new()
local brugga = Dude:new()
local startZones = {}
local endZones = {}

function Gameplay:initialize(name)
  Gamestate.initialize(self, name)

  self.rewardTime = 0.5
  self.nextReward = self.rewardTime
end

function Gameplay:enter()
  self.generator = Generator:new()
  self.patrons = {}

  brugga:addToWorld(bumpWorld)
  brugga:spawn()

  drink:addToWorld(bumpWorld)
  drink.row = 1

  for i=1,4 do
    table.insert(startZones, Zone:new(i, "start", bumpWorld))
    table.insert(endZones, Zone:new(i, "end", bumpWorld))
  end
end

function  Gameplay:update(dt)
  -- Generate new patrons
  self.generator:update(dt)
  local gen = self.generator:generate()
  if gen then
    pretty.dump(gen)
    local newPatron = Enemy:new(gen)      -- Create new patron
    newPatron:addToWorld(bumpWorld)       -- Add to bump world
    table.insert(self.patrons, newPatron) -- Put in master patron table
  end

  if gameWorld.playerInput:pressed('pause') then
    gameWorld.gameState:pushState('pause')
  elseif gameWorld.playerInput:pressed 'ok' then
    print("exit gameplay")
    gameWorld.gameState:setState('ending')
  end

  if gameWorld.playerInput:released('up') or gameWorld.playerInput:released('down') then
    brugga:moveNone()
  elseif gameWorld.playerInput:pressed('up') then
    brugga:moveUp()
  elseif gameWorld.playerInput:pressed('down') then
    brugga:moveDown()
  end

  -- Spawn drink if player presses throw
  if gameWorld.playerInput:pressed('throw') then
    if bumpWorld:hasItem(drink.rect) == false then
      drink:addToWorld(bumpWorld)
    end
    drink.isActive = true
    drink.row = brugga.row
    drink:sendLeft()
  end

  -- Update entities
  if brugga.isActive then brugga:update(dt) end
  if drink.isActive then drink:update(dt) end

  -- Update patrons
  local patronSize = table.getn(self.patrons)
  if patronSize > 0 then
    for i=1,patronSize do
      self.patrons[i]:update(dt)
    end
  end

  self.nextReward = self.nextReward - dt
  if self.nextReward <= 0.0 then
    self.nextReward = self.rewardTime
    gameWorld.playerScore = gameWorld.playerScore + 1
  end
end

function Gameplay:draw()
  -- Zones
  for i=1,4 do
    startZones[i]:draw()
    endZones[i]:draw()
  end

  -- Debug bar boxes
  love.graphics.setColor(.6, .2, .1, 100)
  love.graphics.rectangle('fill', 300, 220, 680, 40)
  love.graphics.rectangle('fill', 280, 320, 720, 40)
  love.graphics.rectangle('fill', 260, 420, 760, 40)
  love.graphics.rectangle('fill', 240, 520, 800, 40)

  brugga:draw() -- Draw brugga

  -- Draw patrons
  local patronSize = table.getn(self.patrons)
  if patronSize > 0 then
    for i=1,patronSize do
      self.patrons[i]:draw()
    end
  end

  drink:draw()  -- Draw drink
end

return Gameplay
