Ext.Events.NetMessage:Subscribe(function(e) 
    if (e.Channel == "RequestServerCharacter") then
        local uuid = e.Payload
        local dump = Ext.DumpExport(Ext.Entity.Get(uuid).ServerCharacter.Template.CharacterVisualResourceID)
        Ext.Net.BroadcastMessage("SendServerCharacterDump", Ext.Json.Stringify(dump))
    end
end)