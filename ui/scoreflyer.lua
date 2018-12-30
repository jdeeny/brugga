local class = require 'lib.middleclass'
local Flyer = require 'ui.flyer'

local ScoreFlyer = class('ScoreFlyer', Flyer)

function ScoreFlyer:initialize(amount, start_x, start_y, dest_x, dest_y)
  local font = gameWorld.assets.fonts.score_font(32)
  local drawable = love.graphics.newText(font, "ABC")

  Flyer.initialize(self, drawable, start_x, start_y, dest_x, dest_y, 0.0)

  local std_time = 0.7
  local flight_time =   std_time + (gameWorld.random:random(std_time / 10) - (std_time / 20))
  flux.to(self, flight_time, { completion = 1.0 } )
end

return ScoreFlyer
