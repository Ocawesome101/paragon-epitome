-- optional module selection

local function select_mod()
  local amods = ls("src/opt")
  local prg = p()
  log(prg, "Select optional modules")
  local mods
  if CONFIG.all_modules then
    mods = amods
  else
    mods = menu(amods)
  end

  for k,v in pairs(mods) do
    log(prg, "Adding nodule:", v)
    for kk, vv in pairs(CONFIG.modules) do
      if v ~= vv then
        table.insert(CONFIG.modules, v)
        goto cont
      end
    end
    ::cont::
  end
end

local function add_mod()
  local file = io.open("tmp/mods.lua", "w")
  local prg = p()
  log(prg, "Adding optional modules")
  for k,v in pairs(CONFIG.modules) do
    local ln = string.format("--#include \"src/opt/%s\"", v)
    log(prg, ln)
    file:write(ln.."\n")
  end
  file:close()
end

table.insert(build, select_mod)
table.insert(build, add_mod)
