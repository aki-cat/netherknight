
local controller = basic.prototype:new {
  actions = {},
  __type = 'controller'
}

function controller:connect()
  for _,action in pairs(self.actions) do
    print(_,action)
    hump.signal.register(action.signal, action.func)
  end
end

function controller:disconnect()
  for _,action in pairs(self.actions) do
    hump.signal.remove(action.signal, action.func)
  end
end

return controller
