w = Ext.IMGUI.NewWindow("Scribe")
tabbar = w:AddTabBar("")
taba = tabbar:AddTabItem("Main")
taba:AddText("Num_1 = dump | Num_2 = dump file")
taba:AddText("Dump:")
dumpMouseover = taba:AddText("")

tabb = tabbar:AddTabItem("Entity")
tabb:AddText("Dump")

mouseover = Ext.IMGUI.GetPickingHelper(1)
entity = mouseover.Inner.Inner.Character

Ext.Events.KeyInput:Subscribe(function (e)
    if e.Event == "KeyDown" and e.Repeat == false then
        _P("Something pressed")
        if e.Key == "NUM_1" then
            _P("Num_1 pressed")
            _D(Ext.IMGUI.GetPickingHelper(1))
            dumpMouseover.Label = Ext.DumpExport(mouseover)
            dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(entity):GetAllComponents)
        end    
        if e.Key == "NUM_2" then
        _P("Num_2 pressed")
        Ext.IO.SaveFile("mouseoverDump.json", Ext.DumpExport(Ext.IMGUI.GetPickingHelper(1)))
        end
    end
end)