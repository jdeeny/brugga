local class = require 'lib.middleclass'
local midi = require('luamidi')

local MidiControl = class('MidiControl')


function MidiControl:initialize(inport, outport)
  assert(inport and midi.getinportcount() > inport, "Invalid inport")
  assert(outport and midi.getoutportcount() > outport, "Invalid outport")
  print("Inport: " .. midi.enumerateinports()[inport])
  print("Outport: " .. midi.enumerateoutports()[outport])
  self.inport_n = inport
  self.outport_n = outport
  self.inport = midi.openin(inport)
  self.outport = midi.openout(outport)
end

function MidiControl:update(dt)
  repeat
    local port, control, velocity, _delta = midi.getMessage(self.inport_n)
    if port then
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

local function overlay()
  love.graphics.setColor(0.01, 0.01, 0.01, 0.85)
  love.graphics.rectangle('fill', 800, 500, 300, 200, 16, 16)
  love.graphics.setColor(0.9, 0.9, 0.9, 1.0)
  love.graphics.printf("Text", 800, 540, 300, 'center')
end

function MidiControl:draw()

  overlay()
end



return MidiControl
