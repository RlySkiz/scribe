w = Ext.IMGUI.NewWindow("Scribe")
w:AddText("Dump:")
dumpArea = w:AddText("Dump Area")

Ext.Events.KeyInput:Subscribe(function (e)
    if e.Event == "KeyDown" and e.Repeat == false then
        _P("Something pressed")
        if e.Key == "NUM_1" then
            _P("Num_1 pressed")
            _D(Ext.IMGUI.GetPickingHelper(1))
            dumpArea.Label = Ext.Json.Stringify(Ext.IMGUI.GetPickingHelper(1))
        end    
    end
end)