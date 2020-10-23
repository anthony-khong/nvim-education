
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
