-- os API --

do
  local process = require("process")
  local computer = require("computer")

  function os.getenv(k)
    checkArg(1, k, "string", "number")
    return process.info().env[k]
  end

  function os.setenv(k, v)
    checkArg(1, k, "string", "number")
    checkArg(2, v, "string", "number", "nil")
    process.info().env[k] = v
    return true
  end

  -- XXX: Accuracy depends on the scheduler timeout.
  -- XXX: Shorter intervals (minimum 0.05s) will produce greater accuracy but
  -- XXX: will cause the computer to consume more energy.
  function os.sleep(n)
    checkArg(1, n, "number")
    local max = computer.uptime() + n
    repeat
      coroutine.yield()
    until computer.uptime() >= max
    return true
  end
end
