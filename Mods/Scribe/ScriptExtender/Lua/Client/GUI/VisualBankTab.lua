--------------------------------------------------------------------------------------
--
--
--                                       Entity Visual Bank Tab
--
--
---------------------------------------------------------------------------------------


VisualTab = Tabbar:AddTabItem("VisualBank")


VisualTab:AddSeparator()

VisualTable = VisualTab:AddTable("",2)
VisualTable.ScrollY = true
VisualTableRow = VisualTable:AddRow("")
VisualDumpTree = VisualTableRow:AddCell():AddTree("VisualResource")
VisualDumpInfo = VisualTableRow:AddCell():AddText("")
