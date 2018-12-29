local anim8 = require('lib.anim8')
local arch = require('entities.archetypes.archetype'):new('elf_female')

arch:addImage('main', gameWorld.assets.sprites.patrons.elf_female)
arch:addGrid('main', anim8.newGrid(209, 297, arch.images.main:getWidth(), arch.images.main:getHeight(), 0, 0, 0))

arch:addAnimation('advance', { image = arch.images.main, grid = arch.grids.main(2, 1), rate = 0.1 } )
arch:addAnimation('drink', { image = arch.images.main, grid = arch.grids.main(1, 1), rate = 0.1 } )
arch:addAnimation('hit', { image = arch.images.main, grid = arch.grids.main(3, 1), rate = 0.1 } )


arch:addTagset({ 'female', 'anygender' })
arch:addTagset({ 'elf', 'anykind' })
arch:setRarity(1.0)
arch:setSpeed(1.0)

return arch