
local sfx = require 'model' :new {}

function sfx:__init ()
  self.SE = {
    Die = { unique_id:generate() },
    Get = { unique_id:generate() },
    Grow = { unique_id:generate() },
    Heal = { unique_id:generate() },
    Hit = { unique_id:generate() },
    Hurt = { unique_id:generate() },
    Hurt2 = { unique_id:generate() },
    Ok = { unique_id:generate() },
    Slash = { unique_id:generate() },
    Coin = { unique_id:generate(), 60 },
  }
  for name, info in pairs(self.SE) do
    local buffer = info[2] or nil
    local se = require 'elements.sfx' :new { name .. '.wav', poolsize = buffer }
    se:set_id(info[1])
    self:add_element(se)
  end
end

function sfx:get_SFX_id (name)
  return self.SE[name] and self.SE[name][1]
end

function sfx:play (name)
  print("Playing SFX: ".. name)
  local sfx = self:get_element(self:get_SFX_id(name))
  if sfx then sfx:play() end
end

return sfx:new {}
