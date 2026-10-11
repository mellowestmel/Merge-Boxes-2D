-- ~/code/game/ui/helpers/scene.lua

local UISharedFunctions = require("code.game.ui.shared")
local UIObjectHelperModule = require("code.game.ui.helpers.object")

-- Default behaviour every scene inherits.
-- Scenes override Init/Update, and use OnClean for their own cleanup.
local Scene = {}

function Scene:Clean()
    UIObjectHelperModule.CleanScene(self)

    if self.OnClean then
        self:OnClean()
    end

    UISharedFunctions:Clean()
end

function Scene:Update(deltaTime)
    UISharedFunctions:Update(deltaTime)

    if self.OnUpdate then
        self:OnUpdate(deltaTime)
    end
end

local Module = {}

--- Creates a scene table with the shared fields and default Clean/Update.
function Module.new(name)
    return setmetatable({
        name = name,

        _elements = {},
        _objects = {}
    }, { __index = Scene })
end

return Module
