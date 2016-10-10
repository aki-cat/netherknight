
-- unpack
if unpack and not table.unpack then table.unpack = unpack end

-- pack
if not table.pack then table.pack = function (...) return {...} end end
