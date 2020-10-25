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
