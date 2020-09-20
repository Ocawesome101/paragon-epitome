-- load getty --

log("src/getty.lua")

log("Starting getty")
local ok, err = loadfile("/sbin/getty.lua")

if not ok then
  log(31, "failed: ".. err)
else
  require("process").spawn(function()local s, r = pcall(ok, bgpu, bscr) if not s and r then log(31, "failed: "..r) end end, "[getty]")
end

require("event").push("init")
while true do coroutine.yield() end
