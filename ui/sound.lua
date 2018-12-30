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

  --self.ui.assets = cargo.init('assets')

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


  self.sfx['coin'] = ripple.newSound({source = gameWorld.assets.audio.sfx.money1, tags = { self.tags.sfx, }})
  self.sfx['coindown'] = ripple.newSound({source = gameWorld.assets.audio.sfx.money2, tags = { self.tags.sfx, }})


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
  self.music['ending'] = ripple.newSound({source = gameWorld.assets.audio.music.wintersTouch, tags = { self.tags.music, }})
  self.music['ending']:setLooping(true)

  self.music.stacked = {}
  --local dec = love.sound.newDecoder('assets/audio/music/gameplay1'):decode()
  self.music.stacked[1] = love.sound.newDecoder('assets/audio/music/gameplay1.ogg', 4 * 1024)--:decode()
  self.music.stacked[2] = love.sound.newDecoder('assets/audio/music/gameplay2.ogg', 4 * 1024)--:decode()
  self.music.stacked[3] = love.sound.newDecoder('assets/audio/music/gameplay3.ogg', 4 * 1024)--:decode()
  self.music.stacked[4] = love.sound.newDecoder('assets/audio/music/gameplay4.ogg', 4 * 1024)--:decode()
  self.music.stacked[5] = love.sound.newDecoder('assets/audio/music/gameplay5.ogg', 4 * 1024)--:decode()
  self.music.stacked[6] = love.sound.newDecoder('assets/audio/music/gameplay6.ogg', 4 * 1024)--:decode()
  self.music.stacked[7] = love.sound.newDecoder('assets/audio/music/gameplay7.ogg', 4 * 1024)--:decode()
  self.music.stacked[8] = love.sound.newDecoder('assets/audio/music/gameplay8.ogg', 4 * 1024)--:decode()
  self.music.stacked[9] = love.sound.newDecoder('assets/audio/music/gameplay9.ogg', 4 * 1024)--:decode()
  self.music.stacked[10] = love.sound.newDecoder('assets/audio/music/gameplay10.ogg', 4 * 1024)--:decode()


  --self.music.stacked[11] = ripple.newSound({source = gameWorld.assets.audio.music.gameplay1, tags = { self.tags.music, }})

  self.stemstack = require('ui.stemstack'):new(self.music.stacked)

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

function SoundManager:update(dt)
  self.stemstack:update(dt)
end

function SoundManager:playUi(name)
  if self.ui[name] then self.ui[name]:play() end
end

function SoundManager:playSfx(name)
  if self.sfx[name] then self.sfx[name]:play() end
end


function SoundManager:playMusic(name)
  self.tags.music:stop()
  --self.music[name]:play()
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

function SoundManager:playStacked(level)
  self.stemstack:setLevel(level)
end


return SoundManager
