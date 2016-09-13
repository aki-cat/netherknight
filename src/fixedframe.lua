
local fixedframe = {}

local framedelay = 0
local update_list = {}

function fixedframe.register (name, func)
  update_list[name] = func
end

function fixedframe.unregister (name)
  update_list[name] = nil
end

function fixedframe.update (dt)
  framedelay = framedelay + dt
  while framedelay >= globals.frameunit do
    framedelay = framedelay - globals.frameunit
    -- update logic here?
    for _,update in pairs(update_list) do
      if type(update) == 'function' then update() end
    end
  end
end

return fixedframe
