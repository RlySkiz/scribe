local originalDump = {}

function GetOriginalDump()
    return originalDump
end

local function setOriginalDump(value)
    originalDump = value
end


Ext.Events.KeyInput:Subscribe(function (e)
    if e.Event == "KeyDown" and e.Repeat == false then

        if e.Key == "NUM_3" then
            _P("Pressed 3")
            InitializeTab(mouseoverTab)

            setOriginalDump(serializeMouseoverDump(getMouseover()))
            -- _P(Ext.Types.GetObjectType (mouseoverDumpTree))
            -- _P("mouseoverDumptree is of type " .. type(mouseoverDumpTree))
            -- _P("Print ", mouseoverDumpTree)
            _D(mouseoverDumpTree)

            local root = {}
            tree1 = Node:new("Root", nil, root)
            -- _D(tree1:getChildren())
            tree1:addChild(Node:new("Child 1", tree1, {}))

            -- child2 = Node:new("Child 2", tree1, {})
            -- tree1:addChild(child2)

            tree1:addChild(Node:new("Child 2", tree1, {}))

            tree1Children = tree1:getChildren()

            child2 = tree1Children[2]
            child2:addChild(Node:new("Child 2.1", child2, {}))
            child2:addChild(Node:new("Child 2.2", child2, {}))
            tree1:addChild(Node:new("Child 3", tree1, {}))
            -- _D(tree1:getChildren())

            _D(tree1:getChildrenNames(tree1, {}))

            -- _D(mouseoverDumpTree.Parent.Children)

            --_D(child2:getChildrenNames(self, {}))

            -- _D(mouseoverDumpTree.Children)
            -- treeparent = mouseoverDumpTree.Parent
            -- TableSize(mouseoverDumpTree)
            -- for x,y in treeparent do
            --     _P(x)
            --     _P(y)
            -- end

            --InitializeTab(entityTab)
            --InitializeTab(visualTab)
        end

        if e.Key == "NUM_4" then
            _D(Ext.UI.GetPickingHelper(1))
        end

        if e.Key == "NUM_1" then
            --_P("Num_1 pressed")
            --_D(Ext.UI.GetPickingHelper(1))
            CreateComponentTree(mouseoverDumpTree, getMouseover())                                          -- doesnt work

            if getEntityUUID() ~= nil then
                local dumpAll = Ext.Entity.Get(getEntityUUID()):GetAllComponents()

                if getMouseover().Inner.Inner[1].Character ~= null then

                -- Ext.DumpExport(Ext.Entity.Get(getEntityUUID()
                entityName.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()).CustomName.Name)
                entityRace.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()).Race.Race)
                entityBodyType.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()).BodyType.BodyType)
                
                -- Get CharacterVisual Dump
                Ext.Net.PostMessageToServer("RequestCharacterVisual", getEntityUUID())
                CreateComponentTree(entityDumpTree, dumpAll)                                                -- works
                entityDumpInfo.Label = Ext.DumpExport(dumpAll)
                _D(entityDumpTree)
                -- entityDumpTree.Selected = true
                else
                dumpEntity.Label = Ext.DumpExport(Ext.Entity.Get(getEntityUUID()):GetAllComponents())
                end
            end
        end    

        -- Saves dump files to ScriptExtender folder
        if e.Key == "NUM_2" then
        --_P("Num_2 pressed")
            Ext.IO.SaveFile("mouseoverDump.json", Ext.DumpExport(getMouseover()))
            Ext.IO.SaveFile("entityDump.json", Ext.DumpExport(Ext.Entity.Get(getEntityUUID()):GetAllComponents()))
        end
    end
end)

Ext.Events.NetMessage:Subscribe(function(e) 
    if (e.Channel == "SendCharacterVisualDump") then
        local dump = Ext.Json.Parse(e.Payload)
        entityCVID.Label = Ext.Json.Stringify(dump) -- Updates Visualresource UUID on entity tab
        CreateComponentTree(visualDumpTree, Ext.Resource.Get(dump, "CharacterVisual"))                      -- doesnt work
    end
end)

