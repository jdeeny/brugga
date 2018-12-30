local class = require 'lib.middleclass'
local colors = require 'ui.colors'

local Score = class('Score')

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

function Score:initialize(amount, size, spaces)
  self.spaces = spaces or 0
  self.amount = amount
  self.size = size or 64
  self.font = gameWorld.assets.fonts.score(self.size)
  self.outline = require('ui.outline'):new(self.font, 3)
end

function Score:getDrawable()
  local offset = 6
  local _str = comma_value(gameWorld.playerData.score) .. ".00"
  local score_str
  if self.spaces == 0 then
    score_str = "$" .. string.rep(" ", self.spaces - #_str) .. _str
  else
    score_str = "$" .. _str
  end

  return self.outline:getOutline(score_str, colors.score, colors.score_back)
end

return Score
