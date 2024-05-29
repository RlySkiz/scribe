--------------------------------------------------------------------------------------
--
--
--                                    Tabs
--
--
---------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------
--                                    Constructor
------------------------------------------------------------------------------------------------


Tab = {}
Tab.__index = Tab


function Tab:new()
    local instance = setmetatable({}, Tab)
    return instance
end


--------------------------------------------------------------------------------------------
--                                     Variables
--------------------------------------------------------------------------------------------

--  {tab = tab, table = table}
local allTabs = {}

--------------------------------------------------------------------------------------------
--                                     Getters and Setters
---------------------------------------------------------------------------------------------

function Tab:getAllTabs()
    return allTabs
end



-- TODO: ask Skiz if this is how to get to the label
--@param label string
function Tab:getTab(label)
    for i,entry in pairs(allTabs) do
        if entry.tab.Label == label then
            return entry.tab
        end
    end
end

-- TODO: ask Skiz if this is how to get to the label
--@param label string
function Tab:getTable(label)
    for i,entry in pairs(allTabs) do
        if entry.tab.Label == label then
            return entry.table
        end
    end
end

function Tab:setTab(tab)
    table.insert(allTabs, tab)
end


--------------------------------------------------------------------------------------------
--                                     Methods
---------------------------------------------------------------------------------------------

-- initialize a tab according to Skiz' preferences and add it to "allTabs"
function Tab:initializeTab(label, tabbar)

    thisTab = tabbar:AddTabItem(label)

    thisTab:AddText(label .." UUID: ")

    -- TODO - make more elegant
    if label == "Mouseover" then
        thisTab:AddText("Num_2 = mouseover/entity file dump | Num_3 = test stuff")
    else
        uuid = thisTab:AddText("")
        uuid.SameLine = true
    end
    

    thisTab:AddSeparator()

    thisTable = thisTab:AddTable("",2)
    thisTable.ScrollY = true

    table.insert(allTabs, {tab = thisTab, table = thisTable})

end