local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Splash = class('Splash', Gamestate)

function Splash:initialize(name)
  Gamestate.initialize(self, name)

  print("Inside splash init")
end

function Splash:draw()
  love.graphics.setColor(gameWorld.colors.white)
  love.graphics.draw(gameWorld.assets.splash.splash)
end

function Splash:update()
  if gameWorld.playerInput:pressed('ok') then
    print("exit splash")
    gameWorld.gamestate:setState('title')
  end
  if gameWorld.playerInput:pressed('left') then
    gameWorld.sound:playMusic()
  end
  if gameWorld.playerInput:pressed('right') then
    gameWorld.sound:stopMusic()
  end

end

return Splash
