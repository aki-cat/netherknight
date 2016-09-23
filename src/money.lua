
local sprites = basic.pack 'database.sprites'
local entity = require 'entity'

local money = entity:new {
  [3] = 1/8,
  [4] = 1/4,
  ammount = 10,
  __type = 'money'
}

function money:__init ()
  print('size:',self.size:unpack())
  self.maxhp = 1
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

function money:draw ()
  entity.draw(self) -- call entity draw
end


return money
