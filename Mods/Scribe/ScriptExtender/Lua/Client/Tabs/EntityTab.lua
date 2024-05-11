entityTab = tabbar:AddTabItem("Entity")



entityTab:AddText("Name: ")
entityName = entityTab:AddText("")
entityName.SameLine = true

entityTab:AddText("Race: ")
entityRace = entityTab:AddText("")
entityRace.SameLine = true

entityTab:AddText("BodyType: ")
entityBodyType = entityTab:AddText("")
entityBodyType.SameLine = true

entityTab:AddText("CharacterVisualResourceID: ")
entityCVID = entityTab:AddText("")
entityCVID.SameLine = true

-- entityTab:AddText("Dump")
-- dumpEntity = entityTab:AddText("")

entityTab:AddSeparator()

entityTable = entityTab:AddTable("",2)
entityTable.ScrollY = true
entityTableRow = entityTable:AddRow("")
entityDumpTree = entityTableRow:AddCell():AddTree("Entity")
entityDumpInfo = entityTableRow:AddCell():AddText("")

