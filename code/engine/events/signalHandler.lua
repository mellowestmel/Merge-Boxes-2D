local ConnectionHandlerModule = require("code.engine.events.connectionHandler")

-- Main module for sending and receiving events that happen in the game,
-- such as built-in Love2D events or in-game events.
-- A useful system for modding the game.

local Signal = {}
Signal.__index = Signal

local Module = {}
Module._signals = {}

local function _typecheck(value, expected, name)
	local actual = type(value)

	assert(
		actual == expected,
		name .. " expected to be a " .. expected .. ", got " .. actual
	)
end

-- Create a new signal.
function Module.new(name)
    _typecheck(name, type(name), "Signal name")
	if Module._signals[name] then return Module._signals[name] end

	local signal = setmetatable({
		_connections = {},
		_destroyed = false,
		_name = name
	}, Signal)

	Module._signals[name] = signal

	return signal
end

-- Get an existing signal.
function Module.Get(name)
    _typecheck(name, type(name), "Signal name")
	return Module._signals[name] or Module.new(name)
end

-- Listen for the signal.
function Signal:Connect(callback)
	assert(not self._destroyed, "Signal is destroyed")
    _typecheck(callback, type(callback), "Callback")

	local connection = ConnectionHandlerModule.new(self, callback)
	table.insert(self._connections, connection)

	return connection
end

-- Remove a connection.
-- Better to use connection:Disconnect().
function Signal:_RemoveConnection(connection)
	for index, current in ipairs(self._connections) do
		if current == connection then
			table.remove(self._connections, index)
			return
		end
	end
end

-- Send the signal to all connections.
function Signal:Fire(...)
	if self._destroyed then
		return
	end

	for _, connection in ipairs(self._connections) do
		if connection.Connected then
			connection._callback(...)
		end
	end
end

-- Destroy the signal.
function Signal:Destroy()
	if self._destroyed then
		return
	end

	self._destroyed = true

	for _, connection in ipairs(self._connections) do
		connection.Connected = false
	end

	Module._signals[self._name] = nil
	self._connections = {}
end

return Module