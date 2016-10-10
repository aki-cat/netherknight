
local attack = require 'element' :new {
  0, 2, 6, 1, 0.3,
  __type = 'attack'
}

function attack:__init ()
  self.base_attack = self[1]
  self.dices = self[2]
  self.sides = self[3]
  self.target = self[4]
  self.timer = timer:new { globals.framerate }
end

function attack:start ()
  self.done = false
  self.timer:after(self[5], function ()
    self.done = true
  end)
end

function attack:get_attack ()
  local dice = require 'basic.dice'
  return self.base_attack + dice.throw(self.dices, self.sides)
end

function attack:is_done ()
  return self.done
end

function attack:is_harmful_to (harm_lvl)
  return harm_lvl == self.target
end

function attack:update ()
  self.timer:update()
end

return attack
