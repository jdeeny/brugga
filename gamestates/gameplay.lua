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
local patron = Enemy:new()
local drink = Drink:new()

function Gameplay:initialize(name)
  Gamestate.initialize(self, name)

  print("Adding patron")
  patron:addToWorld(bumpWorld)
  patron:spawnEnemy("OnlyA", 1)
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

  -- Update entities
  if patron.isActive then patron:update(dt) end
  if drink.isActive then drink:update(dt) end

  -- Spawn drink if player presses throw
  if gameWorld.playerInput:pressed('throw') then
    drink.isActive = true
    drink:sendLeft()
  end

  self.nextReward = self.nextReward - dt
  if self.nextReward <= 0.0 then
    self.nextReward = self.rewardTime
    gameWorld.playerScore = gameWorld.playerScore + 1
  end
end

function Gameplay:draw()
  --love.graphics.setColor(1.0,0.0,0.0,1.0)
  --love.graphics.rectangle('fill', 80,80,700,500)
  patron:draw()
  drink:draw()
end

return Gameplay
