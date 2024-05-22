--------------------------------------------------------------------------------------
--
--
--                                   Textures Tab
--
--
---------------------------------------------------------------------------------------

TexturesTab = Tabbar:AddTabItem("Textures")

TexturesTab:AddText("Texture UUID: ")
TextureUUID = TexturesTab:AddText("")
TextureUUID.SameLine = true

TexturesTab:AddSeparator()

TexturesTable = TexturesTab:AddTable("",2)
TexturesTable.ScrollY = true