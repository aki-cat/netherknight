
local queue = require 'basic.prototype' :new {
  256, -- basic size
  true,
  __type = 'queue'
}

function queue:__init ()

  -- queue attributes (intern use only, please, unless you REALLY know what you're doing)
  self.queue = {}
  self.head = 1
  self.tail = 0

  -- allocating all of the queue in the same space for performance
  for i = 1, self[1] do self.queue[i] = false end

end

function queue:enqueue (item)
  self.tail = self.tail % self[1] + 1
  if self[2] then
    assert(self.tail ~= self.head, "Queue overflow. Use a larger sized queue (currently is " .. tostring(self[1]) .. ").")
  end
  self.queue[self.tail] = item
end

function queue:dequeue ()
  local item = self.queue[self.head]
  self.queue[self.head] = false
  self.head = self.head % self[1] + 1
  return item
end

function queue:__index (k)
  if k == 'size'     then return self[1] end
  if k == 'overflow' then return self[2] end
  return getmetatable(self)[k]
end

return queue
