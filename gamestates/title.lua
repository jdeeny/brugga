local class = require 'lib.middleclass'

local Title = class('Title', Gamestate)



function Title:initialize()
  self.super.initialize(self)

  print("Inside title init")
end

function Title:draw()
    love.graphics.rectangle('fill', 20, 10, 60, 20)
end

function Title:update()
  if gameWorld.playerInput:pressed 'ok' then
    print("exit title")
    gameWorld.gamestates:setState('title')
  end
end


return Title
