-- copy getty and login --

mkdir("build/bin")
mkdir("build/sbin")

local function copy()
  local prg = p()
  log(prg, "copying static files to build")
  cp("src/getty-sbin.lua", "build/sbin/getty.lua")
end

table.insert(build, copy)
