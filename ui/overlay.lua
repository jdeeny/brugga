local class = require 'lib.middleclass'
local Score = require 'ui.score'


local Overlay = class('Overlay')

function Overlay:initialize()
  self.flying = {}

  self.score_width = 400
  self.score_x = 1280 - self.score_width - 50
  self.score_y = 720 - 100

  self.scale_x = 1.0
  self.scale_y = 1.0

  self.flight_time = 0.7
end


function Overlay:update(dt)
  --[[for i, f in ipairs(self.flying) do
    if f.done >= 0.999 then
      gameWorld.sound:playSfx('coin')
      self:pulseScore()
      self.flying[i] = nil
    end
  end]]
end

function Overlay:draw()
  --love.graphics.setColor(gameWorld.colors.score)
  --love.graphics.setFont(self.flyer_font)
  --[[for _, f in ipairs(self.flying) do
    local x = f.x * (1 - f.done) + self.score_x * f.done
    local y = f.y * (1 - f.done) + self.score_y * f.done

    love.graphics.draw(f.text, x, y)
]]
  local score = Score:new(0.0)
  love.graphics.draw(score:getDrawable(), self.score_x, self.score_y)
  end


  --love.graphics.setColor(gameWorld.colors.score)
  --love.graphics.setFont(self.score_font)

  --local score_str = comma_value(gameWorld.playerData.score) .. ".00"
  --love.graphics.printf("$", self.score_x, self.score_y, self.score_width, 'left', 0, self.scale_x, self.scale_y)
  --love.graphics.printf(score_str, self.score_x, self.score_y, self.score_width, 'right', 0, self.scale_x, self.scale_y, self.score_width * self.scale_x - self.score_width)
--end

function Overlay:addFlyer(amount, x, y)
--[[  print("Add flyer: " .. amount .." "..x.." "..y)
  local score_str = '$ ' .. comma_value(gameWorld.playerData.score) .. ".00"
  local text = love.graphics.newText(self.flyer_font, score_str)
  local new_flyer = Flyer:new(text, x, y,  { done = 0.0, amount = amount, text = text, x = x, y = y }
  table.insert(self.flying, new_flyer)
  local t = self.flight_time + (love.math.random(self.flight_time / 10) - (self.flight_time / 20))
  print("score ".. self.score_x.." "..self.score_y)
  flux.to(new_flyer, t, { done = 1.0 })
  ]]
end

function Overlay:pulseScore()
  --flux.to(self, 0.3, { scale_x = 1.2, scale_y = 1.4 }):ease('cubicout'):after(self, 0.7, { scale_x = 1.0, scale_y = 1.0 } ):ease('elasticout')
end

return Overlay
