local class = require 'lib.middleclass'

local PI = 3.14159

local DrinkTrail = class('DrinkTrail')

function DrinkTrail:initialize()
  self.drink = {}
  self.particles = {}
  self.n = 1
  self.max = 16
end

function DrinkTrail:createTrail(x, y1, y2)
  for i=1,self.max do
    local c = gameWorld.random:random(50, 120) / 255
    local y = gameWorld.random:randomNormal(math.abs(y1-y2) / 2.8, (y2+y1) /2 )
    if y < y1 then y = y1 end
    if y > y2 then y = y2 end
    local x = x
    self.particles[i] =  { x = x, y = y, puff = self:makeTrail(c, x) }
  end
end

function DrinkTrail:stop()
  for i=1,self.max do
    if self.particles[i] then
      self.particles[i].puff:stop()
    end
  end
end

function DrinkTrail:update(dt)
  for i, k in ipairs(self.particles) do
    k.puff:update(dt)
  end

end

function DrinkTrail:draw(x, y)
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  for _, k in ipairs(self.particles) do
    love.graphics.draw(k.puff, x + k.x, y + k.y)
  end
end


function DrinkTrail:makeTrail(c, x)
  local trail = love.graphics.newParticleSystem(gameWorld.assets.sprites.ui.dot, 100)
  local r = c + gameWorld.random:randomNormal(0.05)
  local g = c + gameWorld.random:randomNormal(0.05)
  local b = c + gameWorld.random:randomNormal(0.05)
   trail:setParticleLifetime(0.01, 0.6)
   trail:setSizes(1/16, 1/4)
   trail:setSizeVariation(1)
   trail:setColors(r, g, b, 0.3, r, g, b, 0.5, r,g,b, 0.4, r,g,b,0.0)
   if x < 20 then
     trail:setDirection(PI)
     trail:setSpread(PI/512)
     trail:setEmissionRate(50 * gameWorld.random:randomNormal(0.2, 1.0))
     trail:setSpeed(100, 160)
   else
      trail:setDirection(0)
      trail:setSpread(PI/512)
      trail:setEmissionRate(150 * gameWorld.random:randomNormal(0.2, 1.0))
      trail:setSpeed(200, 250)
    end


  -- trail:setSizeVariation(1)
  -- --trail:setEmissionArea('uniform', 1280/1.8, 0)
  -- trail:setDirection(0)
  -- trail:setSpread(PI*2)
  --
  -- trail:setSizes(0.1, 0.3)
  -- trail:setColors(r, g, b, 0.0, r, g, b, 0.7, r,g,b, 0.7, r,g,b,0.0)
  -- trail:setSpin(0)
  -- trail:setSpinVariation(PI/8)
  -- trail:setLinearDamping(2, 5)
  -- trail:setRotation(0, PI * 2)
  -- trail:setRadialAcceleration(5, 30)
  -- trail:setRelativeRotation(false)
  trail:start()
  return trail

end


return DrinkTrail
