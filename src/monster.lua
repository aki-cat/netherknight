
local monsters = basic.pack 'database.monsters'

local monster = module.entity:new {
  species = 'slime',
  __type = 'monster'
}

function monster:__init ()
  self.size = monsters[self.species].size
  self.maxhp = monsters[self.species].maxhp or self.maxhp
  self.attack = monsters[self.species].attack
  self.think = monsters[self.species].update
end

function monster:on_death ()
  hump.signal.emit('entity_dying', self)
  audio:playSFX('Die')
  self.timer:after(0.4, function()
    local strength = (self.maxhp + self.attack) * gamedata.level
    local drop = require 'money' :new { self.pos.x, self.pos.y, ammount = love.math.random(math.floor(0.5*strength), math.floor(1.5*strength)) }
    drop:drop()
    hump.signal.emit('entity_death', self)
  end)
end

function monster:on_collision (somebody, h, v)
  if somebody:get_type() == 'attack' then
    self:take_damage(somebody.attack, somebody.pos)
  elseif somebody:get_type() == 'player' then
    somebody:take_damage(self.attack, self.pos)
  elseif somebody:get_type() == 'collision_body' then
    self:stop(h, v)
  end
end

function monster:update (args)
  if self.think and type(self.think) == 'function' then self:think() end
  hump.signal.emit('entity_turn', self, self.dir)
  module.entity.update(self)
end

function monster:draw ()
  module.entity.draw(self) -- call entity draw
end

return monster
