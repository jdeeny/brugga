local class = require 'lib.middleclass'
local cargo = require 'lib.cargo'
local ripple = require 'lib.ripple'

local SoundManager = class('SoundManager')

function SoundManager:initialize()
  self.music = {}
  self.ui = {}
  self.sfx = {}

  -- Some tags are used to control volume (music)
  -- Some tags are used to categorize sounds (male)
  self.tags = {
    ui = ripple.newTag(),
    music = ripple.newTag(),
    sfx = ripple.newTag(),
    drink = ripple.newTag(),
    angry = ripple.newTag(),
    male = ripple.newTag(),
  }


  self.ui.assets = cargo.init('assets')

--  for name, sound in pairs(gameWorld.assets.audio.ui) do
--    self.ui[name] = ripple.newSound({source = sound, tags = { self.tags.sfx }})
--  end
  self.ui['menuSelect'] = ripple.newSound({source = gameWorld.assets.audio.ui.menuSelect, tags = { self.tags.sfx, self.tags.ui, }})
  self.ui['menuSwitch'] = ripple.newSound({source = gameWorld.assets.audio.ui.menuSwitch, tags = { self.tags.sfx, self.tags.ui, }})
  self.ui['gameOver'] = ripple.newSound({source = gameWorld.assets.audio.ui.gameOver, tags = { self.tags.sfx, self.tags.ui, }})
  self.ui['volumeIncrease'] = ripple.newSound({source = gameWorld.assets.audio.ui.volumeIncrease, tags = { self.tags.sfx, self.tags.ui, }})
  self.ui['volumeDecrease'] = ripple.newSound({source = gameWorld.assets.audio.ui.volumeDecrease, tags = { self.tags.sfx, self.tags.ui, }})
  self.ui['musicIncrease'] = ripple.newSound({source = gameWorld.assets.audio.ui.volumeIncrease, tags = { self.tags.music, self.tags.ui, }})
  self.ui['musicDecrease'] = ripple.newSound({source = gameWorld.assets.audio.ui.volumeDecrease, tags = { self.tags.music, self.tags.ui, }})

  --for m in gameWorld.assets.music do
  --  self.music[m] = ripple.newSound({source = m, volume = gameWorld.options.musicVolume, tags = { 'music' }})
  --end
  self.music['test'] = ripple.newSound({source = gameWorld.assets.audio.music.wintersTouch, tags = { self.tags.music, }})
  self.music['test']:setLooping(true)
  self.music['title'] = ripple.newSound({source = gameWorld.assets.audio.music.wintersTouch, tags = { self.tags.music, }})
  self.music['title']:setLooping(true)
  self.music['gameplay'] = ripple.newSound({source = gameWorld.assets.audio.music.wintersTouch, tags = { self.tags.music, }})
  self.music['gameplay']:setLooping(true)
  self.music['credits'] = ripple.newSound({source = gameWorld.assets.audio.music.wintersTouch, tags = { self.tags.music, }})
  self.music['credits']:setLooping(true)

  for _, t in ipairs(self:scanTags('music/drink_male.ogg')) do
    print(t)
  end
  self.music['test']:setLooping(true)

  self.musicPlaying = false


  if gameWorld.settings.config.sfx_volume then self:setSfxVolume(gameWorld.settings.config.sfx_volume) print("1") end
  if gameWorld.settings.config.music_volume then self:setMusicVolume(gameWorld.settings.config.music_volume) print("2") end
end

function SoundManager:scanTags(path)
  local tags = {}
  for tag, _ in pairs(self.tags) do
    if string.find(path, tag) then
      table.insert(tags, tag)
    end
  end
  return tags
end

function SoundManager:playUi(name)
  print("PlayUI: " .. name)
  if self.ui[name] then self.ui[name]:play() end
end


function SoundManager:playMusic(name)
  self.tags.music:stop()
  self.music[name]:play()
end

function SoundManager:setMusicVolume(vol)
  self.tags.music.volume = vol
  gameWorld.settings.config.music_volume = vol
end

function SoundManager:setSfxVolume(vol)
  self.tags.sfx.volume = vol
  gameWorld.settings.config.sfx_volume = vol
end

function SoundManager:stopMusic()
  if self.musicPlaying and self.music[self.musicPlaying] then
    self.music[self.musicPlaying]:stop()
    self.musicPlaying = false
  end
end

function SoundManager:isMusicPlaying()
  return self.musicPlaying
end

return SoundManager
