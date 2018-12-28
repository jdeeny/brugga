local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Splash = class('Splash', Gamestate)

function Splash:initialize(name)
  Gamestate.initialize(self, name)
end

function Splash:draw()
  love.graphics.setColor(gameWorld.colors.white)
  love.graphics.draw(gameWorld.assets.splash.splash)
end

function Splash:update()
  if gameWorld.playerInput:pressed('action') or gameWorld.playerInput:pressed('pour') then
    gameWorld.gameState:setState('title')
  end
end

return Splash
