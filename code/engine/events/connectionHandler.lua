local Connection = {}
Connection.__index = Connection

local Module = {}

function Module.new(signal, callback)
	return setmetatable({
		_callback = callback,
		_signal = signal,

		Connected = true
	}, Connection)
end

function Connection:Disconnect()
	if not self.Connected then
		return
	end

	self.Connected = false

	self._signal:_RemoveConnection(self)
end

return Module