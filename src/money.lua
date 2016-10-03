
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
    basic.signal:emit('get_money', self.ammount)
  end
end

function money:draw ()
  local x, y = (self.pos * globals.unit):unpack()
  --fonts:set(1)

  color:setRGBA(255, 255, 255, 200)

  love.graphics.printf(
    tostring(self.ammount) .. ' gp',
    x - 32,
    y + 8,
    64,
    'center'
  )

  color:reset()

end

return money
