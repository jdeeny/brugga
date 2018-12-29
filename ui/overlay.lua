local class = require 'lib.middleclass'

local function comma_value(amount)
  local formatted = amount
  local k = nil
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end


local Overlay = class('Overlay')

function Overlay:initialize()
  self.flying = {}
  self.score_font = gameWorld.assets.fonts.score(60)
  self.flyer_font = gameWorld.assets.fonts.score(40)
  self.score_width = 300
  self.score_x = 1280 - self.score_width - 50
  self.score_y = 720 - 100

  self.flight_time = 0.7
end

function Overlay:update(dt)
  for i, f in ipairs(self.flying) do
    if f.done >= 0.999 then
      self.flying[i] = nil
    end
  end
end

function Overlay:draw()
  love.graphics.setColor(gameWorld.colors.score)
  love.graphics.setFont(self.flyer_font)
  for _, f in ipairs(self.flying) do
    local x = f.x * (1 - f.done) + self.score_x * f.done
    local y = f.y * (1 - f.done) + self.score_y * f.done

    love.graphics.draw(f.text, x, y)

  end


  love.graphics.setColor(gameWorld.colors.score)
  love.graphics.setFont(self.score_font)

  local score_str = comma_value(gameWorld.playerData.score) .. ".00"
  love.graphics.printf("$", self.score_x, self.score_y, self.score_width, 'left')
  love.graphics.printf(score_str, self.score_x, self.score_y, self.score_width, 'right')
end

function Overlay:addFlyer(amount, x, y)
  print("Add flyer: " .. amount .." "..x.." "..y)
  local score_str = '$ ' .. comma_value(gameWorld.playerData.score) .. ".00"
  local text = love.graphics.newText(self.flyer_font, score_str)
  local new_flyer = { done = 0.0, amount = amount, text = text, x = x, y = y }
  table.insert(self.flying, new_flyer)
  local t = self.flight_time + (love.math.random(self.flight_time / 10) - (self.flight_time / 20))
  print("score ".. self.score_x.." "..self.score_y)
  flux.to(new_flyer, t, { done = 1.0 })
end

return Overlay
