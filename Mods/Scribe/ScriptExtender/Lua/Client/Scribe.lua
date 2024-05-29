--------------------------------------------------------------------------------------
--
--
--                                      Main Class
--                                 Interaction Handling
--
---------------------------------------------------------------------------------------


-- local mouseoverRoot = (Tabbar.Children[1].Children[5].Children[1].Children[1].Children[1]) -- MouseoverTab.MouseoverTable.MouseoverTableRow.Cell.TreeRoot



---------------------------------------------------------------------------------------------------
--                                       Initilization
-------------------------------------------------------------------------------------------------


local tabsLabel = {"Mouseover", "Entity", "Visual", "VisualBank", "Materials", "Textures"} 


W = Ext.IMGUI.NewWindow("Scribe")
Tabbar = W:AddTabBar("")

for _,label in ipairs(tabsLabel) do
    -- TODO - this is alphabetical, we don't want that
    _P("Tab ", label)
    Tab:initializeTab(label, Tabbar)
end



---------------------------------------------------------------------------------------------------
--                                       Listeners
-------------------------------------------------------------------------------------------------


Ext.Events.KeyInput:Subscribe(function (e)
    if e.Event == "KeyDown" and e.Repeat == false then

        -- Saves dump to ScriptExtender directory
        if e.Key == "NUM_2" then
            Ext.IO.SaveFile("mouseoverDump.json", Ext.DumpExport(GetMouseover()))
            Ext.IO.SaveFile("entityDump.json", Ext.DumpExport(Ext.Entity.Get(getUUIDFromUserdata(GetMouseover())):GetAllComponents()))
        end

        -- Displays Dump in IMGUI windows
        if e.Key == "NUM_3" then
            -- GetAndSaveData("Mouseover")

            -- TODO - instead of initializing send over a message to server 
            InitializeScribeTree("Mouseover")
            InitializeScribeTree("Entity")
            InitializeScribeTree("Visual")
            SaveData("VisualBank")
            -- InitializeScribeTree("VisualBank")
            -- InitializeScribeTree("Materials")
            -- InitializeScribeTree("Textures")
        end
    end
end)

