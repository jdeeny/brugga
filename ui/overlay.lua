local class = require 'lib.middleclass'
local Score = require 'ui.score'
local Flyer = require 'ui.flyer'

local Overlay = class('Overlay')

function Overlay:initialize()
  self.flying = {}

  self.score_width = 300
  self.score_x = (1280 - 300) / 2
  self.score_y = 720 - 92

  self.target_x = self.score_x
  self.target_y = self.score_y

  self.scale_x = 1.0
  self.scale_y = 1.0

  self.lifey = 720 - 72
  self.lifex = 16
  self.lifexdelta = 54

  self.flight_time = 0.7
  self.smoke = require('ui.smokepuff'):new()
end


function Overlay:update(dt)
  self.smoke:update(dt)
end

function Overlay:draw()
  --love.graphics.setColor(gameWorld.colors.score)
  --love.graphics.setFont(self.flyer_font)
  for _, f in ipairs(self.flying) do
    f:draw()
  end

  love.graphics.setColor(1.0,1.0,1.0,1.0)
  self.smoke:draw()

  local score = Score:new(gameWorld.playerData.score, 64, 0)
  local drawable = score:getDrawable()
  local w = drawable:getWidth()
  local h = drawable:getHeight()

  love.graphics.setColor(1.0,1.0,1.0,1.0)

  love.graphics.draw(score:getDrawable(), self.score_x + w/2, self.score_y+h/2, 0, self.scale_x, self.scale_y, w/2, h/2)


  local lives = gameWorld.playerData.lives

  love.graphics.setColor(1.0,1.0,1.0,1.0)
  for i = 1, 5 do
    if lives >= i then
      love.graphics.draw(gameWorld.assets.sprites.ui.newLife, self.lifex + (i - 1) * self.lifexdelta, self.lifey)
    else
      love.graphics.setColor(0.7, 0.7, 0.7, 0.9)
      love.graphics.draw(gameWorld.assets.sprites.ui.usedLife, self.lifex + (i - 1) * self.lifexdelta, self.lifey)
      love.graphics.setColor(1.0,1.0,1.0,1.0)
    end
  end

  end


  --love.graphics.setColor(gameWorld.colors.score)
  --love.graphics.setFont(self.score_font)

  --local score_str = comma_value(gameWorld.playerData.score) .. ".00"
  --love.graphics.printf("$", self.score_x, self.score_y, self.score_width, 'left', 0, self.scale_x, self.scale_y)
  --love.graphics.printf(score_str, self.score_x, self.score_y, self.score_width, 'right', 0, self.scale_x, self.scale_y, self.score_width * self.scale_x - self.score_width)
--end

function Overlay:addSmokePuff(x, y)
  self.smoke:createPuff(x, y)
end

function Overlay:addTipFlyer(amount, x, y)
  local score = Score:new(amount, 64, 0)
  local new_flyer = Flyer:new(score:getDrawable(), x, y, self.target_x, self.target_y)
  local dist = math.sqrt((self.target_x - x) * (self.target_x - x) + (self.target_y - y) * (self.target_y- y))
  local flight_time = gameWorld.random:randomNormal(.1, 0.5) * (dist / 450)
  if flight_time <= 0.01 then flight_time = 0.1 end
  local tween = flux.to(new_flyer, flight_time, { completion = 1.0 }):ease('circin'):oncomplete(function() gameWorld.playerData:scoreIncrease(amount) self:pulseScore() new_flyer:destroy() end)
  table.insert(self.flying, new_flyer )
end

function Overlay:pulseScore()
  flux.to(self, 0.3, { scale_x = 1.2, scale_y = 1.4 }):ease('cubicout'):after(self, 0.4, { scale_x = 1.0, scale_y = 1.0 } ):ease('elasticout')
end

return Overlay
