local anim8 = require('lib.anim8')
local arch = require('entities.archetypes.archetype'):new('brugga')

arch:addImage('main', gameWorld.assets.sprites.brugga.BruggaSprites)
arch:addGrid('main', anim8.newGrid(282, 340, arch.images.main:getWidth(), arch.images.main:getHeight(), 0, 0, 0))

arch:addTagset({'brugga'})

arch:addAnimation('idle', { image = arch.images.main, grid = arch.grids.main(1, 1), rate = 0.1 } )
arch:addAnimation('hold', { image = arch.images.main, grid = arch.grids.main(2, 1), rate = 0.1 } )
arch:addAnimation('lose', { image = arch.images.main, grid = arch.grids.main(3, 1), rate = 0.1 } )
arch:addAnimation('throw', { image = arch.images.main, grid = arch.grids.main(4, 1), rate = 0.1 } )
arch:addAnimation('pour', { image = arch.images.main, grid = arch.grids.main(5, 1), rate = 0.1 } )

return arch
