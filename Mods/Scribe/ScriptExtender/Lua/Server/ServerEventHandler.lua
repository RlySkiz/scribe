Ext.Events.NetMessage:Subscribe(function(e) 
    if (e.Channel == "RequestCharacterVisual") then
        local uuid = e.Payload
        local CVID = Ext.DumpExport(Ext.Entity.Get(uuid).ServerCharacter.Template.CharacterVisualResourceID)
        Ext.Net.BroadcastMessage("SendCharacterVisual", CVID)
    end
end)