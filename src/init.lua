--!strict
local Packages = script.Parent
local Fusion = require(Packages.Fusion)
local Rodux = require(Packages.Rodux)

local Value = Fusion.Value

type State = {[string]: any}
type StoreProcessor<T> = (State, State) -> T

local function StoreHandler<T>(store: Rodux.Store, processor: (state, state) -> T)
    local value: Fusion.Value<T> = Value(processor(store:getState()))

    local connection = store.changed:connect(function(newState, oldState) 
        local result = processor(newState, oldState)
        value:set(result)
    end)

    local disconnect = function()
        connection:disconnect()
    end
    return value, disconnect
end

return StoreHandler