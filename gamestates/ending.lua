local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Ending = class('Ending', Gamestate)

function Ending:initialize(name)
  Gamestate.initialize(self, name)
end

function Ending:enter()
  gameWorld.sound:playUi('gameOver')
end

function Ending:update(dt)
  if gameWorld.playerInput:pressed 'ok' then
    print("exit ending")
    gameWorld.gameState:setState('credits')
  end
end

function Ending:draw()
    love.graphics.draw(love.graphics.newText(gameWorld.assets.fonts.generic(16), "Score: " .. gameWorld.playerData.score), 1280 / 2, 720/2)
end

return Ending
