DoCirclesOverlap = function(body1, body2)
  return math.abs(
    (body1.position.x - body2.position.x) * (body1.position.x - body2.position.x)
      + (body1.position.y - body2.position.y) * (body1.position.y - body2.position.y)
  ) <= (body1.radius + body2.radius) * (body1.radius + body2.radius)
end

IsPointInCircle = function(body, px, py)
  -- @param body: using body.position.x and body.position.y and radius
  -- difference between point and body squared is less or equal than radius squared
  -- (x1 - x2)^2 + (y1 - y2)^2 <= r^2
  return math.abs(
    (body.position.x - px) * (body.position.x - px)
      + (body.position.y - py) * (body.position.y - py)
  ) <= body.radius * body.radius
end

DisplaceBodies = function(body1, body2)
  local distance = math.sqrt(
    (body1.position.x - body2.position.x) * (body1.position.x - body2.position.x)
      + (body1.position.y - body2.position.y) * (body1.position.y - body2.position.y)
  )
  local overlap = (distance - body1.radius - body2.radius)

  body1.position.x = body1.position.x - overlap * (body1.position.x - body2.position.x) / distance
  body1.position.y = body1.position.y - overlap * (body1.position.y - body2.position.y) / distance

  body2.position.x = body2.position.x + overlap * (body1.position.x - body2.position.x) / distance
  body2.position.y = body2.position.y + overlap * (body1.position.y - body2.position.y) / distance
end
