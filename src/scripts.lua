-- run scripts from /etc/epitome/scripts --

do
  local script_path = "/etc/epitome/scripts"
  local fs = require("filesystem")

  local files = fs.list(script_path)
  table.sort(files)
  for i=1, #files, 1 do
  end
end
