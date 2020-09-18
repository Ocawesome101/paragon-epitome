-- GETTY implementation --

local bgpu, bscr = ...

local vt100 = require("vt100")
local computer = require("computer")
local component = require("component")

local gpus, screens, ttys = {}, {}, {}
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

local function get(t, n)
  local res = {}
  for k, v in pairs(t) do
    if not v.bound then
      res[v.res] = res[v.res] or v
    end
  end
  return res[n] or res[8000] or res[2000] or res[800]
end

local ttyn = 0
local function scan(s, a, t)
  if t ~= "gpu" and t ~= "screen" then
    return nil
  end
  local dinfo = computer.getDeviceInfo()

  for addr, ctype in component.list() do
    if ctype == "gpu" then
      gpus[addr] = gpus[addr] or {
        bound = false,
        res = tonumber(dinfo[addr].capacity)
      }
    elseif ctype == "screen" then
      screens[addr] = screens[addr] or {
        bound = false,
        res = tonumber(dinfo[addr].capacity)
      }
    end
  end
  
  for k, v in pairs(gpus) do
    if not dinfo[k] then
      screens[v.bound].bound = false
      gpus[k] = nil
    end
  end

  for k, v in pairs(screens) do
    if not dinfo[k] then
      gpus[v.bound].bound = false
      screens[k] = nil
    end
  end

  while true do
    local gpu, screen = get(gpus, 8000), get(screens, 8000)
    if not (gpu and screen) then
      break
    end
    local ios = vt100.new(gpu, screen)
    gpus[gpu].bound = ios
    gpus[screen].bound = ios
    ttys["tty"..ttyn] = {stream = ios, gpu = gpu, screen = screen}
  end
end

event.register("component_added", scan)
event.register("component_removed", scan)

while true do
  coroutine.yield()
end
