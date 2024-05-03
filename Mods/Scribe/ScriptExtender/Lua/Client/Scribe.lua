w = Ext.IMGUI.NewWindow("Scribe")
w:AddText("Dump:")
dumpArea = w:AddText("Dump Area")

Ext.Events.KeyInput:Subscribe(function (e)
    if e.Event == "KeyDown" and e.Repeat == false then
        if e.Key == "GRAVE" then
            _D(Ext.IMGUI.GetPickingHelper(1))
            dumpArea.Label = Ext.IMGUI.GetPickingHelper(1)
        end    
    end
end)