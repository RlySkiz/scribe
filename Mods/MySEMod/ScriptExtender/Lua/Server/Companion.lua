
-- Companion.lua

-- creating the metatable

Companion = {}
Companion.__index = Companion

---@param name string
---@param health int
---@param class string
function Companion:new(name, health, class)
    local instance = setmetatable({
        name = name,
        health = health,
        class = class
    }, Companion)
    return instance
end


-- constants (you could also make this global since you should never change this)

local allowedClasses = {
    Barbarian = true,
    Bard = true,
    Cleric = true,
    Druid = true,
    Fighter = true,
    Monk = true,
    Paladin = true,
    Ranger = true,
    Rogue = true,
    Sorcerer = true,
    Warlock = true,
    Wizard = true
}


-- getters methods

-- returns the companions name
---@return name string
function Companion:getName()
    return self.name
end


-- returns the companions health
---@return health int
function Companion:getHealth()
    return self.health
end

-- returns the companions class
---@return class string
function Companion:getClass()
    return self.class
end


-- methods for modifying companions

-- increases the companions health
---@param healAmount int    - the amount by what the companion should be healed
function Companion:heal(healAmount)
    -- We can only heal someone is the healAmount is larger than 0
    if healAmount > 0 then 
        self.health = self.health + healAmount
        print(self.name , " has been healed for ", healAmount)
        print("their health has increased to ", self.health)
    else
        print("Negative healAmounts are not allowed")
    end
end


-- changes the companions class
---@param class string  - the new class of the companion 
function Companion:respec(newClass)
    -- check if the class is in allowedClasses
    if allowedClasses[newClass] then
        self.class = newClass
        print(self.name, " has changed their class to ", self.class)
    else 
        print(newClass, " is not an allowed class")
    end
end

