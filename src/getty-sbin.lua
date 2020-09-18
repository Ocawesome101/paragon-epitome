-- GETTY implementation --

local bgpu, bscr = ...

local vt100 = require("vt100")
local computer = require("computer")
local component = require("component")

local gpus, screens = {}, {}
do
  local w, h = component.invoke(bgpu, "maxResolution")
  gpus[bgpu] = {
    bound = bscr,
    res = w*h
  }
  screens[bscr] = {
    bound = bgpu,
    res = w*h
  }
end

local function scan(s, a, t)
  if t ~= "gpu" and t ~= "screen" then
    return nil
  end
  local dinfo = computer.getDeviceInfo()

  for addr, ctype in component.list() do
    if ctype == "gpu" then
    elseif ctype == "screen" then
    end
  end
end

event.register("component_added", scan)
event.register("component_removed", scan)

while true do
  coroutine.yield()
end
