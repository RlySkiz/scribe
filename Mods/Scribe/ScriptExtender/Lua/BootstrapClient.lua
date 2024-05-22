-- Communication between Client and Server

Ext.Require("Client/ClientServerCommunication.lua")

-- Utilities
Ext.Require("Client/ClientUtils.lua")


-- Objects instantiated via metatables (Java-like)
Ext.Require("Client/Objects/Node.lua")


-- Logic - scripts that do not directly deal with IMGUI
Ext.Require("Client/Logic/TreeHandling.lua")
Ext.Require("Client/Logic/Sorting.lua")


-- GUI - scripts that directly deal with IMGUI


Ext.Require("Client/GUI/MouseoverTab.lua")
Ext.Require("Client/GUI/EntityTab.lua")
Ext.Require("Client/GUI/EntityVisualTab.lua")
Ext.Require("Client/GUI/VisualBankTab.lua")
Ext.Require("Client/GUI/MaterialsTab.lua")
Ext.Require("Client/GUI/TexturesTab.lua")

Ext.Require("Client/Utils/DataHandling.lua")

-- Main Class

Ext.Require("Client/Scribe.lua")


-- TODO
-- when clicking on a Node, initialize the children
-- Race, Bodytaype, CharacterVisual broken