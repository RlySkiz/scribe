Ext.Events.KeyInput:Subscribe(function (e)
    if e.Event == "KeyDown" and e.Repeat == false then

        if e.Key == "NUM_1" then
            dumpMouseoverArea.Label = Ext.DumpExport(GetMouseover())

            -- If Entity UUID is found/not equal to null
            if GetEntityUUID() ~= null then
                -- Ext.DumpExport(Ext.Entity.Get(getEntityUUID()) - Read Dumps
                
                -- Get ServerCharacter Info
                Ext.Net.PostMessageToServer("RequestCharacterVisual", GetEntityUUID())
                
                -- Dump all Components of Entity
                dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(GetEntityUUID()):GetAllComponents())
                
                -- Populate QuickInfo Labels
                entityUUIDText.Label = GetEntityUUID()
                entityName.Label = Ext.DumpExport(Ext.Entity.Get(GetEntityUUID()).CustomName.Name)
                entityRace.Label = Ext.DumpExport(Ext.Entity.Get(GetEntityUUID()).Race.Race)
                entityRace.Visible = true
                entityBodyType.Label = Ext.DumpExport(Ext.Entity.Get(GetEntityUUID()).BodyType.BodyType)
                entityBodyType.Visible = true
            end

            -- If Item UUID is found/not equal to null
            if GetItemUUID() ~= null then
                
                -- Dump all Components of Entity
                dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(GetItemUUID()):GetAllComponents())
                
                -- Get EntityVisual Dump
                local itemVisual = Ext.Entity.Get(GetItemUUID()).Visual
                dumpEntityVisualArea.Label = Ext.DumpExport(Ext.Resource.Get(itemVisual, "Visual"))
                
                -- Populate QuickInfo Labels
                --local name = Ext.Entity.Get(GetItemUUID()).DisplayName.NameKey.Handle.Handle
                --_P("Name: " .. name)
                --entityName.Label = Ext.Loca.GetTranslatedString(name)
                entityUUIDText.Label = GetItemUUID()
                entityName.Label = "Item"
                entityRace.Visible = false
                entityBodyType.Visible = false
                
            end
        end    

        -- Saves dump files to ScriptExtender folder
        if e.Key == "NUM_2" then
        Ext.IO.SaveFile("mouseoverDump.json", Ext.DumpExport(GetMouseover()))
        Ext.IO.SaveFile("entityDump.json", Ext.DumpExport(GetEntityUUID()))
        Ext.IO.SaveFile("itemDump.json", Ext.DumpExport(GetItemUUID()))
        end
    end
end)

Ext.Events.NetMessage:Subscribe(function(e) 

    if (e.Channel == "SendCharacterVisual") then
        local CVID = Ext.Json.Parse(e.Payload)
        entityCVID.Label = CVID
        dumpEntityVisualArea.Label = Ext.DumpExport(Ext.Resource.Get(CVID, "CharacterVisual"))
    end
end)


function GetDumpMouseoverLabel()
    return dumpMouseover.Label
end