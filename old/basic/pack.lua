
local package_mt = {}

function package_mt:__index(module)
  local file = require (self[package_mt] .. '.' .. module)
  if file then
    self[module] = file
    return self[module]
  end
end

return function (path)
  local package = {}
  package[package_mt] = path
  setmetatable(package, package_mt)
  return package
end
