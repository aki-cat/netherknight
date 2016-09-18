
local sprites = basic.pack 'database.sprites'

local collectable = physics.dynamic_body:new {
  item = 'drumstick',
  __type = 'collectable'
}

function collectable:__init ()
end

function collectable:on_collision (somebody)
  if somebody:get_type() == 'player' then
    audio:playSFX('Get')
    table.insert(gamedata.inventory, self.item)
    self.damage = 99999
    self:die()
  end
end

function collectable:draw ()
  -- just so it doesn't use its super's method
end

return collectable
