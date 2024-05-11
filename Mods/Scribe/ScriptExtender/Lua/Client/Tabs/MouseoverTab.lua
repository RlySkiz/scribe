w = Ext.IMGUI.NewWindow("Scribe")
tabbar = w:AddTabBar("")

mouseoverTab = tabbar:AddTabItem("Mouseover")
mouseoverTab:AddText("Num_1 = dump | Num_2 = dump file | Num_3 = test stuff")
mouseoverTab:AddSeparator()

mouseoverTable = mouseoverTab:AddTable("",2)
mouseoverTable.ScrollY = true
mouseoverTableRow = mouseoverTable:AddRow("")
mouseoverDumpTree = mouseoverTableRow:AddCell():AddTree("Mouseover")
mouseoverDumpInfo = mouseoverTableRow:AddCell():AddText("")
