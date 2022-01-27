require 'vec2'

Body = setmetatable({}, {
  __call = function(class, ...)
    return class.new(...)
  end,
})

function Body.new(position, velocity, mass, radius, acceleration)
  local self = setmetatable({}, Body)
  self.position = Vec2.new(position[1], position[2]) or Vec2.new()
  self.velocity = Vec2.new(velocity[1], velocity[2]) or Vec2.new()
  self.mass = mass or 1
  self.radius = radius or 1
  self.acceleration = Vec2.new(acceleration[1], acceleration[2]) or Vec2.new()
  return self
end
