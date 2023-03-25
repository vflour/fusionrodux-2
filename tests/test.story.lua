local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local StoreHandler = require(ReplicatedStorage.Packages.FusionRodux)
local data = require(script.Parent.data)

local New = Fusion.New
local Children = Fusion.Children
local Cleanup = Fusion.Cleanup
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local doNothing = Fusion.doNothing

local createStore = data.createStore
local actions = data.actions

---Fusion test component that updates 
---@param props any
---@return any
local function Test(props)
    local store = props.Store

    local value, disconnect = StoreHandler(store, function(newState)
        return newState
    end)

    return New "Frame" {
        Size = UDim2.fromOffset(200, 200),
        [Cleanup] = function()
            print("Cleaning up...")
            disconnect()
        end,
        [Children] = {
            New "TextLabel" {
                Size = UDim2.fromOffset(200, 100),
                Text = "This is my cat.\n They don't seem to have a name or a breed, so feel free to press one of the below buttons to give them one!",
                TextWrapped = true,
            },
            New "TextButton" {
                Size = UDim2.fromOffset(200, 50),
                Position = UDim2.fromOffset(0, 100),
                AutoButtonColor = true,
                Text = Computed(function()
                    return value:get().name
                end, doNothing),
                [OnEvent "Activated"] = function()
                    store:dispatch(actions.setName("Fanta"))
                end
            },
            New "TextButton" {
                Size = UDim2.fromOffset(200, 50),
                Position = UDim2.fromOffset(0, 150),
                AutoButtonColor = true,
                Text = Computed(function()
                    return value:get().breed
                end, doNothing),
                [OnEvent "Activated"] = function()
                    store:dispatch(actions.setBreed("Orange Tabby"))
                end
            }
        }
    }
end

return function(screen)
    local store = createStore()
    local test = Test {
        Store = store
    }
    test.Parent = screen

    return function()
        store:destruct()
        test:Destroy()
    end
end