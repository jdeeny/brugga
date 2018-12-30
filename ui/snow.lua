local class = require 'lib.middleclass'

local Snow = class('Snow')

function Snow:initialize()

  self.particles = {
    low = love.graphics.newParticleSystem(gameWorld.assets.sprites.snow.simple, 500),
    med = love.graphics.newParticleSystem(gameWorld.assets.sprites.snow.med, 500),
    high = love.graphics.newParticleSystem(gameWorld.assets.sprites.snow.fancy, 500)
  }

  for _, sys in pairs(self.particles) do
    sys:setParticleLifetime(10, 10)
    sys:setEmissionRate(10)
    sys:setSizeVariation(1)
    sys:setAreaSpread('uniform', 1280 / 1.8, 1280 / 1.8)
    --sys:setLinearAcceleration(0, 1, 0, 1)
    sys:start()
  end
end

function Snow:update(dt)
  for _, sys in pairs(self.particles) do
    sys:update(dt)
  end
end

function Snow:draw()
  for _, sys in pairs(self.particles) do
    love.graphics.draw(sys, 1280/2, -50)
  end
end

return Snow
