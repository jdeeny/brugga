local class = require 'lib.middleclass'
local anim8 = require('lib.anim8')

local Archetypes = class('Archetypes')

function Archetypes:initialize()
  -- Source images
  self.images = {
    elf_a = gameWorld.assets.sprites.patrons.test,
  }
  -- Grid for each image
  self.grids = {
    elf_a = anim8.newGrid(32, 32, self.images.elf_a:getWidth(), self.images.elf_a:getHeight(), 0, 0, 0),
  }

  -- List of archetypes, with animation and sound info
  self.kinds = {
      elf_a = {
      sitting = { self.images.elf_a, anim8.newAnimation(self.grids.elf_a('1-3', 1), 0.1) }, -- animations
      drinking = { self.images.elf_a, anim8.newAnimation(self.grids.elf_a('3-1', 1), 0.1) }, -- animations
      tagsets = {               -- When finding sfx, use these tags
        { 'male', 'female', },
        { 'elf', }
      }
    },
  }

end

function Archetypes:getRandom()
  local kinds = #self.kinds
  local pick = love.math.random(#self.kinds)
  for kind, data in pairs(self.kinds) do
    pick = pick - 1
    if pick == 0 then return data end
  end
  print("Pick didn't find something!?")
  return nil
end


return Archetypes
