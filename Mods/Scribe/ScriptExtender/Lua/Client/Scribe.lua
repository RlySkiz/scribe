--------------------------------------------------------------------------------------
--
--
--                                      Main Class
--                                 Interaction Handling
--
---------------------------------------------------------------------------------------


-- local mouseoverRoot = (Tabbar.Children[1].Children[5].Children[1].Children[1].Children[1]) -- MouseoverTab.MouseoverTable.MouseoverTableRow.Cell.TreeRoot


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
            InitializeTree(MouseoverTab)
            -- _D(Tabbar.Children[1].Children[5].Children[1]) -- Mouseover Tablerow
            --populateChildrenOnClick(GetMouseOverRoot())
            -- InitializeTree(EntityTab)
            -- InitializeTree(VisualTab)
        end
    end
end)

