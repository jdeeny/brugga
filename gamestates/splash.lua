local class = require 'lib.middleclass'

local Splash = class('Splash', Gamestate)

function Splash:initialize()
  self.super.initialize(self)
  self.controls = {
    'ok' = { 'key:enter', },
    'cancel' = { 'key:escape', },
  }
end

return Splash
