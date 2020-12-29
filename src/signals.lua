-- signal handling --

do
  local process = require("process")
  process.sethandler(process.signals.SIGTERM, function()end)
  process.sethandler(process.signals.SIGKILL, function()end)
end
