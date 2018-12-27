local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Credits = class('Credits', Gamestate)

function Credits:initialize(name)
  Gamestate.initialize(self, name)

  self.text = love.graphics.newText(gameWorld.assets.fonts.credits(16),
[[Game Name

Dec 25 - Jan 31
2018

Person 1

Person 2

Person 3

Person 4
]]
)

  print("Inside credits init")
end


function Credits:enter()
end

function Credits:exit()
end

function Credits:update(dt)
end

function Credits:draw()
  love.graphics.draw(self.text) -- Todo: draw text on the screen, scroll?
end

return Credits
