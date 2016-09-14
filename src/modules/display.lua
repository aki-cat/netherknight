
local globals = require 'globals'
local class = orangelua.pack 'class'

local view = class.object:new {
  __type = 'view'
}
--[[
function view:update ()
end

function view:draw ()
end
]]
return view
