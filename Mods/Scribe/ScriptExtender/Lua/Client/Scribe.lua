--------------------------------------------------------------------------------------
--
--
--                                      Main Class
--                                 Interaction Handling
--
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
--                             Initilization  of  GUI
---------------------------------------------------------------------------------------------------


local tabsLabel = {}

table.insert(tabsLabel, "Mouseover")
table.insert(tabsLabel, "Entity")
table.insert(tabsLabel, "Visual")
table.insert(tabsLabel, "VisualBank")
--table.insert(tabsLabel, "Materials")
--table.insert(tabsLabel, "Textures")


W = Ext.IMGUI.NewWindow("Scribe")
Tabbar = W:AddTabBar("")

for _,label in ipairs(tabsLabel) do
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

            InitializeScribeTree("Mouseover")
            -- TODO - instead of initializing send over a message to server 
            InitializeScribeTree("Entity")
            InitializeScribeTree("Visual") -- no need to send additional message as this is on the entity
             -- TODO - instead of initializing send over a message to server
            SaveData("VisualBank")
            -- InitializeScribeTree("VisualBank")
            -- InitializeScribeTree("Materials")
            -- InitializeScribeTree("Textures")
        end
    end
end)

-- Mouseover has to be populated from client
-- Entity we need additional ServerEntity information so we need to request dump from server
-- Visual is Entity.Visual.Visual
-- VisualBank can be populated from client but needs something from the ServerEntity dump, namely .ServerCharacter.Template.CharacterVisualResourceID
-- ;then generate dump via Ext.Resource.Get(uuid, "CharacterVisual")