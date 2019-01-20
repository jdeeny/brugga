local class = require 'lib.middleclass'

local Overlay = class('MidiOverlay')

function Overlay:initialize()
end

function Overlay:draw()
  love.graphics.setColor(0.01, 0.01, 0.01, 0.85)
  love.graphics.rectangle('fill', 800, 500, 300, 200, 16, 16)
  love.graphics.setColor(0.9, 0.9, 0.9, 1.0)
  love.graphics.printf("Text", 800, 540, 300, 'center')

end

return Overlay
