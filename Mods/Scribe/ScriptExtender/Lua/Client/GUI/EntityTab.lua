--------------------------------------------------------------------------------------
--
--
--                                         Entity Tab
--
--
---------------------------------------------------------------------------------------


EntityTab = Tabbar:AddTabItem("Entity")


EntityTab:AddText("Name: ")
EntityName  = EntityTab:AddText("")
EntityName .SameLine = true

EntityTab:AddText("Race: ")
EntityRace  = EntityTab:AddText("")
EntityRace .SameLine = true

EntityTab:AddText("BodyType: ")
EntityBodyType = EntityTab:AddText("")
EntityBodyType.SameLine = true

EntityTab:AddText("CharacterVisualResourceID: ")
EntityCVID = EntityTab:AddText("")
EntityCVID.SameLine = true

-- EntityTab:AddText("Dump")
-- dumpEntity = EntityTab:AddText("")

EntityTab:AddSeparator()

EntityTable = EntityTab:AddTable("",2)
EntityTable.ScrollY = true
EntityTableRow = EntityTable:AddRow("")
-- entityDumpTree = EntityTableRow:AddCell():AddTree("Entity")

-- local entityTree = getSavedEntityTree()
-- if entityTree.