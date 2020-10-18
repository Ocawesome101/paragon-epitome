-- package library --

log("src/package.lua")

do
  io.write("\27[92m*\27[97m Setting up package API...")
  _G.package = {}
  local loading = {}
  local loaded = {
    _G = _G,
    os = os,
    io = io,
    math = math,
    table = table,
    bit32 = bit32,
    string = string,
    package = package,
    process = process,
    computer = computer,
    component = component,
    coroutine = coroutine,
    filesystem = fs
  }
  io.write("Uncluttering _G...")
  _G.fs = nil
  _G.process = nil
  _G.computer = nil
  _G.component = nil
  package.loaded = loaded

  package.path = "/lib/?.lua;/lib/lib?.lua;/lib/?/init.lua"

  function package.searchpath(name, path, sep, rep)
    checkArg(1, name, "string")
    checkArg(2, path, "string")
    checkArg(3, sep, "string", "nil")
    checkArg(4, rep, "string", "nil")
    sep = "%" .. (sep or ".")
    rep = rep or "/"
    local searched = {}
    name = name:gsub(sep, rep)
    for search in path:gmatch("[^;]+") do
      search = search:gsub("%?", name)
      if require("filesystem").exists(search) then
        return search
      end
      searched[#searched + 1] = search
    end
    return nil, searched
  end

  local rs = rawset
  local blacklist = {}
  do
    function _G.rawset(tbl, k, v)
      checkArg(1, tbl, "table")
      if blacklist[tbl] then
        tbl[k] = v
      end
      return rs(tbl, k, v)
    end
  end

  io.write("Library protection...")
  function package.protect(tbl, name)
    local new = setmetatable(tbl, {
      __newindex = function() error((name or "lib") .. " is read-only") end,
      __metatable = {}
    })
    blacklist[new] = true
    return new
  end

  function package.protect(tbl, name)
    local new = setmetatable(tbl, {
      __newindex = function() error((name or "lib") .. " is read-only") end,
      __metatable = {}
    })
    blacklist[new] = true
    return new
  end

  function package.delay(lib, file)
    local mt = {
      __index = function(tbl, key)
        setmetatable(lib, nil)
        setmetatable(lib.internal or {}, nil)
        dofile(file)
        return tbl[key]
      end
    }
    if lib.internal then
      setmetatable(lib.internal, mt)
    end
    setmetatable(lib, mt)
  end

  io.write("require()...")
  function _G.require(module)
    checkArg(1, module, "string")
    if loaded[module] ~= nil then
      return loaded[module]
    elseif not loading[module] then
      local library, status, step

      step, library, status = "not found", package.searchpath(module, package.path)

      if library then
        step, library, status = "loadfile failed", loadfile(library)
      end

      if library then
        loading[module] = true
        step, library, status = "load failed", pcall(library, module)
        loading[module] = false
      end
 
      assert(library, string.format("module '%s' %s:\n%s", module, step, status))
      loaded[module] = status
      return status
    else
      error("already loading: " .. module .. "\n" .. debug.traceback(), 2)
    end
  end

  io.write("Done.\n")
end

--#include "src/klapis.lua"
