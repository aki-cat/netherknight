
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
  local x, y = (self.pos - self.size/2):unpack()
  fonts:set(1)
  love.graphics.push()

  love.graphics.scale(1/globals.unit)
  color:setRGBA(255, 255, 255, 200)

  love.graphics.printf(
    tostring(self.ammount) .. ' gp',
    globals.unit * (x-.9), globals.unit * (y + 1/3),
    globals.unit * 2,
    'center'
  )

  color:reset()

  love.graphics.pop()
end

return money
