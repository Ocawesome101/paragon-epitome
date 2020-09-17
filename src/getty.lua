-- load getty --

log("src/getty.lua")

log("starting getty")
local ok, err = loadfile("/sbin/getty.lua")

if not ok then
  log(31, "failed: ".. err)
else
  process.spawn(ok, "[getty]")
end

while true do coroutine.yield() end
