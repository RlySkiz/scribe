
local ass1 = "CAMP_GoblinHuntCelebration_SD_ROM_NightWithAstarion_f1f9ad82-3973-9307-7a9d-35c014ee2d68"

local veil = "8799147f-d227-4588-a9f8-3029c1a1d8fa"


--"ebed5dbc-d9c8-4624-b666-07aa2ddebf4c",
--"8d3c905d-caf0-4e66-b19b-97836369d893", -- Hair
--"8799147f-d227-4588-a9f8-3029c1a1d8fa" -- veil
--"03e47acd-f02e-4544-95b4-072d69f2a9db"


--Osi.DB_Dialogs


local blockVeilStripping = false

Ext.Osiris.RegisterListener("DialogStarted", 2, "before", function(dialog, instanceID) 
   -- _P("Dialogue started")
   -- _P("dialog ",dialog)
   -- _P("instanceID" , instanceID)

   -- if dialog == "CAMP_GoblinHuntCelebration_SD_ROM_NightWithAstarion_f1f9ad82-3973-9307-7a9d-35c014ee2d68" then
        print("Astarions first romance scene")
        blockVeilStripping = true
       -- print(veil)
       -- Osi.RemoveCustomVisualOvirride(Osi.GetHostCharacter(), veil)
  --  end
end)



Ext.Osiris.RegisterListener("DialogEnded", 2, "before", function(dialog, instanceID)  
    if dialog == ass1 then
        print("Ass dialog ended")
         Osi.AddCustomVisualOverride(Osi.GetHostCharacter(), veil)
    end


end)



Ext.Osiris.RegisterListener("WentOnStage", 2, "before", function(object, isOnStageNow)
    _P("Went on stage")
    if not blockVeilStripping then
        Osi.RemoveCustomVisualOvirride(Osi.GetHostCharacter(), veil)
    end

end)