-- build the whole thing

local function mk()
  local prg = p()
  log(prg, "Building Epitome")
  local preproc = require("lib.preproc")
  preproc("src/init.lua", "build/sbin/init.lua")
  log(prg, "Done.")
end

table.insert(build, mk)
