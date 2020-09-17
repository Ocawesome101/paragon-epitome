-- some sort of basic FS utility api for things the io lib doesn't have --

log("")

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
