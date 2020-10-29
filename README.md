## Neovim Education

This repository contains my notes and experiments on creating a Neovim plugin. At the time of writing this paragraph, I have zero experience in Lua, Fennel, Aniseed and Neovim plugins. The plan is to learn them all and jot down any important insights I learn along the way.

## Programming in Lua

### Installation

```bash
brew install lua luajit luarocks
```

### Part I

On local variables:
- Beware that this example will not work as expected if you enter it in interactive mode. The second line, local i = 1, is a complete chunk by itself. As soon as you enter this line, Lua runs it and starts a new chunk in the next line. By then, the local declaration is already out of scope. To run such examples in interactive mode, you should enclose all the code in a do block.

On functions:
- Lua adjusts the number of arguments to the number of parameters, as it does in a multiple assignment: Extra arguments are thrown away; extra parameters get nil.
- When a function call is the last (or the only) argument to another call, all results from the first call go as arguments.
- Beware that a return statement does not need parentheses around the returned value, so any pair of parentheses placed there counts as an extra pair. That is, a statement like return (f()) always returns one single value, no matter how many values f returns. Maybe this is what you want, maybe not.
- Unpack:
    ```lua
    function unpack (t, i)
      i = i or 1
      if t[i] ~= nil then
        return t[i], unpack(t, i + 1)
      end
    end
    ```
- The three dots (...) in the parameter list indicate that the function has a variable number of arguments. When this function is called, all its arguments are collected in a single table, which the function accesses as a hidden parameter named arg. Besides those arguments, the arg table has an extra field, n, with the actual number of arguments collected.

On generic for:
More precisely, a construction like

```lua
for var_1, ..., var_n in explist do block end
```

is equivalent to the following code:

```lua
do
    local _f, _s, _var = explist
    while true do
    local var_1, ... , var_n = _f(_s, _var)
    _var = var_1
    if _var == nil then break end
    block
    end
end
```

So, if our iterator function is f, the invariant state is s, and the initial value for the control variable is a0, the control variable will loop over the values a1 = f(s, a0), a2 = f(s, a1), and so on, until ai is nil. If the for has other variables, they simply get the extra values returned by each call to f.

On errors
Because Lua is an extension language, frequently embedded in an application, it cannot simply crash or exit when an error happens. Instead, whenever an error occurs, Lua ends the current chunk and returns to the application.

### Part II

```lua
-- WARNING: bad code ahead!!
local buff = ""
for line in io.lines() do
buff = buff .. line .. "\n"
end
```

To understand what happens, let us assume that we are in the middle of the read loop; buff is already a string with 50 KB and each line has 20 bytes. When Lua concatenates buff..line.."\n", it creates a new string with 50,020 bytes and copies 50 KB from buff into this new string. That is, for each new line, Lua moves 50 KB of memory, and growing. After reading 100 new lines (only 2 KB), Lua has already moved more than 5 MB of memory.

Do this instead:

```lua
local t = {}
for line in io.lines() do
    table.insert(t, line)
end
s = table.concat(t, "\n") .. "\n"
```

Metatables allow us to change the behavior of a table. For instance, using metatables, we can define how Lua computes the expression a+b, where a and b are tables. Whenever Lua tries to add two tables, it checks whether either of them has a metatable and whether that metatable has an `__add` field. If Lua finds this field, it calls the corresponding value (the so-called metamethod, which should be a function) to compute the sum.

To choose a metamethod, Lua does the following: (1) If the first value has a metatable with an `__add` field, Lua uses this value as the metamethod, independently of the second value; (2) otherwise, if the second value has a metatable with an `__add` field, Lua uses this value as the metamethod; (3) otherwise, Lua raises an error.

An equality comparison never raises an error, but if two objects have different metamethods, the equality operation results in false, without even calling any metamethod. Again, this behavior mimics the common behavior of Lua, which always classifies strings as different from numbers, regardless of their values. Lua calls the equality metamethod only when the two objects being compared share this metamethod.

On weak tables:
Weak tables are the mechanism that you use to tell Lua that a reference should not prevent the reclamation of an object. A weak reference is a reference to an object that is not considered by the garbage collector. If all references pointing to an object are weak, the object is collected and somehow these weak references are deleted. Lua implements weak references as weak tables: A weak table is a table where all references are weak. That means that, if an object is only held inside weak tables, Lua will collect the object eventually.

The weakness of a table is given by the field `__mode` of its metatable. The value of this field, when present, should be a string: If the string contains the letter `k` (lower case), the keys in the table are weak; if the string contains the letter `v` (lower case), the values in the table are weak.

### Part III

