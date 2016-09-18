
local sfx = require 'sfx'

local audio = basic.prototype:new {
  __type = 'audio'
}

function audio:__init ()
  self.SE = {
    Die = sfx:new { 'Die.wav' },
    Get = sfx:new { 'Get.wav' },
    Grow = sfx:new { 'Grow.wav' },
    Heal = sfx:new { 'Heal.wav' },
    Hit = sfx:new { 'Hit.wav' },
    Hurt = sfx:new { 'Hurt.wav' },
    Ok = sfx:new { 'Ok.wav' },
    Slash = sfx:new { 'Slash.wav' },
  }
end

function audio:playSFX (name)
  self.SE[name]:play()
end

function audio:silent ()
  love.audio.stop()
end

return audio:new {}
