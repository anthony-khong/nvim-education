
-- operations bound to a table
Account = {balance = 0}
function Account:withdraw(v)
    self.balance = self.balance - v
end
a = Account
a:withdraw(10.0)

-- OO in Lua
Account = {balance = 0}

function Account:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Account:deposit (v)
    self.balance = self.balance + v
end

function Account:withdraw (v)
    if v > self.balance then error"insufficient funds" end
    self.balance = self.balance - v
end

a = Account:new{balance = 0}
a:deposit(100.00)

-- Inheritance
SpecialAccount = Account:new()

function SpecialAccount:withdraw (v)
    if v - self.balance >= self:getLimit() then
    error"insufficient funds"
    end
    self.balance = self.balance - v
end

function SpecialAccount:getLimit ()
    return self.limit or 0
end

-- Singleton Methods
s = SpecialAccount:new{limit=1000.00}
function s:getLimit ()
    return self.balance * 0.10
end

-- Memoisation using Weak Tables
local results = {}
setmetatable(results, {__mode = "v"})
function mem_loadstring (s)
    if results[s] then      -- result available?
    return results[s]     -- reuse it
    else
    local res = loadstring(s)   -- compute new result
    results[s] = res            -- save for later reuse
    return res
    end
end
