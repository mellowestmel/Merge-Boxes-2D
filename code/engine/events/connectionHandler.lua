-- ~/code/engine/events/connectionHandler.lua

local Connection = {}
Connection.__index = Connection

local Module = {}

function Module.new(signal, callback, index)
	return setmetatable({
		_signal = signal,
		_callback = callback,

		_index = index,

		connected = true
	}, Connection)
end

function Connection:Disconnect()
	if not self.connected then return end

	self.connected = false

	local signal = self._signal

	if signal then
		signal:_removeConnection(self)
		self._signal = nil
	end
end

return Module