
local model = require 'basic.prototype' :new {
  __type = 'model'
}

local find = require 'basic.pool' .find
local remove = require 'basic.pool' .remove
local add = require 'basic.pool' .add

function model:__init ()
  self.pool = {}
  self.timer = timer:new {}
end

function model:get_pool ()
  return self.pool
end

function model:add_element (e)
  local pool = self:get_pool()
  add(pool, e)
end

function model:remove_element (id)
  local pool = self:get_pool()
  for k,e in pairs(pool) do
    if e:get_id() == id then
      remove(pool, k)
      return
    end
  end
end

function model:get_element (id)
  local pool = self:get_pool()
  for k,e in pairs(pool) do
    if e:get_id() == id then
      return e
    end
  end
end

function model:clear_pool ()
  local pool = self:get_pool()
  for k in pairs(pool) do
    pool[k] = nil
  end
end

function model:update ()
  -- implement on child
end

function model:draw ()
  -- implement on child
end

return model
