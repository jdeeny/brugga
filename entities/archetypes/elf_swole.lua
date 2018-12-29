local arch = require('entities.archetypes.archetype'):new('elf_swole')

arch:addImage(gameWorld.assets.sprites.patrons.elf_swole, 'main')
arch:addGrid(anim8.newGrid(244, 297, self.images.main:getWidth(), self.images.main:getHeight(), 0, 0, 0), 'main')
arch:addAnimation(anim8.newAnimation(self.grids.main(2, 1, 0.1), 'sitting'))
arch:addAnimation(anim8.newAnimation(self.grids.main(1, 1, 0.1), 'drinking'))
arch:addAnimation(anim8.newAnimation(self.grids.main(3, 1, 0.1), 'holding'))

arch:addTagset({ 'male' })
arch:addTagset({ 'elf', })
arch:setRarity(1.0)
arch:setSpeed(1.0)

return arch
