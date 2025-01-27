RequireFiles("Lib/Aahz/Server/", {
    "Classes/_Init",
})

-- #HACK remove before release? need to do something about that damn thing...
Ext.Events.SessionLoaded:Subscribe(function()
    -- There's an annoying helper sitting in lava for mephits to spawn in at, but it's not
    -- immune to burning, so... it triggers constant melting hit events
    local annoyingHelperID = "783884b2-fbee-4376-9c18-6fd99d225ce6"
    local annoyingHelper = Ext.Entity.Get(annoyingHelperID)
    if annoyingHelper ~= nil then
        annoyingHelper.StatusImmunities.PersonalStatusImmunities["BURNING"] = NULLUUID
        annoyingHelper.StatusImmunities.PersonalStatusImmunities["BURNING_LAVA"] = NULLUUID
        annoyingHelper.StatusImmunities.PersonalStatusImmunities["SG_Condition"] = NULLUUID
        annoyingHelper:Replicate("StatusImmunities")
    end
end)