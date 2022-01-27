require 'circle'
require 'vec2'
require 'physics'

math.randomseed(os.time())

local circles = {}
local colPairs = {}

function love.load()
  for i = 1, 30 do
    circles[i] = Circle.new(
      { 1, 1, 1 },
      'line',
      Body.new({
        math.random(love.graphics.getWidth()),
        math.random(love.graphics.getHeight()),
      }, { 0, 0 }, 1, math.random(40, 70), { 0, 0 })
    )
  end
end

function love.draw()
  for i = 1, #circles do
    love.graphics.setColor(circles[i].color[1], circles[i].color[2], circles[i].color[3])
    love.graphics.circle('line', circles[i].body.position.x, circles[i].body.position.y, circles[i].body.radius)
  end
  for i = 1, #colPairs do
    love.graphics.line(
      circles[colPairs[i][1]].body.position.x,
      circles[colPairs[i][1]].body.position.y,
      circles[colPairs[i][2]].body.position.x,
      circles[colPairs[i][2]].body.position.y
    )
  end
end

local selectedCircle = nil
function love.update()
  -- Select circle
  if love.mouse.isDown(1) then
    for i = 1, #circles do
      if IsPointInCircle(circles[i].body, love.mouse.getX(), love.mouse.getY()) and selectedCircle == nil then
        selectedCircle = i
        break
      end
    end
  end

  -- Move selected circle
  if selectedCircle ~= nil then
    circles[selectedCircle].color = { 1, 0, 0 }
    circles[selectedCircle].body.position.x = love.mouse.getX()
    circles[selectedCircle].body.position.y = love.mouse.getY()
  end

  -- Deselect circle
  -- if mouse button is released and selected circle exists
  if not love.mouse.isDown(1) and circles[selectedCircle] then
    circles[selectedCircle].color = { 1, 1, 1 }
    selectedCircle = nil
  end

  colPairs = {}
  -- Check for collisions
  for i = 1, #circles do
    for j = i + 1, #circles do
      if DoCirclesOverlap(circles[i].body, circles[j].body) then
        -- Add to collision pairs
        colPairs[#colPairs + 1] = { i, j }
        -- Displace circles
        DisplaceBodies(circles[i].body, circles[j].body)
      end
    end
  end
end
