-- Utilities
Ext.Require("Shared/Utils.lua")

-- Communication between Client and Server

Ext.Require("Client/ClientServerCommunication.lua")



-- Objects instantiated via metatables (Java-like)
--Ext.Require("Shared/Objects/Node.lua")



-- GUI - scripts that directly deal with IMGUI


--- satan comment -- Ext.Require("Client/GUI/MouseoverTab.lua")
--- satan comment --Ext.Require("Client/GUI/EntityTab.lua")
--- satan comment --Ext.Require("Client/GUI/VisualTab.lua")
--- satan comment --Ext.Require("Client/GUI/VisualBankTab.lua")
-- Ext.Require("Client/GUI/MaterialsTab.lua")
-- Ext.Require("Client/GUI/TexturesTab.lua")

Ext.Require("Client/GUI/Tab.lua")




-- Logic - scripts that do not directly deal with IMGUI
Ext.Require("Client/Logic/TreeHandling.lua")
Ext.Require("Client/Logic/Sorting.lua")
Ext.Require("Client/Logic/DataHandling.lua")

-- Main Class

Ext.Require("Client/Scribe.lua")



-- TODO
-- when clicking on a Node, initialize the children
-- Race, Bodytaype, CharacterVisual broken