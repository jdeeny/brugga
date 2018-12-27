local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Pause = class('Pause', Gamestate)

function Pause:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 0.5)
  love.graphics.rectangle('fill', 350, 100, 1280-700, 720 - 200, 16, 16, 16)
end

function Pause:update(dt)
  if gameWorld.playerInput:pressed('pause') then
    print("exit pause")
    gameWorld.gameState:exitState()
  end
end

return Pause
