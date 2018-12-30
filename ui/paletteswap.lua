local class = require 'lib.middleclass'
local moonshine = require 'lib.moonshine'

local PaletteSwap = class('PaletteSwap')

local shader = love.graphics.newShader[[
  extern vec4 in_colors[4];
  extern vec4 out_colors[4];

  bool comp(vec4 lhs, vec4 rhs) {
    float r = lhs.r - rhs.r;
    float g = lhs.g - rhs.g;
    float b = lhs.b - rhs.b;
    float a = lhs.a - rhs.a;

    if ( r * r > 0.001) { return false; }
    if ( g * g > 0.001) { return false; }
    if ( b * b > 0.001) { return false; }
    if ( a * a > 0.001) { return false; }

    return true;
  }

  vec4 effect(vec4 color, Image tex, vec2 tc, vec2 _) {
    vec4 c = Texel(tex, tc);
    vec4 outc = c * color;
    if (comp(outc, in_colors[0])) {
      outc = out_colors[0];
    }
    if (comp(outc, in_colors[1])) {
      outc = out_colors[1];
    }
    if (comp(outc, in_colors[2])) {
      outc = out_colors[2];
    }
    if (comp(outc, in_colors[3])) {
      outc = out_colors[3];
    }

    return outc;
  }]]

local defaults = {
  in_colors = {{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},},
  out_colors = {{1,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,1,1},},
}

local setters = {}

setters.in_colors = function(c)
  local colors = {}
  for i=1,4 do
    if c[i] then
      assert(type(c[i]) == "table" and #c[i] == 4, "invalid color")
      colors[#colors + 1] = c[i]
    else
      colors[#colors + 1] = { 1, 1, 1, 1 }
    end
  end
  shader:send("out_colors", colors[1], colors[2], colors[3], colors[4])
end

setters.out_colors = function(c)
  local colors = {}
  for i=1,4 do
    if c[i] then
      assert(type(c[i]) == "table" and #c[i] == 4, "invalid color")
      colors[#colors + 1] = c[i]
    else
      colors[#colors + 1] = { 1, 1, 1, 1 }
    end
  end
  shader:send("out_colors", colors[1], colors[2], colors[3], colors[4])
end



function PaletteSwap:initialize()
  self.swaps = {
    none = { },
  }
  self.current = 'none'
  self._effect = moonshine.Effect{
    name = "PaletteSwap",
    shader = shader,
    setters = setters,
    defaults = defaults
  }
  self.effect = moonshine(self._effect)
end

function PaletteSwap:addSwap(name, swaps)
  self.swaps[name] = swaps
end

function PaletteSwap:removeSwap(name)
  self.swaps[name] = nil
end

function PaletteSwap:setSwap(name)
  --local name = name or 'none'
  --if not self.swaps[name] then return end
  --self.current = name
  --self.effect.in_colors = self.swaps[name][1]
  --self.effect.out_colors = self.swaps[name][2]
end

function PaletteSwap:doEffect(func)
  self.effect(func)
end


return PaletteSwap
