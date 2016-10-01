
local iterate = {}

-- iterator
function iterate.other(t, index)
  return function(s, var)
    var = next(s, var)
    return var, s[var]
  end, t, index
end

function iterate.matrix(t)
  local init_s = { 1, 0, tbl = t }
  return function(s, var)
    local m = s.tbl

    -- advancing column
    s[2] = s[2] + 1
    i, j = s[1], s[2]
    var = m[i] and m[i][j]

    -- end of column
    if not var then
      -- advancing row, resetting column
      s[1] = s[1] + 1
      s[2] = 1
      i, j = s[1], s[2]
      var = m[i] and m[i][j]
    end

    -- return nil if out of rows; or return i, j, m[i][j]
    return var and i, j, var
  end,
  init_s,
  0
end

return iterate
