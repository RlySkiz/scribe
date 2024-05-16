--------------------------------------------------------------------------------------------------
            
                             --   Handles messages to and from Server

-----------------------------------------------------------------------------------------------


---------------------------------------------------------------------------
--                                  Variables
---------------------------------------------------------------------------


local host
local characterVisual


---------------------------------------------------------------------------
--                            Getters and setters
---------------------------------------------------------------------------

function GetHost()
    return host
end

local function setHost(newHost)
    host = newHost

end

function GetCharacterVisual()
    return characterVisual
end


---------------------------------------------------------------------------
--                      Client Server Communication
---------------------------------------------------------------------------



---------------------------------------------------------------------------
--                                  Receiving
---------------------------------------------------------------------------

Ext.Events.NetMessage:Subscribe(function(e) 



    ---------------------------------------------------------------------------
    --
    --                Receives character HostCharacter from Server
    --
    ---------------------------------------------------------------------------

    if (e.Channel == "ScribeSendHost") then
        local host = e.Payload
        setHost(host)
    end

    ---------------------------------------------------------------------------
    --
    --                    Receives character visual from server
    --
    ---------------------------------------------------------------------------

    if (e.Channel == "SendCharacterVisualDump") then
        local visual = Ext.Json.Parse(e.Payload)
        characterVisual = visual
    end
end)


---------------------------------------------------------------------------
--                                  Sending
---------------------------------------------------------------------------
 
-- Request Host Character
function RequestHostCharacter()
    Ext.Net.PostMessageToServer("ScribeRequestHost","")
end

-- Request CharacterVisual
--@param uuid string - character uuid
function RequestCharacterVisual(uuid)
    Ext.Net.PostMessageToServer("RequestCharacterVisual", uuid)
end
