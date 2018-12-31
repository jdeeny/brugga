local class = require 'lib.middleclass'

local PI = 3.14159

local DustPuff = class('DustPuff')

function DustPuff:initialize()
  self.drink = {}
  self.particles = {}
  self.n = 1
  self.max = 2
end

function DustPuff:createPuff(x, y)
  self.particles[1] =  { x = x, y = y, puff = self:makeDust(0.7,0.7,0.7, -PI/2 ) }
  self.particles[2] =  { x = x, y = y, puff = self:makeDust(0.7,0.7,0.7, 3 / 2 * PI ) }
  self.n = self.n + 1
  if self.n > self.max then self.n = 1 end
end

function DustPuff:update(dt)
  for i, k in ipairs(self.particles) do
    k.puff:update(dt)
  end

end
function DustPuff:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  for _, k in ipairs(self.particles) do
    love.graphics.draw(k.puff, k.x, k.y)
  end
end


function DustPuff:makeDust(r, g, b)
  print("dust")
  local dust = love.graphics.newParticleSystem(gameWorld.assets.sprites.ui.dust, 25)
  dust:setParticleLifetime(0.7, 1.5)
  dust:setSizeVariation(1)
  --dust:setEmissionArea('uniform', 1280/1.8, 0)
  dust:setDirection(0)
  dust:setSpread(PI*2)
  dust:setSpeed(55, 55)
  dust:setSizes(0.1, 0.3)
  dust:setColors(r, g, b, 0.8, r, g, b, 0.6, 1, 1, 1, 0.0)
  dust:setSpin(0)
  dust:setSpinVariation(PI/8)
  dust:setLinearDamping(2, 5)
  dust:setRotation(0, PI * 2)
  dust:setRadialAcceleration(5, 30)
  dust:setRelativeRotation(false)
  dust:setEmissionRate(20)
  dust:setEmitterLifetime(0.2)
  dust:start()
  return dust

end


return DustPuff
