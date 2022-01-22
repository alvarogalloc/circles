require 'circle'
require 'vec2'

math.randomseed(os.time())

local circleVec = {}
local vecCollidingPairs = {}

function love.load()
  for i = 1, 10 do
    circleVec[i] = Circle.new(
      math.random(40, 70),
      { 0, 0, 1 },
      'line',
      Body.new({
        math.random(love.graphics.getWidth()),
        math.random(love.graphics.getHeight()),
      }, { 0, 0 }, 1, { 0, 0 })
    )
  end
end

function love.draw()
  for i = 1, #circleVec do
    love.graphics.setColor(circleVec[i].color[1], circleVec[i].color[2], circleVec[i].color[3])
    love.graphics.circle('line', circleVec[i].body.position.x, circleVec[i].body.position.y, circleVec[i].radius)
  end
  for i = 1, #vecCollidingPairs do
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.line(
      circleVec[vecCollidingPairs[i][1]].body.position.x,
      circleVec[vecCollidingPairs[i][1]].body.position.y,
      circleVec[vecCollidingPairs[i][2]].body.position.x,
      circleVec[vecCollidingPairs[i][2]].body.position.y
    )
  end
end

local function IsPointInCircle(x1, y1, r1, px, py)
  return math.abs((x1 - px) * (x1 - px) + (y1 - py) * (y1 - py)) < (r1 * r1)
end

local function DoCirclesOverlap(x1, y1, r1, x2, y2, r2)
  return math.abs((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)) <= (r1 + r2) * (r1 + r2)
end

local selectedCircle = nil
function love.update()
  if love.mouse.isDown(1) then
    for i = 1, #circleVec do
      if
        IsPointInCircle(
          circleVec[i].body.position.x,
          circleVec[i].body.position.y,
          circleVec[i].radius,
          love.mouse.getX(),
          love.mouse.getY()
        ) and selectedCircle == nil
      then
        selectedCircle = i
        break
      end
    end
  end

  if selectedCircle ~= nil then
    circleVec[selectedCircle].body.position.x = love.mouse.getX()
    circleVec[selectedCircle].body.position.y = love.mouse.getY()
  end

  if not love.mouse.isDown(1) then
    selectedCircle = nil
  end

  vecCollidingPairs = {}
  -- Check for collisions
  for i = 1, #circleVec do
    for j = i + 1, #circleVec do
      if
        DoCirclesOverlap(
          circleVec[i].body.position.x,
          circleVec[i].body.position.y,
          circleVec[i].radius,
          circleVec[j].body.position.x,
          circleVec[j].body.position.y,
          circleVec[j].radius
        )
      then
        vecCollidingPairs[#vecCollidingPairs + 1] = { i, j }
        local distance = math.sqrt(
          (circleVec[i].body.position.x - circleVec[j].body.position.x)
              * (circleVec[i].body.position.x - circleVec[j].body.position.x)
            + (circleVec[i].body.position.y - circleVec[j].body.position.y)
              * (circleVec[i].body.position.y - circleVec[j].body.position.y)
        )
        local overlap = (distance - circleVec[i].radius - circleVec[j].radius)
        circleVec[i].body.position.x = circleVec[i].body.position.x
          - overlap * (circleVec[i].body.position.x - circleVec[j].body.position.x) / distance
        circleVec[i].body.position.y = circleVec[i].body.position.y
          - overlap * (circleVec[i].body.position.y - circleVec[j].body.position.y) / distance

        circleVec[j].body.position.x = circleVec[j].body.position.x
          + overlap * (circleVec[i].body.position.x - circleVec[j].body.position.x) / distance

        circleVec[j].body.position.y = circleVec[j].body.position.y
          + overlap * (circleVec[i].body.position.y - circleVec[j].body.position.y) / distance
      end
    end
  end
end
