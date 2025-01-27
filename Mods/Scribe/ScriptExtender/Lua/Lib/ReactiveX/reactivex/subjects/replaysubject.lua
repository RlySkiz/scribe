local Subject = Ext.Require("Lib/ReactiveX/reactivex/subjects/subject.lua")
local Observer = Ext.Require("Lib/ReactiveX/reactivex/observer.lua")
local util = Ext.Require("Lib/ReactiveX/reactivex/util.lua")

--- A Subject that provides new Subscribers with some or all of the most recently
--- produced values upon subscription.
--- @class ReplaySubject : Subject
--- @field buffer any[]
--- @field bufferSize integer
local ReplaySubject = setmetatable({}, Subject)
ReplaySubject.__index = ReplaySubject
ReplaySubject.__tostring = util.constant('ReplaySubject')

--- Creates a new ReplaySubject.
--- @param bufferSize number [or 10] - The number of values to send to new subscribers. If nil, an infinite buffer is used (note that this could lead to memory issues).
--- @return ReplaySubject
function ReplaySubject.create(bufferSize)
    local self = {
        observers = {},
        stopped = false,
        buffer = {},
        bufferSize = bufferSize or 10
    }

    return setmetatable(self, ReplaySubject)
end

--- Creates a new Observer and attaches it to the ReplaySubject. Immediately broadcasts the most
--- contents of the buffer to the Observer.
--- @param observerOrNext function|Observer - Called when the ReplaySubject produces a value.
--- @param onError function? - Called when the ReplaySubject terminates due to an error.
--- @param onCompleted function? - Called when the ReplaySubject completes normally.
function ReplaySubject:subscribe(observerOrNext, onError, onCompleted)
    local observer

    if util.isa(observerOrNext, Observer) then
        observer = observerOrNext --[[@as Observer]]
    else
        observer = Observer.create(observerOrNext, onError, onCompleted)
    end

    local subscription = Subject.subscribe(self, observer)

    for i = 1, #self.buffer do
        observer:onNext(util.unpack(self.buffer[i]))
    end

    return subscription
end

--- Pushes zero or more values to the ReplaySubject. They will be broadcasted to all Observers.
--- @generic T : any
--- @param ... T
function ReplaySubject:onNext(...)
    table.insert(self.buffer, util.pack(...))
    if self.bufferSize and #self.buffer > self.bufferSize then
        table.remove(self.buffer, 1)
    end

    return Subject.onNext(self, ...)
end

ReplaySubject.__call = ReplaySubject.onNext

return ReplaySubject
