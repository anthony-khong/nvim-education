
print("Hello World")

function fact (n)
  if n == 0 then
      return 1
  else
      return n * fact(n-1)
  end
end

--[[
multiline comment
add another hyphen above to toggle comment in a block
--]]

-- multiline_string
x = [[
abc
def
ghi
]]

-- String concatenation
print(10 .. 20)
print('abc'.. 20)

-- Looping
a = {}
for i=1,10 do
  a[i] = (2*i+1)^2
end

-- execute a file
dofile('hello_world.lua')

-- zip with index
for i,line in ipairs(a) do
  print(line)
end

-- arrays
days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

-- records
w = {x=0, y=0, label="console"}

-- records with expression identifiers
opnames = {["+"] = "add", ["-"] = "sub",
           ["*"] = "mul", ["/"] = "div"}
a = {[i+0] = s, [i+1] = s..s, [i+2] = s..s..s}

-- if + local scope
if i > 20 then
    local x          -- local to the "then" body
    x = 20
    print(x + 2)
else
    print(x)         --> 10  (the global one)
end

t = {x=1, y=2}
-- print all keys of table `t'
for k in pairs(t) do print(k) end
-- print all values of table `t'
for _,v in pairs(t) do print(v) end

-- arg unpacking
print(unpack{10,20,30})    --> 10   20   30
a,b = unpack{10,20,30}     -- a=10, b=20, 30 is discarded

-- variadic function
function print (...)
    for i,v in ipairs(arg) do
    printResult = printResult .. tostring(v) .. "\t"
    end
    printResult = printResult .. "\n"
end

-- named args
function rename (arg)
    return os.rename(arg.old, arg.new)
end
rename{old="temp.lua", new="temp1.lua"}

