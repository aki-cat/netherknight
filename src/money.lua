
local money = require 'collectable' :new {
  [3] = 1/8,
  [4] = 1/4,
  ammount = 10,
  item = 'money',
  __type = 'money'
}

function money:on_death ()
  gamedata.money = gamedata.money + self.ammount
  print('Got ', self.ammount, 'gp!')
  audio:playSFX('Get')
  hump.signal.emit('entity_death', self)
end

return money
