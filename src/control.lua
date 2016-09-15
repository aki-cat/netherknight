
local control = basic.prototype:new {
  actions = {},
  __type = 'control'
}

function control:connect()
  for _,action in pairs(self.actions) do
    print(_,action)
    hump.signal.register(action.signal, action.func)
  end
end

function control:disconnect()
  for _,action in pairs(self.actions) do
    hump.signal.remove(action.signal, action.func)
  end
end

return control
