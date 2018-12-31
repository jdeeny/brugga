local class = require 'lib.middleclass'
local Gamestate = require 'gamestates.gamestate'

local Tutorial = class('Tutorial', Gamestate)

function Tutorial:initialize(name)
  Gamestate.initialize(self, name)
  self.fade = 0.0

  self.titlefont = gameWorld.assets.fonts.title(48)
  self.textfont = gameWorld.assets.fonts.generic(32)
end


function Tutorial:enter()
  self.fade = 1.0
  flux.to(self, 1, { fade = 0.0 }):ease("quadinout")

  self.backsnow = require('ui.snow'):new()
  self.snow = require('ui.snow'):new()
  gameWorld.sound:playMusic('credits')

  self.images = gameWorld.assets.sprites.tutorial
  self.pourImages = {
    self.images.pourSet1,
    self.images.pourSet2,
    self.images.pourSet3
  }
  self.sendImages = {
    self.images.sendSet1,
    self.images.sendSet2,
    self.images.sendSet3
  }
  self.mouseImages = {
    left = self.images.mouseLeft,
    right = self.images.mouseRight,
    middle = self.images.mouseMiddle,
    none = self.images.mouseNone
  }

  self.pour_image = {
    image = self.pourImages,
    x = 40, y = 75,
    frame = 1, frames = 3, duration = 1, timer = 1 }
  self.send_image = {
    image = self.sendImages,
    x = 840, y = 100,
    frame = 1, frames = 3, duration = 1, timer = 1 }
  self.mouse_image = {
    pour = {
      image = {
        self.mouseImages.none,
        self.mouseImages.right,
        self.mouseImages.none,
      },
      x = 180, y = 500,
      frame = 1, frames = 3, duration = 1, timer = 1
    },
    send = {
      image = {
        self.mouseImages.none,
        self.mouseImages.left,
        self.mouseImages.none,
      },
      x = 950, y = 500,
      frame = 1, frames = 3, duration = 1, timer = 1
    }
  }
end

function Tutorial:exit()
end

function Tutorial:update(dt)
  self.backsnow:update(dt*0.9)
  self.snow:update(dt)
  if gameWorld.playerInput:pressed('action') then
    flux.to(self, 0.2, { fade = 1.0 }):oncomplete(function() gameWorld.gameState:setState('gameplay') end)
  end

  ---- Update timers
  -- Pour
  self.pour_image.timer = self.pour_image.timer - dt
  if self.pour_image.timer <= 0 then
    self.pour_image.timer = self.pour_image.duration
    self.pour_image.frame = self.pour_image.frame + 1
    if self.pour_image.frame > self.pour_image.frames then self.pour_image.frame = 1 end
  end
  -- Mouse
  self.mouse_image.pour.timer = self.mouse_image.pour.timer - dt
  if self.mouse_image.pour.timer <= 0 then
    self.mouse_image.pour.timer = self.mouse_image.pour.duration
    self.mouse_image.pour.frame = self.mouse_image.pour.frame + 1
    if self.mouse_image.pour.frame > self.mouse_image.pour.frames then self.mouse_image.pour.frame = 1 end
  end

  -- Send
  self.send_image.timer = self.send_image.timer - dt
  if self.send_image.timer <= 0 then
    self.send_image.timer = self.send_image.duration
    self.send_image.frame = self.send_image.frame + 1
    if self.send_image.frame > self.send_image.frames then self.send_image.frame = 1 end
  end
  -- Mouse
  self.mouse_image.send.timer = self.mouse_image.send.timer - dt
  if self.mouse_image.send.timer <= 0 then
    self.mouse_image.send.timer = self.mouse_image.send.duration
    self.mouse_image.send.frame = self.mouse_image.send.frame + 1
    if self.mouse_image.send.frame > self.mouse_image.send.frames then self.mouse_image.send.frame = 1 end
  end
end


function Tutorial:draw()
  love.graphics.setColor(gameWorld.colors.white)
  love.graphics.clear(1.0, 1.0, 1.0, 1.0)
  love.graphics.draw(gameWorld.assets.backdrops.title_background, 0, 0)

  self.backsnow:draw()

  love.graphics.setColor(gameWorld.colors.white)
  self.snow:draw()
  ----- Animations
  love.graphics.draw(self.pour_image.image[self.pour_image.frame], self.pour_image.x, self.pour_image.y)
  love.graphics.draw(self.mouse_image.pour.image[self.mouse_image.pour.frame], self.mouse_image.pour.x, self.mouse_image.pour.y)
  love.graphics.draw(self.send_image.image[self.send_image.frame], self.send_image.x, self.send_image.y)
  love.graphics.draw(self.mouse_image.send.image[self.mouse_image.send.frame], self.mouse_image.send.x, self.mouse_image.send.y)
  ----- Text
  love.graphics.setColor(gameWorld.colors.credits_title)
  love.graphics.setFont(self.titlefont)
  love.graphics.print("TUTORIAL", 575, 25)
  love.graphics.setFont(self.textfont)
  love.graphics.setColor(gameWorld.colors.menu_text)
  love.graphics.print("Pour - RMB / C / Gamepad B", 80, 100)
  love.graphics.print("Pour a drink from \nthe tap by pressing \nRMB. Each tap fills \nthe tankard with a \ndifferent drink.", 420, 150)
  love.graphics.print("Send - LMB / Z / Gamepad A", 840, 100)
  love.graphics.print("Send out a drink to\nthe patrons at the \nbar by pressing LMB. \nMake sure the drink \nyou send matches\ntheir order!", 680, 350)
  love.graphics.setColor(gameWorld.colors.white)
  -----
  if self.fade > 0 then
    love.graphics.setColor(0.0, 0.0, 0.0, self.fade) --(0.0, 0.0, 0.0, self.fade)
    love.graphics.rectangle('fill', 0, 0, 1280, 720)
  end
end

return Tutorial
