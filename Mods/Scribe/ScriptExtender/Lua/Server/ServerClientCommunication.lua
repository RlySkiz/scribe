--------------------------------------------------------------------------------------------------
            
                             --   Handles messages to and from Client

-----------------------------------------------------------------------------------------------



Ext.Events.NetMessage:Subscribe(function(e) 


    ---------------------------------------------------------------------------
    --
    --        Get CharacterVisualResourceID (different information serverside)
    --
    ---------------------------------------------------------------------------

    if (e.Channel == "RequestCharacterVisual") then
        local uuid = e.Payload
        local dump = Ext.Entity.Get(uuid).ServerCharacter.Template.CharacterVisualResourceID
        Ext.Net.BroadcastMessage("SendCharacterVisualDump", Ext.Json.Stringify(dump))
    end

    ---------------------------------------------------------------------------
    --
    --                                Send Entity Data
    --
    ---------------------------------------------------------------------------


      if (e.Channel == "RequestEntityData") then
        _P("Received RequestEntityData")
        local entity = e.Payload
        local dump = Ext.Entity.Get(entity):GetAllComponents()
        Ext.Net.BroadcastMessage("ReceiveEntityData", Ext.Json.Stringify(dump))
    end


    ---------------------------------------------------------------------------
    --
    --                       Get HostCharacter
    --
    ---------------------------------------------------------------------------

    if (e.Channel == "ScribeRequestHost") then
        local host = Osi.GetHostCharacter()
        Ext.Net.BroadcastMessage("ScribeSendHost", host)
    end
end)