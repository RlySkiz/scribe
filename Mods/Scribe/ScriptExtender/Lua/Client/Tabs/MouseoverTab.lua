w = Ext.IMGUI.NewWindow("Scribe")
tabbar = w:AddTabBar("")

mouseoverTab = tabbar:AddTabItem("Main")
mouseoverSearch = mouseoverTab:AddInputText("")
mouseoverSearch.Text = "Search"
hotkeyinfo = mouseoverTab:AddText("Num_1 = dump | Num_2 = dump file")
hotkeyinfo.SameLine = true
mouseoverTab:AddSeparator()
mouseoverTab:AddText("Dump Area:")
mouseoverTab:AddSeparator()
dumpMouseoverArea = mouseoverTab:AddText("")



--for i = 1, #listOfTabsToBeCreated do 
--    table.insert(listOfTabs,w:AddTabBar(""))
--end


--listOfTabs[1] 






-- MouseoverTab = {}
-- MouseoverTab.__index = MouseoverTab

-- function MouseoverTab:new()
--     local instance = setmetatable({}, MouseoverTab)


--     return instance
-- end



-- function MouseoverTab:GetDumpMouseoverArea()


-- end



-- function MouseoverTab:setDumpMouseoverArea()


-- end