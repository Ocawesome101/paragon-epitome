-- load getty --

log("src/getty.lua")

log("Starting getty")
local ok, err = loadfile("/sbin/getty.lua")

if not ok then
  log(31, "failed: ".. err)
else
  require("process").spawn(function()ok(bgpu, bscr)end, "[getty]")
end

require("event").push("init")
while true do coroutine.yield() end
