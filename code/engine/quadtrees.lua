--// HELPERS \\--
local table = require("code.engine.helpers.table")
local math = require("code.engine.helpers.math")

--[[
What is a "point"?

i think its like uhhh... idk man..
a point is like a point in like a space
and the point like points to a certain point
if you get what im saying
]]

local Quadtree = {
    width = 100,
    height = 100,

    x = 0,
    y = 0,

    capacity = 4,
    parent = nil,

    subdivided = false,

    children = {},
    points = {}
}
Quadtree.__index = Quadtree

local Module = {}

-- Check if two points are the same
local function pointsEqual(a, b)
    return a.x == b.x and a.y == b.y
end

-- Calculates distance between two points
local function getDistanceXY(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y

    return dx, dy
end

local function isDistanceInRadius(dx, dy, radius)
    return dx * dx + dy * dy <= radius * radius
end

-- Check if a point is inside a radius
local function isPointInRadius(point, center, radius)
    local dx, dy = getDistanceXY(point, center)
    return isDistanceInRadius(dx, dy, radius)
end

-- Check if a range has a point inside
local function contains(range, point)
    return point.x >= range.x
        and point.x <= range.x + range.width
        and point.y >= range.y
        and point.y <= range.y + range.height
end

--[[
Checks for all points inside a radius

center = {x, y}
radius = num
]]

function Quadtree:queryRadius(center, radius)
    local found = {}

    if not self:isInRadius(center, radius) then return found end

    for _, point in ipairs(self.points) do
        if not isPointInRadius(point, center, radius) then goto continue end
        table.insert(found, point)

        :: continue ::
    end

    if self.subdivided then

        for _, child in ipairs(self.children) do

            local results = child:queryRadius(center, radius)
            for _, point in ipairs(results) do
                table.insert(found, point)
            end

        end

    end

    return found
end

--[[
Checks for all points inside an arbitrary rectangle

rect = {
    height = num,
    width = num,

    x = num,
    y = num,
}
]]

function Quadtree:queryRect(rect)
    local found = {}

    if not self:isInRect(rect) then return found end

    for _, point in ipairs(self.points) do
        if not contains(rect, point) then goto continue end
        table.insert(found, point)

        :: continue ::
    end

    if self.subdivided then

        for _, child in ipairs(self.children) do

            local results = child:queryRect(rect)
            for _, point in ipairs(results) do
                table.insert(found, point)
            end

        end

    end

    return found
end

-- A wrapper for contains(quadtree, point)
function Quadtree:contains(point)
    return contains(self, point)
end

-- Check if the quadtree node intersects a circle with a given center and radius
function Quadtree:isInRadius(center, radius)
    local closestX = math.max(self.x, math.min(center.x, self.x + self.width))
    local closestY = math.max(self.y, math.min(center.y, self.y + self.height))

    local dx, dy = getDistanceXY({
        x = closestX,
        y = closestY
    }, center)

    return isDistanceInRadius(dx, dy, radius)
end

-- Check if the quadtree intersects a range
function Quadtree:isInRect(range)
    return not (self.x + self.width < range.x or self.x > range.x + range.width
           or self.y + self.height < range.y or self.y > range.y + range.height)
end

-- Inserts new point into the quadtree
function Quadtree:insert(point)
    local contains = self:contains(point)
    if not contains then return false end

    if not self.subdivided and #self.points < self.capacity then
        table.insert(self.points, point)
        return true
    end

    if not self.subdivided then
        self:subdivide()
    end

    for _, child in ipairs(self.children) do
        if child:insert(point) then
            return true
        end
    end

    return false
end

-- Subdivide the quadtree
function Quadtree:subdivide()
    local halfX = self.width / 2
    local halfY = self.height / 2

    local offsets = {
        {0, 0},
        {halfX, 0},
        {0, halfY},
        {halfX, halfY}
    }

    for _, offset in ipairs(offsets) do
        local child = Module:createQuadtree({
            width = halfX,
            height = halfY,

            x = self.x + offset[1],
            y = self.y + offset[2],

            capacity = self.capacity,
            parent = self
        })

        table.insert(self.children, child)
    end

    -- Redistribute points between new children
    for _, point in ipairs(self.points) do

        for _, child in ipairs(self.children) do

            if child:insert(point) then
                break
            end

        end

    end

    self.subdivided = true
    self.points = {}
end

-- Merges the quadtree's empty children
function Quadtree:mergeEmpty()
    if not self.subdivided then return end

    local allEmpty = true

    for _, child in ipairs(self.children) do

        if #child.points > 0 or child.subdivided then
            allEmpty = false
            break
        end

    end

    if allEmpty then
        self.subdivided = false
        self.children = {}
    end
end

-- Removes a point from the quadtree and merges empty children automatically
function Quadtree:remove(point)
    for index, value in ipairs(self.points) do

        if pointsEqual(value, point) then
            table.remove(self.points, index)
            return true
        end

    end

    for _, child in ipairs(self.children) do

        local success = child:remove(point)
        if success then
            self:mergeEmpty()
            return true
        end

    end

    return false
end

-- Updates a point's position
function Quadtree:update(old, new)
    local success = self:remove(old)
    if success then
        self:insert(new)
        return true
    end

    return false
end

-- Returns the quadtree and its children's points
function Quadtree:getAllPoints()
    local found = table.shallowClone(self.points)

    for _, child in ipairs(self.children) do

        local childPoints = child:getAllPoints()
        for _, point in ipairs(childPoints) do
            table.insert(found, point)
        end

    end

    return found
end

-- Create a quadtree
function Module:createQuadtree(data)
    local quadtree = setmetatable({
        width = data.width or 100,
        height = data.height or 100,

        x = data.x or 0,
        y =  data.y or 0,

        capacity = data.capacity or 4,
        parent = data.parent or nil,

        subdivided = false,

        children = {},
        points = {}
    }, Quadtree)

    for _, point in ipairs(data.points or {}) do
        quadtree:insert(point)
    end

    return quadtree
end

return Module