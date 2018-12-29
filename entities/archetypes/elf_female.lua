local anim8 = require('lib.anim8')
local arch = require('entities.archetypes.archetype'):new('elf_female')

arch:addImage('main', gameWorld.assets.sprites.patrons.elf_female)
arch:addGrid('main', anim8.newGrid(209, 234, arch.images.main:getWidth(), arch.images.main:getHeight(), 0, 0, 0))
arch:addAnimation('advance', anim8.newAnimation(arch.grids.main(2, 1), 0.1) )
arch:addAnimation('drink', anim8.newAnimation(arch.grids.main(1, 1), 0.1) )
arch:addAnimation('holding', anim8.newAnimation(arch.grids.main(3, 1), 0.1) )

arch:addTagset({ 'female', 'anygender' })
arch:addTagset({ 'elf', 'anykind' })
arch:setRarity(1.0)
arch:setSpeed(1.0)

return arch
