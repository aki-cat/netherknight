
return {
  name      = "knight",
  money     = 0,
  level     = 1,
  exp       = 0,
  killcount = 0,
  damage    = 0,
  blinglvl  = 1,
  inventory = {},
  weapon    = require 'weapon' :new { 2, 2, 8, name = 'sord' },
  map       = { { id = 0, enemies = {}, items = {} } },
}
