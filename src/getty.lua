-- load getty --

log("src/getty.lua")

log("Initializing components")
do
  local component = require("component")
  for k,v in component.list() do
    require("computer").pushSignal("component_added", k, v)
  end
end

log("Starting getty")
local pids = {}
do
  local pty = require("pty")
  local function start_getty(stdio)
    local ok, err = loadfile("/sbin/getty.lua")
  
    if not ok then
      log(31, "failed: ".. err)
    else
      local pid = require("process").spawn(
        function()
          io.input(stdio)
          io.output(stdio)
          io.stdin = stdio
          io.stdout = stdio
          io.stderr = stdio
          local s, r = pcall(ok)
          if not s and r then
            log(31, "failed: "..r)
          end
        end, "[getty]")
     end
     pids[#pids+1]=pid
  end

  for stream in pty.streams() do
    start_getty(stream)
  end
end

require("event").push("init")
while true do
  local e = table.pack(coroutine.yield())
  if e[1]=="process_died" then
    io.stderr:write(tostring(e[4]),"\n")
  end
end
