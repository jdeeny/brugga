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

    if ( (r * r) > 0.0001) { return false; }
    if ( (g * g) > 0.0001) { return false; }
    if ( (b * b) > 0.0001) { return false; }
    if ( (a * a) > 0.0001) { return false; }

    return true;
  }

  vec4 effect(vec4 color, Image tex, vec2 tc, vec2 _) {
    vec4 c = Texel(tex, tc);
    vec4 outc = c;// * color;
    if (comp(outc, in_colors[0])) {
      outc.rgb = out_colors[0].rgb;
    }
    if (comp(outc, in_colors[1])) {
      outc.rgb = out_colors[1].rgb;
    }
    if (comp(outc, in_colors[2])) {
      outc.rgb = out_colors[2].rgb;
    }
    if (comp(outc, in_colors[3])) {
      outc.rgb = out_colors[3].rgb;
    }

    return outc;
  }]]

local defaults = {
  in_colors = {{0,0,0,1},{0,0,0,0},{0,0,0,0},{0,0,0,0},},
  out_colors = {{0,0,0,1},{0,0,0,0},{0,0,0,0},{0,0,0,0},},
}

local setters = {}

setters.in_colors = function(c)
  for i=1,4 do
    if not c[i] then
      c[i] = { 0, 0, 0, 0 }
    end
  end
  print("send in")
  pretty.dump(c)
  shader:send("in_colors", c[1], c[2], c[3], c[4])
end

setters.out_colors = function(c)
  for i=1,4 do
    if not c[i] then
      c[i] = { 0, 0, 0, 0 }
    end
  end
  print("send out")
  pretty.dump(c)
  shader:send("out_colors", c[1], c[2], c[3], c[4])
end



function PaletteSwap:initialize()
  --self.swaps = {
--    none = { },
--  }
  self.current = 'none'
  self._effect = moonshine.Effect{
    name = "PaletteSwap",
    shader = shader,
    setters = setters,
    defaults = defaults
  }
  self.effect = moonshine(self._effect)
end

--function PaletteSwap:addSwap(swaps)
--  self.swaps[#self.swaps + 1] = swaps
--  return #self.swaps
--end

--function PaletteSwap:removeSwap(name)
--  self.swaps[name] = nil
--end

function PaletteSwap:setSwap(i, o)
  self.effect.PaletteSwap.in_colors = i
  self.effect.PaletteSwap.out_colors = o
end

function PaletteSwap:clearSwap()
  self.effect.in_colors = {}
  self.effect.out_colors = {}
end

function PaletteSwap:doEffect(func)
  self.effect(func)
end


return PaletteSwap
