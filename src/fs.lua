-- some sort of basic FS utility api for things the io lib doesn't have --

log("src/fs.lua")

do
  local vfs = k.vfs

  _G.fs = {}

  local funcs = {
    'list',
    'makeDirectory',
    'isDirectory',
    'remove',
    'exists',
    'spaceUsed',
    'spaceTotal',
    'isReadOnly'
  }
  
  local function wrap(f, b)
    return function(p)
      checkArg(1, p, "string", b and "nil")
      p = p or "/"
      local node, path = vfs.resolve(p)
      if not node then
        return nil, err
      end
      return node[f](node, path)
    end
  end

  for k, v in pairs(funcs) do
    fs[v] = wrap(v, k >= #funcs - 3)
  end
end
