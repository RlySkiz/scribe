


Ext.Events.KeyInput:Subscribe(function (e)
    if e.Event == "KeyDown" and e.Repeat == false then

        if e.Key == "NUM_3" then
            _P("Pressed 3")
            InitializeTree(mouseoverTab)
            
            --InitializeTree(entityTab)
            --InitializeTree(visualTab)
        end

        if e.Key == "NUM_4" then
            _D(Ext.UI.GetPickingHelper(1))
        end

        if e.Key == "NUM_1" then
            --_P("Num_1 pressed")
            --_D(Ext.UI.GetPickingHelper(1))
            CreateComponentTree(mouseoverDumpTree, getMouseover())                                          -- doesnt work

            if getEntityUUID() ~= nil then
                local dumpAll = Ext.Entity.Get(getEntityUUID()):GetAllComponents()

                if getMouseover().Inner.Inner[1].Character ~= null then

                -- Ext.DumpExport(Ext.Entity.Get(getEntityUUID()
                entityName.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()).CustomName.Name)
                entityRace.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()).Race.Race)
                entityBodyType.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()).BodyType.BodyType)
                
                -- Get CharacterVisual Dump
                Ext.Net.PostMessageToServer("RequestCharacterVisual", getEntityUUID())
                CreateComponentTree(entityDumpTree, dumpAll)                                                -- works
                entityDumpInfo.Label = Ext.DumpExport(dumpAll)
                _D(entityDumpTree)
                -- entityDumpTree.Selected = true
                else
                dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()):GetAllComponents())
                end
            end
        end    

        -- Saves dump files to ScriptExtender folder
        if e.Key == "NUM_2" then
        --_P("Num_2 pressed")
            Ext.IO.SaveFile("mouseoverDump.json", Ext.DumpExport(getMouseover()))
            Ext.IO.SaveFile("entityDump.json", Ext.DumpExport(Ext.Entity.Get(getEntityUUID()):GetAllComponents()))
        end
    end
end)

Ext.Events.NetMessage:Subscribe(function(e) 
    if (e.Channel == "SendCharacterVisualDump") then
        local dump = Ext.Json.Parse(e.Payload)
        entityCVID.Label = Ext.Json.Stringify(dump) -- Updates Visualresource UUID on entity tab
        CreateComponentTree(visualDumpTree, Ext.Resource.Get(dump, "CharacterVisual"))                      -- doesnt work
    end
end)

