-- init logger --

log("INIT: src/logger.lua")
if k.io.gpu then
  local gpu = k.io.gpu
  local vts = k.tty.new(gpu)
  io.input(vts)
  io.output(vts)
  k.sched.getinfo():stderr(vts)
  local statii = {
    [31] = "FAIL",
    [32] = " OK ",
    [33] = "WARN",
    [34] = "INFO"
  }
  function log(col, msg)
    if type(col) == "string" then
      msg = col
      col = 32
    end
    return io.write(string.format("\27[39m[ \27[%dm%s \27[39m] %s", col, statii[col], msg))
  end
end

log(34, "Logger initialized")
