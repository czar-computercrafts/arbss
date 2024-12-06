-- starting out we just want a basic gui to interact and assign what peripherals do what
local basalt = require("basalt") -- we need basalt here
os.loadAPI("peripheralManager")

local main = basalt.createFrame():setTheme({FrameBG = colors.lightGray, FrameFG = colors.black}) -- we change the default bg and fg color for frames

local sub = { -- here we create a table where we gonna add some frames
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"), -- obviously the first one should be shown on program start
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
}

local function openSubFrame(tab, id) -- we create a function which switches the frame for us
    if(tab[id]~=nil) then
        for k,v in pairs(tab)do
            v:hide()
        end
        tab[id]:show()
    end
end

local menubar = main:addMenubar():setScrollable() -- we create a menubar in our main frame.
    :setSize("parent.w")
    :onChange(function(self, val)
        openSubFrame(sub, self:getItemIndex()) -- here we open the sub frame based on the table index
    end)
    :addItem("Items")
    :addItem("Peris")
    :addItem("Orders")

-- Now we can change our sub frames, if you want to access a sub frame just use sub[subid], some examples:
local selectedPerTypeListFrame = sub[2]:addFrame()
    :setSize("parent.w * (2/3)", "parent.h")
    :setPosition("parent.w/3+1", 1)

local subPeriTypeFrames = {} --use this to create a frame for each peri type and its values

local periTypeSelectorFrame = sub[2]:addFrame()
    :setSize("parent.w/3-1", "parent.h")
    :setPosition("1,1")

local periTypeSelector = periTypeSelectorFrame:addList()
        :setScrollable(true)
        :setSize("parent.w","parent.h")
        :onSelect(function (self, event, item)
                openSubFrame(subPeriTypeFrames, self:getItemIndex())
        end)
--function that takes a frame to attach to and a calling object "item" (or self?) = parent
local function openPeriAssignDialog(self, event, item)
    local popUpFrame = main:addFrame()
            :setSize("parent.w*(4/5)", "parent.h*(4/5)")
            :setPosition("parent.w/10+1", "parent.h/10+1")

    popUpFrame:addLabel():setText("Assign Peripheral To:")
    local assignmentList = popUpFrame:addList()
            :setPosition(1,2):setSize("parent.w","parent.h-1")
            :onSelect(function (self2, event2, item2)
                peripheralManager.remove_peripheral(item.text)
                peripheralManager.add_peripheral(item.text, item2.text)
                basalt.removeFrame(self:getName())
                popUpFrame:remove()
                for k, _ in pairs(peripheralManager.GetAllType("storage")) do
                    basalt.debug(k) 
                end
            end)
    for i=1, #peripheralManager.AcceptedTypes do
        if peripheralManager.AcceptedTypes[i] ~= "names" then
            -- assignmentList:addItem(peripheralManager.AcceptedTypes[i])
            assignmentList:addItem(peripheralManager.AcceptedTypes[i])
        end
    end
end

for i=1, #peripheralManager.AcceptedTypes do
    if peripheralManager.AcceptedTypes[i] ~= "names" then
        periTypeSelector:addItem(peripheralManager.AcceptedTypes[i]) --load the periTypes for selection

        --load the supporting subPeriTypeFrames
        local subFrame = selectedPerTypeListFrame:addFrame()
                :setPosition(1, 1):setSize("parent.w", "parent.h"):hide()
        local list1 = subFrame:addList():setPosition(1, 1):setSize("parent.w", "parent.h")
                :onSelect(openPeriAssignDialog)
        for key, _ in pairs(peripheralManager.GetAllType(peripheralManager.AcceptedTypes[i])) do
            list1:addItem(key)
        end
        table.insert(subPeriTypeFrames, subFrame) 
    end
end
--setup subscribers to allow data updates in the background when important
local unclass = peripheralManager.GetAllType("unclass")

sub[1]:addLabel():setText("Items will go here!"):setPosition(2, 2)

sub[3]:addLabel():setText("Now we're on example 3!"):setPosition(2, 2)
sub[3]:addButton():setText("No functionality"):setPosition(2, 4):setSize(18, 3)

basalt.autoUpdate()