local class = require 'lib.middleclass'
local anim8 = require('lib.anim8')

local Archetypes = class('Archetypes')

function Archetypes:initialize()
  -- Source images
  self.images = {
    elf_test = gameWorld.assets.sprites.patrons.test,
    elf_swole = gameWorld.assets.sprites.patrons.swole_elf
  }
  -- Grid for each image
  self.grids = {
    elf_test = anim8.newGrid(32, 32, self.images.elf_test:getWidth(), self.images.elf_test:getHeight(), 0, 0, 0),
    elf_swole = anim8.newGrid(342, 434)
  }

  -- List of archetypes, with animation and sound info
  self.kinds = {
    elf_test = {
      sitting = { self.images.elf_test, anim8.newAnimation(self.grids.elf_test('1-3', 1), 0.1) },
      drinking = { self.images.elf_test, anim8.newAnimation(self.grids.elf_test('3-1', 1), 0.1) },
      tagsets = {               -- When finding sfx, use these tags
        { 'male', 'female', 'nonspecific' },
        { 'elf', }
      }
    },

    elf_swole = {
      sitting = { self.images.elf_swole, anim8.newAnimation(self.grids.elf_swole(2, 1), 0.1) },
      holding = { self.images.elf_swole, anim8.newAnimation(self.grids.elf_swole(3, 1), 0.1) },
      drinking = { self.images.elf_swole, anim8.newAnimation(self.grids.elf_swole(1, 1), 0.1) },
      tagsets = {               -- When finding sfx, use these tags
        { 'male', }, -- should this have nonspecific or is he too swole?
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
