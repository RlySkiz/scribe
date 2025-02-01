-- Static/Globals
Ext.Require("Shared/Defines.lua")

-- Utilities
Ext.Require("Shared/Utils.lua")

-- User libs
Ext.Require("Lib/_Init.lua")

-- Communication between Client and Server

Ext.Require("Client/ClientServerCommunication.lua")



-- Objects instantiated via metatables (Java-like)
--Ext.Require("Shared/Objects/Node.lua")



-- GUI - scripts that directly deal with IMGUI
Ext.Require("Client/GUI/Tab.lua")
Ext.Require("Client/GUI/Search.lua")




-- Logic - scripts that do not directly deal with IMGUI
Ext.Require("Client/Logic/TreeHandling.lua")
Ext.Require("Client/Logic/Sorting.lua")
Ext.Require("Client/Logic/DataHandling.lua")

-- Main Class

Ext.Require("Client/Scribe.lua")
-- Ext.Require("Client/ScribeNew.lua")



-- TODO
-- when clicking on a Node, initialize the children
-- Race, Bodytype, CharacterVisual broken