Vec2 = setmetatable ( { }, { __call = function ( class, ... ) return class.new ( ... ) end } )

function Vec2.new(x, y)
  local self = setmetatable({}, Vec2)
  self.x = x or 0
  self.y = y or 0
  return self
end
