--------------------------------------------------------------------------------------
--
--
--                                       Mouseover Tab
--
--
---------------------------------------------------------------------------------------


W = Ext.IMGUI.NewWindow("Scribe")
Tabbar = W:AddTabBar("")

MouseoverTab = Tabbar:AddTabItem("Mouseover")

MouseoverTab:AddText("Num_1 = dump | Num_2 = dump file | Num_3 = test stuff")
MouseoverSearchInput = MouseoverTab:AddInputText("")
MouseoverSearchInput.AutoSelectAll = true
MouseoverSearchInput.Text = "Test"
MouseoverSearchInput.IDContext = "mouseoverInputTextField"
MouseoverSearchButton = MouseoverTab:AddButton("Search")
MouseoverSearchButton.SameLine = true

------------- Fucking fuck why do InputText fields not work ---------------

-- button1 = MouseoverTab:AddButton("Visual")
-- button1.SameLine = true
-- button1.OnClick = function()
--     MouseoverSearchInput.Text = button1.Label
--     MouseoverSearchInput.OnChange()
-- end
-- button2 = MouseoverTab:AddButton("UUID")
-- button2.SameLine = true
-- button2.OnClick = function()
--     MouseoverSearchInput.Text = button2.Label
--     MouseoverSearchInput.OnChange()
-- end
-- button3 = MouseoverTab:AddButton("Name")
-- button3.SameLine = true
-- button3.OnClick = function()
--     MouseoverSearchInput.Text = button3.Label
--     MouseoverSearchInput.OnChange()
-- end
-- button4 = MouseoverTab:AddButton("Mapkey")
-- button4.SameLine = true
-- button4.OnClick = function()
--     MouseoverSearchInput.Text = button4.Label
--     MouseoverSearchInput.OnChange()
-- end
-- clearbutton = MouseoverTab:AddButton("Clear")
-- clearbutton.SameLine = true
-- clearbutton.OnClick = function()
--     MouseoverSearchInput.Text = ""
--     MouseoverSearchInput.OnChange()
-- end
---------------------------------------------------------------------------

MouseoverTab:AddSeparator()

MouseoverTable = MouseoverTab:AddTable("",2)
MouseoverTable.ScrollY = true
MouseoverTableRow = MouseoverTable:AddRow("")

-- function InitializeMouseoverTree()

-- end

--------------------  Functionality  -----------------------

if mouseoverDumpTree ~= nil then
    mouseoverDumpTree.OnClick = function()
        if mouseoverDumpTree.Selected then
            mouseoverDumpTree.Selected = false
        else
            mouseoverDumptree.Selected = true
        end
    end
end

-- Quicksearch
-- MouseoverSearchInput.OnChange = function()
--     sort = Sorting:new()

--     local ogDump = GetOriginalDump()
--     -- _D(ogDump)

--     newMouseoverDump = sort:filter(MouseoverSearchInput.Text, ogDump)
--     PopulateTree(mouseoverDumpTree, newMouseoverDump)
-- end

-- Buttonsearch
MouseoverSearchButton.OnClick = function()
    _P("Search Button Clicked")
    _P("Searching for: ", MouseoverSearchInput.Text)

    sort = Sorting:new()

    local ogDump = GetCopiedTable(MouseoverTab.Label, nil)
    newMouseoverDump = sort:filter(MouseoverSearchInput.Text, ogDump)

    if #newMouseoverDump == 0 then
        newMouseOverDump = "No results found"
    end

    InitializeTree(MouseoverTab, newMouseoverDump)
    mouseoverDumpInfo.Label = Ext.DumpExport(newMouseoverDump)
end