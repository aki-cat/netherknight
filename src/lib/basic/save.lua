
local save = {}

function save.write(filepath, str)
  local file = io.open(filepath, 'w')
  file:write(str)
  file:close()
end

function save.read(filepath)
  local file = io.open(filepath, 'r')
  local str = file:read()
  file:close()
  return str
end

return save
