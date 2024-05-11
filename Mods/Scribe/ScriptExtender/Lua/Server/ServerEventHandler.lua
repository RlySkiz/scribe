Ext.Events.NetMessage:Subscribe(function(e) 
    if (e.Channel == "RequestCharacterVisual") then
        local uuid = e.Payload
        local dump = Ext.Entity.Get(uuid).ServerCharacter.Template.CharacterVisualResourceID
        Ext.Net.BroadcastMessage("SendCharacterVisualDump", Ext.Json.Stringify(dump))
    end

    if (e.Channel == "ScribeRequestHost") then
        _P("Request received")
        local host = Osi.GetHostCharacter()
        _P("Server Host: " .. host)
        Ext.Net.BroadcastMessage("ScribeSendHost", host)
    end
end)