w = Ext.IMGUI.NewWindow("Scribe")
tabbar = w:AddTabBar("")

mouseoverTab = tabbar:AddTabItem("Mouseover")
mouseoverTab:AddText("Num_1 = dump | Num_2 = dump file | Num_3 = test stuff")
mouseoverSearchInput = mouseoverTab:AddInputText("")
mouseoverSearchInput.AutoSelectAll = true
mouseoverSearchInput.Text = "Test"
mouseoverSearchInput.IDContext = "mouseoverInputTextField"

------------- Fucking fuck why do InputText fields not work ---------------

-- button1 = mouseoverTab:AddButton("Visual")
-- button1.SameLine = true
-- button1.OnClick = function()
--     mouseoverSearchInput.Text = button1.Label
--     mouseoverSearchInput.OnChange()
-- end
-- button2 = mouseoverTab:AddButton("UUID")
-- button2.SameLine = true
-- button2.OnClick = function()
--     mouseoverSearchInput.Text = button2.Label
--     mouseoverSearchInput.OnChange()
-- end
-- button3 = mouseoverTab:AddButton("Name")
-- button3.SameLine = true
-- button3.OnClick = function()
--     mouseoverSearchInput.Text = button3.Label
--     mouseoverSearchInput.OnChange()
-- end
-- button4 = mouseoverTab:AddButton("Mapkey")
-- button4.SameLine = true
-- button4.OnClick = function()
--     mouseoverSearchInput.Text = button4.Label
--     mouseoverSearchInput.OnChange()
-- end
-- clearbutton = mouseoverTab:AddButton("Clear")
-- clearbutton.SameLine = true
-- clearbutton.OnClick = function()
--     mouseoverSearchInput.Text = ""
--     mouseoverSearchInput.OnChange()
-- end
---------------------------------------------------------------------------

mouseoverTab:AddSeparator()

mouseoverTable = mouseoverTab:AddTable("",2)
mouseoverTable.ScrollY = true
mouseoverTableRow = mouseoverTable:AddRow("")
mouseoverDumpTree = mouseoverTableRow:AddCell():AddTree("Mouseover")
mouseoverDumpInfo = mouseoverTableRow:AddCell():AddText("")


--------------------  Functionality  -----------------------

mouseoverSearchInput.OnChange = function()
    sort = Sorting:new()

    local ogDump = GetOriginalDump()
    -- _D(ogDump)

    newMouseoverDump = sort:filter(mouseoverSearchInput.Text, ogDump)
    PopulateTree(mouseoverDumpTree, newMouseoverDump)
end

mouseoverDumpTree.OnClick = function()
    mouseoverDumpTree.Selected = true
end