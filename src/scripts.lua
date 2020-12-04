-- run scripts from /etc/epitome/scripts --

do
  local script_path = "/etc/epitome/scripts"
  local fs = require("filesystem")

  local files = fs.list(script_path)
  table.sort(files)
  for i=1, #files, 1 do
    log(34, files[i])
    local ok, err = pcall(dofile, script_path .. "/" .. files[i])  
    if not ok and err then
      io.write("\27[A\27[G")
      log(91, files[i].. ":" .. err)
      while true do coroutine.yield() end
    end
  end
end
