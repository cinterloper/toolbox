url = require "net.url"
parsed = url.parse(arg[1])

function ifthere(input, func)
  return func(input or "")
end
local parts = { "HOST", "SCHEME", "USER", "PASSWORD", "PATH", "QUERY" }


function printTable(ns,tbl)
  for k,v in pairs(tbl) do
    print(ns.."["..k.."]="..v)
  end
end

for k,v in pairs(parts) do
  local decoded_val = parsed[parts[k]:lower()]
  if (decoded_val)
  then
    if (type(decoded_val) == "table") then
      printTable(v,decoded_val)
    else
      print(parts[k]..'='..decoded_val)
    end
  end

end

