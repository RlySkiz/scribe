--- @class TextEditor : PropertyEditorDefinition
local TextEditor = {}

function TextEditor:Supports(type)
    return type.Kind == "String"
end

function TextEditor:Create(holder, path, key, value, type, setter)
    local cb = holder:AddInputText("", value)
    cb.ItemWidth = -5
    cb.OnChange = function ()
        setter(cb.Value[1])
    end
    return cb
end

return TextEditor
