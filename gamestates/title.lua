local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Title = class('Title', Gamestate)

function Title:initialize(name)
  Gamestate.initialize(self, name)

  print("Inside title init")
end

function Title:draw()
  love.graphics.setColor(1.0,1.0,1.0,1.0)
  love.graphics.rectangle('fill', 20, 10, 60, 20)
end

function Title:update()
  if gameWorld.playerInput:pressed 'ok' then
    print("exit title")
    gameWorld.gamestate:setState('gameplay')
  end
end


return Title
