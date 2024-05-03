treeTab = tabbar:AddTabItem("Tree Test")

tree = treeTab:AddTree("Test")

tree:AddText("Text1")
tree:AddText("Text2")
text3 = tree:AddText("Text3")
--text3.Leaf = true
text3:AddText("Text3.1")
tree:AddButton("Button1")
tree:AddCollapsingHeader("")