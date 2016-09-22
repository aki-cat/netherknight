
local sprites = basic.pack 'database.sprites'

local money = require 'entity' :new {
  ammount = 10,
  __type = 'money'
}

function money:__init ()
  self.maxhp = 1
  self.size = 1/4
end

function money:on_collision (somebody)
  if somebody:get_type() == 'player' then
    self.damage = 999
  end
end

function money:on_death ()
  gamedata.money = gamedata.money + self.ammount
  print('Got ', self.ammount, 'gp!')
  audio:playSFX('Get')
  hump.signal.emit('entity_death', self)
end

return money
