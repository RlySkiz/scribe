--------------------------------------------------------------------------------------
--
--
--                                   Mouseover Tab
--
--
---------------------------------------------------------------------------------------


W = Ext.IMGUI.NewWindow("Scribe")
Tabbar = W:AddTabBar("")

MouseoverTab = Tabbar:AddTabItem("Mouseover")

MouseoverTab:AddText("Num_2 = mouseover/entity file dump | Num_3 = test stuff")
-- MouseoverSearchInput = MouseoverTab:AddInputText("")
-- MouseoverSearchInput.AutoSelectAll = true
-- MouseoverSearchInput.Text = "Test"
-- MouseoverSearchInput.IDContext = "mouseoverInputTextField"
-- MouseoverSearchButton = MouseoverTab:AddButton("Search")
-- MouseoverSearchButton.SameLine = true

MouseoverTab:AddSeparator()

MouseoverTable = MouseoverTab:AddTable("",2)
MouseoverTable.ScrollY = true
-- MouseoverTableRow = MouseoverTable:AddRow("")

    -- Create CCInfoTable about having to enter CharacterCreation/Mirror to load Vanilla Icons
    -- local header = GetSCRIBETABLE(tab)
    -- local CCInfoTable = header:AddTable("", 2)
    -- local CCInfoTableRow = CCInfoTable:AddRow()
    -- local CCInfoTableCell = CCInfoTableRow:AddCell()
    -- local CCInfoTableCell2 = CCInfoTableRow:AddCell()
    -- local CCInfoText = CCInfoTableCell:AddText("Vanilla Icon Textures are only accessible\nif you have been in Character Creation/Mirror\nat least once after installing this mod.\nThis Button will automate it. (Takes roughly 3 seconds)")
    -- local CCInfoButton = CCInfoTableCell2:AddButton("Load Vanilla Icons")
    
    -- CCInfoButton.OnClick = function()
    --     _P("[DataHandling.lua.lua] - CCButton Pressed - Initialize Character Creation/Mirror to load Vanilla Icons!")
    --     CCInfoButton.Visible = false
    --     CCInfoText.Visible = false
    --     CCInfoTableCell2.Visible = false
    --     CCInfoTableCell.Visible = false
    --     CCInfoTableRow.Visible = false
    --     CCInfoTable.Visible = false
    -- end


--------------------  Functionality  -----------------------

-- if mouseoverDumpTree ~= nil then
--     mouseoverDumpTree.OnClick = function()
--         if mouseoverDumpTree.Selected then
--             mouseoverDumpTree.Selected = false
--         else
--             mouseoverDumptree.Selected = true
--         end
--     end
-- end

-- Quicksearch
-- MouseoverSearchInput.OnChange = function()
--     sort = Sorting:new()

--     local ogDump = GetOriginalDump()
--     -- _D(ogDump)

--     newMouseoverDump = sort:filter(MouseoverSearchInput.Text, ogDump)
--     PopulateTree(mouseoverDumpTree, newMouseoverDump)
-- end

-- Buttonsearch
-- MouseoverSearchButton.OnClick = function()
--     _P("Search Button Clicked")
--     _P("Searching for: ", MouseoverSearchInput.Text)

--     sort = Sorting:new()

--     local ogDump = GetCopiedTable(MouseoverTab.Label, nil)
--     newMouseoverDump = sort:filter(MouseoverSearchInput.Text, ogDump)

--     if #newMouseoverDump == 0 then
--         newMouseOverDump = "No results found"
--     end

--     InitializeTree(MouseoverTab, newMouseoverDump)
--     mouseoverDumpInfo.Label = Ext.DumpExport(newMouseoverDump)
-- end