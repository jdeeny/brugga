local class = require 'lib.middleclass'
local Score = require 'ui.score'
local Flyer = require 'ui.flyer'

local Overlay = class('Overlay')

function Overlay:initialize()
  self.flying = {}

  self.score_width = 400
  self.score_x = 1280 - self.score_width - 50
  self.score_y = 720 - 100

  self.target_x = self.score_x
  self.target_y = self.score_y

  self.scale_x = 1.0
  self.scale_y = 1.0

  self.flight_time = 0.7
end


function Overlay:update(dt)
  --for i, f in ipairs(self.flying) do
--    f:update(dt)

--  if f.completion >= 1 then
--      f:destroy()
--      self.flying[i] = nil
--    end
--  end

end

function Overlay:draw()
  --love.graphics.setColor(gameWorld.colors.score)
  --love.graphics.setFont(self.flyer_font)
  for _, f in ipairs(self.flying) do
    f:draw()
  end
  local score = Score:new(gameWorld.playerData.score, 64, 0)
  local drawable = score:getDrawable()
  local w = drawable:getWidth()
  local h = drawable:getHeight()

  love.graphics.setColor(1.0,1.0,1.0,1.0)
  love.graphics.draw(score:getDrawable(), self.score_x, self.score_y, 0, self.scale_x, self.scale_y)
  end


  --love.graphics.setColor(gameWorld.colors.score)
  --love.graphics.setFont(self.score_font)

  --local score_str = comma_value(gameWorld.playerData.score) .. ".00"
  --love.graphics.printf("$", self.score_x, self.score_y, self.score_width, 'left', 0, self.scale_x, self.scale_y)
  --love.graphics.printf(score_str, self.score_x, self.score_y, self.score_width, 'right', 0, self.scale_x, self.scale_y, self.score_width * self.scale_x - self.score_width)
--end

function Overlay:addTipFlyer(amount, x, y)
  print("Tip: " .. amount)
  local score = Score:new(amount, 64, 0)
  local new_flyer = Flyer:new(score:getDrawable(), x, y, self.target_x, self.target_y)
  local flight_time = 0.5 + gameWorld.random:random(0.2)
  local tween = flux.to(new_flyer, flight_time, { completion = 1.0 }):oncomplete(function() gameWorld.playerData:scoreIncrease(amount) self:pulseScore() new_flyer:destroy() end)
  table.insert(self.flying, new_flyer )
end

function Overlay:pulseScore()
  flux.to(self, 0.3, { scale_x = 1.2, scale_y = 1.4 }):ease('cubicout'):after(self, 0.7, { scale_x = 1.0, scale_y = 1.0 } ):ease('elasticout')
end

return Overlay
