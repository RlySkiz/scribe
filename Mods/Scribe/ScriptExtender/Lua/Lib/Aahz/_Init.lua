-- Automatically initialize based on context
if Ext.IsServer() then
    RequireFiles("Lib/Aahz/", {
        "Shared/_Init",
        "Server/_Init",
    })
else
    RequireFiles("Lib/Aahz/", {
        "Shared/_Init",
        "Client/_Init",
    })
end