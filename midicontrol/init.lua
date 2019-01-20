local class = require 'lib.middleclass'
local midi = require('luamidi')
local bit = require("bit")

local MidiControl = class('MidiControl')

local controllers = {
  xtouch = require('midicontrol.xtouchmini'),
}


function MidiControl:initialize(inport, outport, controller)
  assert(inport and outport and midi.getinportcount() > inport and midi.getoutportcount() > outport, "Invalid ports")
  self.inport = inport
  self.outport = outport
  self.controller = self:findController()
  assert(self.controller, "Invalid controller")

  self.handlers = {}
  self.overlay = require('midicontrol.overlay'):new()
end

function MidiControl:findController()
  assert(midi.getInPortName(self.inport) == midi.getOutPortName(self.outport), "In and Out must be same device")
  local name = midi.getInPortName(self.inport)
  for n, c in pairs(controllers) do
    if name:find(c.name) then
      return c
    end
  end
  return nil
end

function MidiControl:update(dt)
  repeat
    local port, control, velocity, _delta = midi.getMessage(self.inport)
    if port then
--      local kind = bit.band(bit.rshift(port, 4), 7)
  --    print(kind .. " - " ..message_kinds[kind])
      print("Port " .. port .. " " .. control .. " " .. velocity)

    end
  until not port
end

function MidiControl:ringMode(n, mode)
  self.outport:sendMessage(0x80 + 0x30 + 0, n, mode)
end

function MidiControl:buttonLed(n, mode)
  self.outport:sendMessage(0x80 + 0x10 + 0, n, mode)
end

function MidiControl:addToggle(channel)

end

function MidiControl:draw()
  self.overlay:draw()
end



return MidiControl
