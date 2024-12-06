-- This is to manage all peripherals used by the system. Tracking when they are connected and disconnected to manage inventories properly, as well as additional turtles, drop off locations, and furnaces

-- periNames holds the names of all peripherals with key=name and value=type
-- peris holds the tables for unclass, storage, dump, furnace, stock which hold the peripherals mapped by key=name to {wPer = wrappedPeripheral settings = settings}
--- types currently are: unclass, storage, dump, furnace, stock, displays
--- 
-- vars
local peris = { names = {} }

AcceptedTypes = {"names", "storage", "dump", "furnace", "stock", "display", "unclass" }
-- names = { type }
-- storage = {}
-- dump = {}
-- furnace = {}
-- stock = {}
-- display = {}

-- functions
local function has_peripheral(name) 
    if peris["names"][name] ~= nil then
        return true
    else
        return false
    end
end

-- no checking on the type variable so don't mess up there, probably worth defining in a config file so they can be added easily
local function add_name(name, type)
    type = type or "unclass"
    peris["names"][name] = type
end
local function remove_name(name)
    peris["names"][name] = nil
end
local function get_type(name)
    return peris["names"][name]
end
function add_peripheral(name, type, settings)
    settings = settings or {}
    add_name(name, type)
    peris[type][name] = {wPer=peripheral.wrap(name), settings=settings}
end
function remove_peripheral(name)
    local peri_type = get_type(name)
    if peri_type ~= nil then
        peris[peri_type][name] = nil
        remove_name(name)
    end

end
function GetAllType(type)
    return peris[type]
end

local function findPeripherals()
    local peripheralNames = peripheral.getNames()
    for i=1, #peripheralNames do
        local cur = peripheralNames[i]
        if cur ~= "top" and cur ~= "front" and cur ~= "bottom" and cur ~= "back" and cur ~= "left" and cur ~= "right" then
            if has_peripheral(cur) == false then
                if string.match(cur, "monitor") then
                    add_peripheral(cur, "display")
                else
                    add_peripheral(cur, "unclass")
                end
            end 
        end
    end
end

-- code that runs on start
for i=1, #AcceptedTypes do
    peris[AcceptedTypes[i]] = {}
end

findPeripherals()