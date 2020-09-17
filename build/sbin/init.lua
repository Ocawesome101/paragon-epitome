-- Epitome init system --

local log = k.io.dmesg
_G._IINFO = {
  name    = "Epitome",
  version = "0.1.0",
}

-- init logger --

log("INIT: src/logger.lua")
if k.io.gpu then
  local gpu = k.io.gpu
  local vts = k.vt.new(component.proxy(gpu.address))
  io.input(vts)
  io.output(vts)
  k.sched.getinfo():stderr(vts)
  vts:write("\27[2J\27[1;1H")
  function log(col, msg)
    if type(col) == "string" then
      msg = col
      col = 32
    end
    return io.write(string.format("\27[%dm* \27[97m%s\n", col + 60, msg))
  end
end

log(34, string.format("Welcome to \27[92m%s \27[97mversion \27[94m%s\27[97m", _IINFO.name, _IINFO.version))

-- some sort of basic FS utility api for things the io lib doesn't have --

log(34, "src/fs.lua")

do
  local vfs = k.vfs

  _G.fs = {}
  
  local function wrap(f)
    return function(p)
      checkArg(1, p, "string")
      local node, path = vfs.resolve(k)
      if not node then
        return nil, err
      end
    end
  end
end

-- package library --

do
  local package = {}
  local loaded = {
    _G = _G,
    os = os,
    io = io,
    math = math,
    table = table,
    bit32 = bit32,
    string = string,
    package = package,
    coroutine = coroutine
  }
  package.loaded = loaded

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
      if fs.exists(search) then
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
        log("INFO", "DELAYLOAD "..file..": "..tostring(key))
        return tbl[key]
      end
    }
    if lib.internal then
      setmetatable(lib.internal, mt)
    end
    setmetatable(lib, mt)
  end

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
end


-- load login --

log(34, "src/login.lua")
while true do coroutine.yield() end

