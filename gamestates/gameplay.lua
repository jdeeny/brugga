local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Gameplay = class('Gameplay', Gamestate)

function  Gameplay:update(dt)
  if gameWorld.playerInput:pressed('pause') then
    gameWorld.gamestate:pushState('pause')
  elseif gameWorld.playerInput:pressed 'ok' then
    print("exit gameplay")
    gameWorld.gamestate:setState('ending')
  end
end

function Gameplay:draw()
  love.graphics.setColor(1.0,0.0,0.0,1.0)
  love.graphics.rectangle('fill', 80,80,700,500)
end
return Gameplay
