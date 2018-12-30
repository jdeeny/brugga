local class = require 'lib.middleclass'
local colors = require 'ui.colors'

local Score = class('Score')



-- from sam_lie
-- Compatible with Lua 5.0 and 5.1.
-- Disclaimer : use at own risk especially for hedge fund reports :-)

---============================================================
-- add comma to separate thousands
--
local function comma_value(amount)
  local formatted = amount
  local k
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

---============================================================
-- rounds a number to the nearest decimal places
--
local function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

--===================================================================
-- given a numeric value formats output with comma to separate thousands
-- and rounded to given decimal places
--
--
local function format_num(amount, decimal, prefix, neg_prefix)
  local str_amount,  formatted, famount, remain

  decimal = decimal or 2  -- default 2 decimal places
  neg_prefix = neg_prefix or "-" -- default negative sign

  famount = math.abs(round(amount,decimal))
  famount = math.floor(famount)

  remain = round(math.abs(amount) - famount, decimal)

        -- comma to separate the thousands
  formatted = comma_value(famount)

        -- attach the decimal portion
  if (decimal > 0) then
    remain = string.sub(tostring(remain),3)
    formatted = formatted .. "." .. remain ..
                string.rep("0", decimal - string.len(remain))
  end

        -- attach prefix string e.g '$'
  formatted = (prefix or "") .. formatted

        -- if value is negative then format accordingly
  if (amount<0) then
    if (neg_prefix=="()") then
      formatted = "("..formatted ..")"
    else
      formatted = neg_prefix .. formatted
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
  local _str = format_num(self.amount, 2, '', '()')
  local score_str
  if self.spaces == 0 then
    score_str = "$" .. string.rep(" ", self.spaces - #_str) .. _str
  else
    score_str = "$" .. _str
  end
  local fg = colors.score
  local bg = colors.score_back
  if self.amount <= -0.005 then
    fg = colors.bad_score
    bg = colors.bad_score_back
  end
  return self.outline:getOutline(score_str, fg, bg)

end

return Score
