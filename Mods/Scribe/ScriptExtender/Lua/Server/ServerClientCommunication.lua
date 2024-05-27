--------------------------------------------------------------------------------------------------
            
                             --   Handles messages to and from Client

-----------------------------------------------------------------------------------------------



Ext.Events.NetMessage:Subscribe(function(e) 


    ---------------------------------------------------------------------------
    --
    --        Get CharacterVisualResourceID (different information serverside)
    --
    ---------------------------------------------------------------------------

    -- if (e.Channel == "RequestCharacterVisual") then
    --     local uuid = e.Payload
    --     local dump = Ext.Entity.Get(uuid).ServerCharacter.Template.CharacterVisualResourceID
    --     Ext.Net.BroadcastMessage("SendCharacterVisualDump", Ext.Json.Stringify(dump))
    -- end



    --_D(Ext.Entity.Get("bd3c7bc6-5169-3451-5210-9ec9a9cf53b1").ServerCharacter.Template.CharacterVisualResourceID)
-- "d67bd924-3c1f-c33a-5298-feca5bbdc284"
    if (e.Channel == "RequestCharacterVisualResourceID") then
        -- _P("RequestCharacterVisualResourceID recieved")

        local uuid = Ext.Json.Parse(e.Payload)
        local characterVisualResourceID = Ext.Entity.Get(uuid).ServerCharacter.Template.CharacterVisualResourceID
        -- local characterVisual = Ext.Resource.Get(characterVisualID, "CharacterVisual")
        Ext.Net.BroadcastMessage("SendCharacterVisualResourceID",Ext.Json.Stringify(characterVisualResourceID))
       -- _P("SendCharacterVisual send")
    end

    ---------------------------------------------------------------------------
    --
    --                                Send Entity Data
    --
    ---------------------------------------------------------------------------


      if (e.Channel == "RequestEntityData") then
        -- _P("Received RequestEntityData")
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