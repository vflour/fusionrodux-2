--!strict
local Packages = script.Parent
local Fusion = require(Packages.Fusion)
local Rodux = require(Packages.Rodux)

local Value = Fusion.Value

type State = {[string]: any}
type StoreProcessor<T> = (State, State) -> T

local function FusionRedux<T>(store: Rodux.Store, processor: (state, state) -> T)
    local value: Fusion.Value<T> = Value(processor(store:getState()))

    -- Track connection
    local connection = store.changed:connect(function(newState, oldState) 
        local result = processor(newState, oldState)
        value:set(result)
    end)

    -- Easy disconnect
    local disconnect = function()
        connection:disconnect()
    end

    -- sketchy but it disables external setting
    local valueMetatable = {
        __index = function(_, i)
            -- disable set access
            if i == "set" then
                return nil
            end
            return value[i]
        end,
    }
    local meta = setmetatable({
        type = "State",
		kind = "FusionRedux",
    }, valueMetatable)
    
    return meta, disconnect
end

return FusionRedux