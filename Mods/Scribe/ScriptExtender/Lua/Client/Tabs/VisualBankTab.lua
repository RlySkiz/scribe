visualTab = tabbar:AddTabItem("VisualBank")


visualTab:AddSeparator()

visualTable = visualTab:AddTable("",2)
visualTable.ScrollY = true
visualTableRow = visualTable:AddRow("")
visualDumpTree = visualTableRow:AddCell():AddTree("VisualResource")
visualDumpInfo = visualTableRow:AddCell():AddText("")
