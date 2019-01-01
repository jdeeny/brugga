local class = require 'lib.middleclass'

local PI = 3.14159

local SmokePuff = class('SmokePuff')

function SmokePuff:initialize()
  self.drink = {}
  self.particles = {}
  self.n = 1
  self.max = 6
end

function SmokePuff:createPuff(x, y)
  self.particles[self.n] =  { x = x, y = y, puff = self:makeSmoke(0.7,0.7,0.7) }
  self.n = self.n + 1
  if self.n > self.max then self.n = 1 end
end

function SmokePuff:update(dt)
  for i, k in ipairs(self.particles) do
    k.puff:update(dt)
  end

end
function SmokePuff:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  for _, k in ipairs(self.particles) do
    love.graphics.draw(k.puff, k.x, k.y)
  end
end


function SmokePuff:makeSmoke(r, g, b)
  local suds = love.graphics.newParticleSystem(gameWorld.assets.sprites.ui.puff, 5)
  suds:setParticleLifetime(0.7, 1.5)
  suds:setSizeVariation(1)
  --suds:setEmissionArea('uniform', 1280/1.8, 0)
  suds:setDirection(0)
  suds:setSpread(PI*2)
  suds:setSpeed(55, 55)
  suds:setSizes(0.1, 0.3)
  suds:setColors(r, g, b, 0.8, r, g, b, 0.6, 1, 1, 1, 0.0)
  suds:setSpin(0)
  suds:setSpinVariation(PI/8)
  suds:setLinearDamping(2, 5)
  suds:setRotation(0, PI * 2)
  suds:setRadialAcceleration(5, 30)
  suds:setRelativeRotation(false)
  suds:setEmissionRate(20)
  suds:setEmitterLifetime(0.2)
  suds:start()
  return suds

end


return SmokePuff
