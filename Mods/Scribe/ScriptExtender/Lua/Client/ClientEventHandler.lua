--------------------------------------------------------------------------------------------------
            
                             --   Handles messages to and from Server

-----------------------------------------------------------------------------------------------

local host
local characterVisual

function GetHost()
    return host
end

local function setHost(newHost)
    host = newHost

end

function GetCharacterVisual()
    return characterVisual
end



-- Receiving
Ext.Events.NetMessage:Subscribe(function(e) 

    -- receives host uuid from server
    if (e.Channel == "ScribeSendHost") then
        local host = e.Payload
        setHost(host)
        _P("received host ", host)
    end


    -- receives character visual from server
    if (e.Channel == "SendCharacterVisualDump") then
        local visual = Ext.Json.Parse(e.Payload)
        characterVisual = visual
        _P("received visual ", visual)
        
    end
end)


-- Sending
 
-- Request Host Character
function RequestHostCharacter()
    _P("Requestting host character")
    Ext.Net.PostMessageToServer("ScribeRequestHost","")
    _P("Sent request")
end

-- Request CharacterVisual
--@param uuid string - character uuid
function RequestCharacterVisual(uuid)
    Ext.Net.PostMessageToServer("RequestCharacterVisual", uuid)
end
