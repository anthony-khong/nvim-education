
print("Hello World")

function fact (n)
  if n == 0 then
      return 1
  else
      return n * fact(n-1)
  end
end
print(fact(50))

dofile('hello_world.lua')

--[[
multiline comment
add another hyphen above to toggle comment in a block
--]]

multiline_string = [[
abc
def
ghi
]]

print(multiline_string)

print(10 .. 20)
print('abc'.. 20)

a = {}
for i=1,10 do
  a[i] = (2*i+1)^2
end

for i,line in ipairs(a) do
  print(line)
end
