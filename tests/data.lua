local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rodux: Rodux = require(ReplicatedStorage.Packages.Rodux)

local nameReducer = Rodux.createReducer("Noname", {
    setName = function(_state, action)
        print("Dispatched setName")
        return action.name
    end
})

local breedReducer = Rodux.createReducer("Unknown Breed", {
    setBreed = function(_state, action)
        print("Dispatched setBreed")
        return action.breed
    end
})

local catReducer = Rodux.combineReducers({
    name = nameReducer,
    breed = breedReducer
})

local function createStore(): Rodux.Store
    return Rodux.Store.new(catReducer)
end

local actions = {
    setBreed = function(breed)
        return {
            type = "setBreed",
            breed = breed
        }
    end,
    setName = function(name)
        return {
            type = "setName",
            name = name
        }
    end
}

return {
    createStore = createStore,
    actions = actions
}