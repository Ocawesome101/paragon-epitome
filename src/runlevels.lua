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

  local function run_all(rlvl)
    local full = string.format("/etc/rc.d/%d/", rlvl)
    local files = fs.list(full)
  end

  for i=0, _DEFAULT, 1 do
  end
end
