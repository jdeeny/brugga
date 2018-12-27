local class = require 'lib.middleclass'

local Splash = class('Splash', Gamestate)

function Splash:initialize()
  self.super.initialize(self)

  print("Inside splash init")
end

function Splash:draw()
    love.graphics.rectangle('fill', 30, 20, 80, 40)
end

function Splash:update()
  if gameWorld.playerInput:pressed('ok') then
    print("exit splash")
    gameWorld.gamestates:setState('title')
  end
end

return Splash
