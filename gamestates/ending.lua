local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Ending = class('Ending', Gamestate)

function Ending:update(dt)
  if gameWorld.playerInput:pressed 'ok' then
    print("exit ending")
    gameWorld.gamestate:setState('credits')
  end
end

return Ending
