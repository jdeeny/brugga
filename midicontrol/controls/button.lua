local class = require 'lib.middleclass'
local Control = require 'midicontrol.controls.control'

local Button = class('MidiButton', Control)

function Button:initialize()
  Control.initialize(self)
  self.kind = 'button'
end

return Button
