local class = require 'lib.middleclass'

local Archetype = class('Archetype')

function Archetype:initialize(name)
  self.name = name or 'unnamed'
  self.images = {}
  self.grids = {}
  self.animations = {}
  self.tagsets = {}
  self.speed = 1.0
  self.rarity = 1.0
end

function Archetype:addImage(name, image)
  self.images[name] = image
  pretty.dump(image)
end

function Archetype:addGrid(name, grid)
  self.grids[name] = grid
end

function Archetype:addAnimation(name, animation)
  self.animations[name] = animation
end

function Archetype:addTagset(tags)
  self.tagsets[#self.tagsets + 1] = tags
end

function Archetype:setRarity(rarity)
  self.rarity = rarity
end

function Archetype:setSpeed(speed)
  self.speed = speed
end

return Archetype