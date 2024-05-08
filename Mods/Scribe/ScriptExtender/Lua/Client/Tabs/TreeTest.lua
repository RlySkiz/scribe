treeTab = tabbar:AddTabItem("Tree Test")

treeTable = treeTab:AddTable("",2)
treeTableRow = treeTable:AddRow()

root = treeTableRow:AddCell():AddTree("Test")
root.DefaultOpen = true

treeSelectionDump = treeTableRow:AddCell():AddInputText("")
treeSelectionDump.Text = "Placeholder"

item1 = root:AddTree("Item1")
item2 = root:AddTree("Item2")
item2.CollapsingHeader = true
item11 = item1:AddTree("Item1.1")
item21 = item2:AddTree("Item2.1")
item111 = item11:AddTree("Item1.1.1")


