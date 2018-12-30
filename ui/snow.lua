local class = require 'lib.middleclass'

local Snow = class('Snow')

local PI = 3.14159
local DOWN = PI/2

function Snow:initialize()

  self.particles = {
    low = love.graphics.newParticleSystem(gameWorld.assets.sprites.snow.simple, 500),
    med = love.graphics.newParticleSystem(gameWorld.assets.sprites.snow.med, 500),
    high = love.graphics.newParticleSystem(gameWorld.assets.sprites.snow.fancy, 500)
  }

  for _, sys in pairs(self.particles) do
    sys:setParticleLifetime(100, 100)
    sys:setSizeVariation(1)
    sys:setEmissionArea('uniform', 1280/1.8, 0)
    --sys:setLinearAcceleration(0, 1, 0, 1)
    sys:setDirection(DOWN)
    sys:setSpread(PI/16)
    sys:setSpeed(30, 55)
    sys:setSizes(0.1)
    sys:setColors(1.0, 1.0, 1.0, 0.4)
    sys:setSpin(0-PI/8, PI/8)
    sys:setSpinVariation(1)
    sys:setRotation(0, PI * 2)
    sys:setRadialAcceleration(0, 0.2)
    sys:setRelativeRotation(false)
    sys:setTangentialAcceleration(0.0, 0.1)
  end


  self.particles.low:setEmissionRate(5)
  self.particles.med:setEmissionRate(2)
  self.particles.high:setEmissionRate(0.5)

  for _, sys in pairs(self.particles) do
    sys:start()
    for i=1,100 do sys:update(0.5) end
  end

end

function Snow:update(dt)
  for _, sys in pairs(self.particles) do
    sys:update(dt)
  end
end

function Snow:draw()
  love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
  for _, sys in pairs(self.particles) do
    love.graphics.draw(sys, 1280/2, -50)
  end
end

return Snow
