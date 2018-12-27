local class = require 'lib.middleclass'

local Credits = class('Credits', Gamestate)

function Credits:initialize()
  self.super.initialize(self)

  self.text =
[[Game Name

Dec 25 - Jan 31
2018

Person 1

Person 2

Person 3

Person 4
]]
  print("Inside credits init")
end


function Credits:enter()
end

function Credits:exit()
end

function Credits:update(dt)
end

function Credits:draw()
  -- Todo: draw text on the screen, scroll?
end

return Credits
