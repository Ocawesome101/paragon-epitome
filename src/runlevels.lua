-- run levels

do
  local fs = require("filesystem")
  local computer = require("computer")
  local component = require("component")
  log(34, "Bringing up run level support")
  local _DEFAULT = @[{CONFIG.runlevel or 3}]
  --[[ Here's how run levels work under Epitome:
       
        - /etc/rc.d contains 7 subdirectories - one per runlevel.
        - These directories are named 0 through 6.
        - Each directory should contain a set of scripts to be executed
          in order when the corresponding run level is hit.
            ->  In a true sysV init, we'd jump straight to the default runlevel.
                However, this requires more complexity.
        - This leads to a directory structure similar to the following:
          /etc
            \- rc.d
               |- 0
               |  \- 00_shutdown.lua
               |- 1
               |  |- 00_base.lua
               |  |- 10_package.lua
               |  \- 99_single_user_mode.lua
               |- 2
               |  \- 00_services.lua
               |- 3
               |  |- 00_base.lua
               |  |- 10_net_minitel.lua
               |  \- 20_net_gert.lua
               |- ...
              ...
  ]]

  -- the current system runlevel
  local runlevel = 1

  local function run_all(rlvl)
    log(92, "Executing runlevel: "..rlvl)
    local base = string.format("/etc/rc.d/%d/", rlvl)
    local files = fs.list(base)
    table.sort(files)
    for i=1, #files, 1 do
      log(94, base .. files[i])
      local ok, err = pcall(dofile, base .. files[i])
      if not ok and err then
        log(91, "ERROR: " .. tostring(err))
      end
    end
    runlevel = rlvl
  end

  log(92, "Bringing system to runlevel ".._DEFAULT)
  for i=1, _DEFAULT, 1 do
    run_all(i)
  end

  function computer.runlevel(n)
    if n and os.getenv("UID") ~= 0 then
      return nil, "only root can do that"
    end
    if n and n < runlevel then
      if n > 0 then
        return nil, "cannot reduce system runlevel"
      end
      run_all(0)
    end
    if n then
      for i=runlevel, n, 1 do
        run_all(i)
      end
    end
    return runlevel
  end
end
