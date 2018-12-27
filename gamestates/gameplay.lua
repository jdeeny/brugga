local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Gameplay = class('Gameplay', Gamestate)

function Gameplay:initialize(name)
  Gamestate.initialize(self, name)

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

  self.nextReward = self.nextReward - dt
  if self.nextReward <= 0.0 then
    self.nextReward = self.rewardTime
    gameWorld.playerScore = gameWorld.playerScore + 1
  end
end

function Gameplay:draw()
  love.graphics.setColor(1.0,0.0,0.0,1.0)
  love.graphics.rectangle('fill', 80,80,700,500)
end

return Gameplay
