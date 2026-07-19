local Manager = {
    _freeIds = {},
    _nextId = 0
}
Manager.__index = Manager

-- Gets a new unique ID. Reuses IDs from the free pool if available.
function Manager:get()
    if #self._freeIds > 0 then
        return table.remove(self._freeIds)
    end

    local id = self._nextId
    self._nextId = self._nextId + 1

    return id
end

-- Releases an ID back into the free pool for reuse.
function Manager:release(id)
    table.insert(self._freeIds, id)
end

local Module = {}

-- Creates and returns a new Manager instance.
function Module:createManager()
    local manager = setmetatable({
        _freeIds = {},
        _nextId = 0
    }, Manager)

    return manager
end

return Module