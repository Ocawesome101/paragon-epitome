-- services --

do
  local process = require("process")
  local running = {}

  local svc = {}
  local path = "/etc/services.d/"

  local function full(p)
    return string.format("%s%s.lua", path, s)
  end

  function svc.start(s)
    if running[s] and process.info(running[s]) then
      return true
    end
    local full = full(s)
    local ok, err = loadfile(full)
    if not ok then
      return nil, err
    end
    local pid = process.spawn(ok, "["..s.."]")
    running[s] = pid
    return true
  end

  function svc.stop(s)
    if not running[s] then
      return true
    end
    process.signal(running[s], process.signals.SIGTERM)
    running[s] = nil
    return true
  end
  
  function svc.running()
    return table.copy(running)
  end

  package.loaded.svc = svc
end
