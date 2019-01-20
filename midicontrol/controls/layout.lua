local class = require 'lib.middleclass'

local Layout = class('MidiLayout')


function Layout:initialize()
  self.controls = {}
  return self
end

function Layout:addControl(control, x, y)
  self.controls[#self.controls+1] = { control=control, x=x, y=y }
  return self
end

return Layout
