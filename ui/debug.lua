local class = require 'lib.middleclass'

local DebugUi = class('DebugUi')

function DebugUi:initialize()
  self.font = gameWorld.assets.fonts.generic(16)
  self.color = { 0.0, 1.0, 0.0, 1.0 }
  self.left = 1100
  self.top = 30
end

function DebugUi:update(dt)
end

function DebugUi:draw()
  local start_time = love.timer.getTime()
  love.graphics.setFont(self.font)
  love.graphics.setColor(self.color)
  love.graphics.print("FPS: "..love.timer.getFPS(), self.left, self.top)
  local dc = love.graphics.getStats()
  love.graphics.print("draws: "..dc.drawcalls, self.left, self.top + 20)
  love.graphics.print("switches: "..dc.canvasswitches.." / "..dc.shaderswitches, self.left, self.top + 40)
  love.graphics.print(math.floor((love.timer.getTime() - start_time) * 1000000) / 1000 .. " ms", self.left, self.top + 60)
  love.graphics.setColor(255, 255, 255, 255)
end


return DebugUi
