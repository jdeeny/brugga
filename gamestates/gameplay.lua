local class = require 'lib.middleclass'
local bump = require 'lib.bump'
local Dude = require 'entities.dude'
local Enemy = require 'entities.enemy'
local Drink = require 'entities.drink'
local Generator = require 'entities.generator'
local Zone = require 'entities.zone'
local Gamestate = require 'gamestates.gamestate'

local Gameplay = class('Gameplay', Gamestate)

function Gameplay:initialize(name)
  Gamestate.initialize(self, name)

  self.rewardTime = 0.5
  self.nextReward = self.rewardTime
end

function Gameplay:enter()
  -- reset score
  gameWorld.playerData:reset()

  -- Collision world
  self.bumpWorld = bump.newWorld(50)
  ---- Entity Creation
  -- Patrons
  self.generator = Generator:new()
  self.patrons = {}
  -- Brugga
  self.brugga = Dude:new()
  self.brugga:addToWorld(self.bumpWorld)
  self.brugga:spawn()
  -- Static drink
  self.drink = Drink:new()
  self.drink:addToWorld(self.bumpWorld)
  self.drink.row = 1
  -- Zones
  self.startZones = {}
  self.endZones = {}
  for i=1,4 do
    table.insert(self.startZones, Zone:new(i, "start", self.bumpWorld))
    table.insert(self.endZones, Zone:new(i, "end", self.bumpWorld))
  end
end

function  Gameplay:update(dt)
  -- Generate new patrons
  self.generator:update(dt)
  local gen = self.generator:generate()
  if gen then
    pretty.dump(gen)
    local newPatron = Enemy:new(gen)      -- Create new patron
    newPatron:addToWorld(self.bumpWorld)       -- Add to bump world
    table.insert(self.patrons, newPatron) -- Put in master patron table
  end

  if gameWorld.playerInput:pressed('pause') then
    gameWorld.gameState:pushState('pause')
  elseif gameWorld.playerInput:pressed 'ok' then
    print("exit gameplay")
    gameWorld.gameState:setState('ending')
  end

  if gameWorld.playerInput:released('up') or gameWorld.playerInput:released('down') then
    self.brugga:moveNone()
  elseif gameWorld.playerInput:pressed('up') then
    self.brugga:moveUp()
  elseif gameWorld.playerInput:pressed('down') then
    self.brugga:moveDown()
  end

  -- Spawn drink if player presses throw
  if gameWorld.playerInput:pressed('throw') then
    if self.bumpWorld:hasItem(self.drink.rect) == false then
      self.drink:addToWorld(self.bumpWorld)
    end
    self.drink.isActive = true
    self.drink.row = self.brugga.row
    self.drink:sendLeft()
  end

  -- Update entities
  if self.brugga.isActive then self.brugga:update(dt) end
  if self.drink.isActive then self.drink:update(dt) end

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
    gameWorld.playerData:scoreIncrease(1)
  end
end

function Gameplay:draw()
  -- Zones
  for i=1,4 do
    self.startZones[i]:draw()
    self.endZones[i]:draw()
  end

  -- Debug bar boxes
  love.graphics.setColor(.6, .2, .1, 100)
  love.graphics.rectangle('fill', 300, 220, 680, 40)
  love.graphics.rectangle('fill', 280, 320, 720, 40)
  love.graphics.rectangle('fill', 260, 420, 760, 40)
  love.graphics.rectangle('fill', 240, 520, 800, 40)

  self.brugga:draw() -- Draw brugga

  -- Draw patrons
  local patronSize = table.getn(self.patrons)
  if patronSize > 0 then
    for i=1,patronSize do
      self.patrons[i]:draw()
    end
  end

  self.drink:draw()  -- Draw drink
end

return Gameplay
