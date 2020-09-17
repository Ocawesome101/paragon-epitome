-- init logger --

log("INIT: src/logger.lua")
if k.io.gpu then
  local gpu = k.io.gpu
  local vts = k.vt.new(component.proxy(gpu.address))
  io.input(vts)
  io.output(vts)
  k.sched.getinfo():stderr(vts)
  vts:write("\27[2J\27[1;1H")
  function log(col, msg)
    if type(col) == "string" then
      msg = col
      col = 32
    end
    return io.write(string.format("\27[%dm* \27[97m%s\n", col + 60, msg))
  end
end

log(34, string.format("Welcome to \27[92m%s \27[97mversion \27[94m%s\27[97m", _IINFO.name, _IINFO.version))
