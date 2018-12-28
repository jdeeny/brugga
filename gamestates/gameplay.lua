local class = require 'lib.middleclass'
local bump = require 'lib.bump'
local Dude = require 'entities.dude'
local Enemy = require 'entities.enemy'
local Drink = require 'entities.drink'
local Gamestate = require 'gamestates.gamestate'

local Gameplay = class('Gameplay', Gamestate)

-- Collision world
local bumpWorld = bump.newWorld(50)
-- Entities
local patronA = Enemy:new()
local patronB = Enemy:new()
local drink = Drink:new()
local brugga = Dude:new()

function Gameplay:initialize(name)
  Gamestate.initialize(self, name)

  print("Adding patron")
  brugga:addToWorld(bumpWorld)
  brugga:spawn()
  patronA:addToWorld(bumpWorld)
  patronA:spawnEnemy("OnlyA", 1)
  patronB:addToWorld(bumpWorld)
  patronB:spawnEnemy("OnlyB", 3)
  drink:addToWorld(bumpWorld)
  drink.row = 1

  self.rewardTime = 0.5
  self.nextReward = self.rewardTime
end

function  Gameplay:update(dt)
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
    drink.isActive = true
    drink.row = brugga.row
    drink:sendLeft()
  end

  -- Update entities
  if brugga.isActive then brugga:update(dt) end
  if drink.isActive then drink:update(dt) end
  if patronA.isActive then patronA:update(dt) end
  if patronB.isActive then patronB:update(dt) end

  self.nextReward = self.nextReward - dt
  if self.nextReward <= 0.0 then
    self.nextReward = self.rewardTime
    gameWorld.playerScore = gameWorld.playerScore + 1
  end
end

function Gameplay:draw()
  -- Debug bar boxes
  love.graphics.setColor(.6, .2, .1, 100)
  love.graphics.rectangle('fill', 300, 220, 680, 40)
  love.graphics.rectangle('fill', 280, 320, 720, 40)
  love.graphics.rectangle('fill', 260, 420, 760, 40)
  love.graphics.rectangle('fill', 240, 520, 800, 40)

  brugga:draw()
  patronA:draw()
  patronB:draw()
  drink:draw()
end

return Gameplay
