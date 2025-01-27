---@module "util"
local util = Ext.Require("Lib/ReactiveX/reactivex/util.lua")

--- Schedules Observables by running all operations immediately.
--- @class ImmediateScheduler
local ImmediateScheduler = {}
ImmediateScheduler.__index = ImmediateScheduler
ImmediateScheduler.__tostring = util.constant('ImmediateScheduler')

--- Creates a new ImmediateScheduler
--- @return ImmediateScheduler
function ImmediateScheduler.create()
    return setmetatable({}, ImmediateScheduler)
end

--- Schedules a function to be run on the scheduler. It is executed immediately.
--- @param action function - The function to execute.
function ImmediateScheduler:schedule(action)
    action()
end

return ImmediateScheduler
