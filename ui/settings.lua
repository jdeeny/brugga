local bitser = require 'lib.bitser'
local class = require 'lib.middleclass'

local Settings = class('Settings')

function Settings:initialize()
  self.filename = 'config'
  self.config = {}
  self:defaults()
end

function Settings:defaults()
  self.config.sfx_volume = 0.7
  self.config.music_volume = 0.6
end

function Settings:load()
  print("Load")
  if love.filesystem.getInfo(self.filename) then
    local conf = bitser.loadLoveFile(self.filename)
    if conf.sfx_volume then self.config.sfx_volume = conf.sfx_volume end
    if conf.music_volume then self.config.music_volume = conf.music_volume end
    pretty.dump(self.config)
  else
    return false
  end
end

function Settings:save()
  print("Save")
  pretty.dump(self.config)
  bitser.dumpLoveFile(self.filename, self.config)
end

return Settings
