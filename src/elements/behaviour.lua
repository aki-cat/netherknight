
local behaviour = require 'element' :new {
  'dummy',
  __type = 'behaviour'
}

function behaviour:__init ()
  local database = require 'basic.pack' 'database.behaviours'
  if self[1] ~= 'dummy' then
    local brain = database[self[1]]
    self.behave = coroutine.create(brain)
  end
end

function behaviour:update ()
  if not self.behave then return end
  local id = self:get_id()
  local status, info = coroutine.resume(self.behave, id)
  assert(status, "Coroutine error!\n" .. tostring(info))
end

return behaviour
