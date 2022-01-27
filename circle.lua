require 'body'

Circle = setmetatable({}, {
  __call = function(class, ...)
    return class.new(...)
  end,
})

function Circle.new(color, mode, body)
  local self = setmetatable({}, Circle)
  self.color = color or { 0, 0, 0 }
  self.mode = mode or 'fill'
  self.body = body or Body:new()
  return self
end
