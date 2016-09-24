
local money = require 'collectable' :new {
  [3] = 1/8,
  [4] = 1/4,
  ammount = 10,
  item = 'money',
  __type = 'money'
}

function money:on_death ()
  print('Got ', self.ammount, 'gp!')
  hump.signal.emit('get_money', self.ammount)
  hump.signal.emit('entity_death', self)
end

return money
