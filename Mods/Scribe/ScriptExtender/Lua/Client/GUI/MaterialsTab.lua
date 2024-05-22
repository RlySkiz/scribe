--------------------------------------------------------------------------------------
--
--
--                                   Materials Tab
--
--
---------------------------------------------------------------------------------------

MaterialsTab = Tabbar:AddTabItem("Materials")

MaterialsTab:AddText("Material UUID: ")
MaterialUUID = MaterialsTab:AddText("")
MaterialUUID.SameLine = true

MaterialsTab:AddSeparator()

MaterialsTable = MaterialsTab:AddTable("",2)
MaterialsTable.ScrollY = true