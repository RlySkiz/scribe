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

--  {tab = tab, table = table, searchInput = searchInput}
local allTabs = {}

--------------------------------------------------------------------------------------------
--                                     Getters and Setters
---------------------------------------------------------------------------------------------

function Tab:getAllTabs()
    return allTabs
end



--@param label string
function Tab:getTab(label)
    for i,entry in pairs(allTabs) do
        if entry.tab.Label == label then
            return entry.tab
        end
    end
end


--@param label string
function Tab:getTable(label)
    for i,entry in pairs(allTabs) do
        if entry.tab.Label == label then
            return entry.table
        end
    end
end



--@param label string
function Tab:getSearchInput(label)
    for i,entry in pairs(allTabs) do
        if entry.tab.Label == label then
            return entry.searchInput
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
--@param label  string
--@param tabbar Tabbar
function Tab:initializeTab(label, tabbar)

    thisTab = tabbar:AddTabItem(label)

    
    
    -- TODO - populate with entity UUID for all tabs except for mouseover
    -- Maybe even as explanation how you'd write it in the console _D(Ext.Resource.Get([:AddInputText and SameLine for the UUID itself to be able to copy it], "CharacterVisual"))
    uuidAndSearchTable = thisTab:AddTable("",2)
    uuidAndSearchRow = uuidAndSearchTable:AddRow()
    uuidAndSearchRow:AddCell():AddText(label .." UUID: ")

    uuid = thisTab:AddText("")
    uuid.SameLine = true

    --searchButton = uuidAndSearchRow:AddCell():AddButton("Search")
    searchCell = uuidAndSearchRow:AddCell()
    searchInfo = searchCell:AddText("Search:")
    searchInput = searchCell:AddInputText("") 
    searchInput.Text = "" 
    searchInput.SameLine = true  
    searchInput.ItemWidth = -1

    -- TODO - make more elegant
    if label == "Mouseover" then
        thisTab:AddText("Num_2 = mouseover/entity file dump | Num_3 = test stuff")
    end



    thisTab:AddSeparator()

    thisTable = thisTab:AddTable("",2)
    thisTable.ScrollY = true

    table.insert(allTabs, {tab = thisTab, table = thisTable, searchInput = searchInput})

end