-- init logger --

log("INIT: src/logger.lua")
io.write("\27[39;49m\27[2J\27[1;1H")
function log(col, msg)
  if type(col) == "string" then
    msg = col
    col = 32
  end
  return io.write(string.format("\27[%dm* \27[97m%s\n", col + 60, msg))
end
k.io.hide()

log(34, string.format("Welcome to \27[92m%s \27[97mversion \27[94m%s\27[97m", _INFO.name, _INFO.version))
