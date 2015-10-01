local lpeg = require "lpeg"
lpeg.locale(lpeg)
-- Lexical Elements
local Space = lpeg.S(" \n\t")^0
local Data = lpeg.C("data") * Space
local Name = lpeg.C(lpeg.alpha^1) * Space
local ListNames = lpeg.Ct(Name * (Name)^0 ) * Space
local Sep = lpeg.C(lpeg.S("|")) * Space

-- Grammar
local NameType, Term, Factor = lpeg.V"NameType", lpeg.V"Term", lpeg.V"Factor"
G = lpeg.P{ "S";
  S = lpeg.Ct(Data * Name * "=" * Space * lpeg.V"Def" ),
  Def = lpeg.Ct( ListNames * (Sep * ListNames)^0 ),
}

G = Space * G * -1

table_print = function(tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    for key, value in pairs (tt) do
      io.write(string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        io.write(string.format("[%s] => table\n", tostring (key)));
        io.write(string.rep (" ", indent+4)) -- indent it
        io.write("(\n");
        table_print (value, indent + 7, done)
        io.write(string.rep (" ", indent+4)) -- indent it
        io.write(")\n");
      else
        io.write(string.format("[%s] => %s\n",
            tostring (key), tostring(value)))
      end
    end
  else
    io.write(tt .. "\n")
  end
end

-- Parser/Evaluator
function evalExp (s)
  local t , e = lpeg.match(G, s)
  if not t then error("syntax error", 2)end
  table_print(t)
end

-- small example
print(evalExp[[data Lol = Game a b d e   | a b c d s  | a b c d g Lol ]])   --> 13.5
