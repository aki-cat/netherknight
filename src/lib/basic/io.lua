
local basic_io = {}

function basic_io.serialise_table (t)
  --[[
  Receives table, returns string with the same table.
  THIS IS A RECURSIVE FUNCTION. So if the table indexes itself,
  it will cause an infinite loop. ]]
  local function write_table(t)
    local s = "{"
    for key, value in pairs(t) do
      if type(key) == 'number' then
        s = s .. "[" .. tostring(key) .. "]="
      elseif type(key) == 'table' then
        s = s .. "[" .. write_table(key) .. "]="
      elseif type(key) == 'function' then
        s = s .. "[function()end]="
      else
        s = s .. tostring(key) .. "="
      end
      if type(value) == 'table' then
        s = s .. write_table(value)
      elseif type(value) ~= 'string' then
        s = s .. tostring(value)
      else
        s = s .. '\"' .. value .. '\"'
      end
      s = s .. ","
    end
    s = s .. "}"
    return s
  end
  return "return " .. write_table(t)
end

function basic_io.write (filepath, str)
  local file = io.open(filepath, 'w')
  assert(file, "Could not open file to write\n" .."path: " .. filepath)
  print(filepath)
  file:write(str)
  file:close()
end

return basic_io
