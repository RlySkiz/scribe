mouseover = Ext.IMGUI.GetPickingHelper(1)
entity = mouseover.Inner.Inner.Character
item = mouseover.Inner.Inner.Item

Ext.Events.KeyInput:Subscribe(function (e)
    if e.Event == "KeyDown" and e.Repeat == false then
        _P("Something pressed")
        if e.Key == "NUM_1" then
            _P("Num_1 pressed")
            _D(Ext.IMGUI.GetPickingHelper(1))
            dumpMouseover.Label = Ext.DumpExport(mouseover)

            if entity ~= nil then
                dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(entity):GetAllComponents)
            end
        end    
        if e.Key == "NUM_2" then
        _P("Num_2 pressed")
        Ext.IO.SaveFile("mouseoverDump.json", Ext.DumpExport(Ext.IMGUI.GetPickingHelper(1)))
        end
    end
end)