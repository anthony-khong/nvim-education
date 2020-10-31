-- Random seed
math.randomseed(os.time())

-- Open a file and read it all
local f = assert(io.open(filename, "r"))
local t = f:read("*all")
f:close()

-- Time and date
os.date("*t", os.time())

-- System Calls
os.getenv("HOME")

-- Prints the number of each new line
debug.sethook(print, "l")
