# fusionrodux-2
Implementation of a rodux binding for Fusion 0.2.x

## Installation
| Method           | Source             |
|------------------| -------------      |
| Wally            | ``FusionRodux = "vflour/fusionrodux-2@0.1.0"``  |
| Binary `(.rbxm)` | [Latest release](https://github.com/vflour/fusion-rodux-2/releases/tag/0.1.0) |

## Contributing
Contributions are welcome! Feel free to open and issue and/or submit a pull request :-)

## Usage
This package is intended to be used with Wally and Rojo! Make sure to run ``wally install`` before serving or building with Rojo.

### Requiring
First (and most importantly), you need to actually require it! Make sure it's parented to a folder where Fusion and Rodux sits (this is mainly because this package is intended to be paired with Wally). 

```
local Packages = game.ReplicatedStorage.Packages
local Fusion = require(Packages.Fusion) -- sample Fusion require
local FusionRodux = require(Packages.FusionRodux)
```

### Using with components
Now you're ready to use FusionRodux! It's supposed to work like any other dependency in Fusion, so all you really need to do is call it so that it'll bind to the store you pass it to.

The first argument is the store you'll be connecting to. The second argument is the processor function that updates which value inside of the store you want to be tracking.

The first value that it returns is a Value that contains the returned value of the processor you just passed to it. It's kind of like a Computed, but without any dependencies.

( We'll get to the second returned value in the next section )

_Do note that this means that the processor will not be executed if a dependency inside of the processor body is updated._

```
local Packages = game.ReplicatedStorage.Packages
local Fusion = require(Packages.Fusion) -- sample Fusion require
local FusionRodux = require(Packages.FusionRodux)
local store = require(script.Parent.store)

local New = Fusion.New

function PersonNameTag(props)
    local name = FusionRodux(store, function(newState)
        return newState.name
    end)
    
    return New "TextLabel" {
        Name = "NameTag",
        Size = UDim2.fromOffset(100, 100),
        Text = name
    }
end
```

### Cleaning up
Since FusionRodux connects to the state, you need to explicitly tell it when to clean up that connection. 

...which is where second return value comes to the rescue! 

Feel free to pair it with the Cleanup SpecialKey in Fusion

```
local Packages = game.ReplicatedStorage.Packages
local Fusion = require(Packages.Fusion) -- sample Fusion require
local FusionRodux = require(Packages.FusionRodux)
local store = require(script.Parent.store)

local New = Fusion.New

function PersonNameTag(props)
    local name, disconnect = FusionRodux(store, function(newState)
        return newState.name
    end)
    return New "TextLabel" {
        Name = "NameTag",
        Size = UDim2.fromOffset(100, 100),
        Text = name,

        [Cleanup] = function()
            disconnect()
        end
    }
end
```

### Test Example
You can also open up the test story (make sure to have [Hoarcekat installed as a plugin](https://github.com/Kampfkarren/hoarcekat)) to see how it works by serving ``test.project.json`` via Rojo. 

The test story is stored under ``/tests/test.story.lua`` if you want take a look at how it works. It depends on the ``/tests/data.lua`` file to manage the stores and actions.

