-- Describes to controls available with the Behringer X-Touch Mini

--[[
  Physically has 8 knobs, 16 buttons, 1 volume slider and 2 layers
  Virtually has 16 knobs, 32 buttons, 2 volumes sliders

  Layer A is the first 8 knobs, B the second, etc. The layer can be changed
  manually or remotely.

  Remote Layer Select [ Program Change: 0 = A, 1 = B ]

  Read Knob Value [ Read CC1-CC8 (A)  CC11-18 (B) ]
  Read Knob Button Press [ Note 0-7 (A)  24-32 (B) ]
  Read Button Press [ Note 8 - 23 (A)  32-47 (B) ]

  Set Button LED mode [ Note 0-15 (A), 16-31 (B)] [ Note Off or Velocity 0 = Off, 1=on, 2=blink, 3-127=ignore ]

  Set Knob Ring LED Behavior [ CC1 - CC8 (A) : 0 = single, 1 = pan, 2 = fan, 3 = spread, 4 = trim, 5-127 = ignore ]
  Set Knob LED Value [ CC9 - CC16: 0=off, 1-13=on, 14-26=blink, 27=allon, 28=allblink, 29-127=ignore ]


  Volume Slider
    Read Value [ Read CC9 (A) CC10 (B)]
]]

local Messages = require 'midicontrol.messages'
local NoteOff = Messages.NoteOff
local NoteOn = Messages.NoteOn
local Layout = require 'midicontrol.controls.layout'
local Button = require 'midicontrol.controls.button'
local Knob = require 'midicontrol.controls.knob'

local Mini = {
  name = "X-TOUCH MINI",
  size = { 11, 4 },
  controls = require('midicontrol.controls.layout'):new()
              :addControl(Button:new("Button 1", NoteOn(8), NoteOff(8), NoteOn(0)), 2, 1)
              :addControl(Button:new("Button 2", NoteOn(9), NoteOff(8), NoteOn(1)), 2, 2)
              :addControl(Button:new("Button 3", NoteOn(10), NoteOff(8), NoteOn(2)), 2, 3),

}

return Mini

--[[  knobs = {
  },
  buttons = {
    { name="Button 1A", in_note=8, led_note=0 },
    { name="Button 2A", in_note=9, led_note=1 },
    { name="Button 3A", in_note=10, led_note=2 },
    { name="Button 4A", in_note=11, led_note=3 },
    { name="Button 5A", in_note=12, led_note=4 },
    { name="Button 6A", in_note=13, led_note=5 },
    { name="Button 7A", in_note=14, led_note=6 },
    { name="Button 8A", in_note=15, led_note=7 },
    { name="Button 9A", in_note=16, led_note=8 },
    { name="Button 10A", in_note=17, led_note=9 },
    { name="Button 11A", in_note=18, led_note=10 },
    { name="Button 12A", in_note=19, led_note=11 },
    { name="Button 13A", in_note=20, led_note=12 },
    { name="Button 14A", in_note=21, led_note=13 },
    { name="Button 15A", in_note=22, led_note=14 },
    { name="Button 16A", in_note=23, led_note=15 },

    { name="Button 1B", in_note=32, led_note=16 },
    { name="Button 2B", in_note=33, led_note=17 },
    { name="Button 3B", in_note=34, led_note=18 },
    { name="Button 4B", in_note=35, led_note=19 },
    { name="Button 5B", in_note=36, led_note=20 },
    { name="Button 6B", in_note=37, led_note=21 },
    { name="Button 7B", in_note=38, led_note=22 },
    { name="Button 8B", in_note=39, led_note=23 },
    { name="Button 9B", in_note=40, led_note=24 },
    { name="Button 10B", in_note=41, led_note=25 },
    { name="Button 11B", in_note=42, led_note=26 },
    { name="Button 12B", in_note=43, led_note=27 },
    { name="Button 13B", in_note=44, led_note=28 },
    { name="Button 14B", in_note=45, led_note=29 },
    { name="Button 15B", in_note=46, led_note=30 },
    { name="Button 16B", in_note=47, led_note=31 },

  },
]]
