
local money = require 'collectable' :new {
  [3] = 1/8,
  [4] = 1/4,
  ammount = 10,
  item = 'money',
  __type = 'money'
}

function money:on_collision (somebody)
  if somebody:get_type() == 'player' then
    self.damage = 999
    hump.signal.emit('get_money', self.ammount)
  end
end

return money
