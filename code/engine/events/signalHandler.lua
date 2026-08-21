-- ~/code/engine/events/signalHandler.lua

local ConnectionHandlerModule = require("code.engine.events.connectionHandler")

local Signal = {}
Signal.__index = Signal

local Module = {
	_signals = {}
}

local function _typecheck(value, expected, name)
	local actual = type(value)

	assert(
		actual == expected,
		name .. " expected to be a " .. expected .. ", got " .. actual
	)
end

-- Creates and registers a signal, returning an existing one with the same name.
function Module.new(name)
	_typecheck(name, "string", "Signal name")

	local existing = Module._signals[name]

	if existing then
		return existing
	end

	local signal = setmetatable({
		_connections = {},
		_removed = false,
		_name = name
	}, Signal)

	Module._signals[name] = signal

	return signal
end

-- Returns a registered signal or creates it if it doesn't exist.
function Module.Get(name)
	_typecheck(name, "string", "Signal name")

	local signal = Module._signals[name]

	if signal then
		return signal
	end

	return Module.new(name)
end

-- Adds a callback and stores its index for O(1) removal.
function Signal:Connect(callback)
	assert(not self._removed, "Signal is removed")
	_typecheck(callback, "function", "Callback")

	local connections = self._connections
	local index = #connections + 1

	local connection = ConnectionHandlerModule.new(
		self,
		callback,
		index
	)

	connections[index] = connection

	return connection
end

-- Removes a connection by swapping it with the last entry.
function Signal:_removeConnection(connection)
	local connections = self._connections
	local index = connection._index
	local count = #connections

	if index ~= count then
		local last = connections[count]

		connections[index] = last
		last._index = index
	end

	connections[count] = nil
	connection._index = 0
end

-- Calls every connected callback currently in the signal.
function Signal:Fire(...)
	if self._removed then return end

	local connections = self._connections
	local count = #connections

	for index = 1, count do
		local connection = connections[index]

		if connection.connected then
			connection._callback(...)
		end
	end
end

-- Invalidates all connections and unregisters the signal.
function Signal:Remove()
	if self._removed then return end
	self._removed = true

	local connections = self._connections
	local count = #connections

	for index = 1, count do
		local connection = connections[index]

		connection.connected = false
		connection._signal = nil
		connection._index = 0
	end

	for index = 1, count do
		connections[index] = nil
	end

	self._connections = nil

	Module._signals[self._name] = nil
end

return Module