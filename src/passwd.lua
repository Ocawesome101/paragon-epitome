-- prime the users API with data from /etc/passwd --

log("src/passwd.lua")

do
  log("Loading data from /etc/passwd")
  -- uid:password:username:home:shell
  local format = "(%d+):(%g+):(%g+):(%g+):(%g+)"
  local handle, err = io.open("/etc/passwd", "r")
  if not handle then
    log(31, "failed: " .. err)
    while true do coroutine.yield() end
  end
  local data = handle:read("a")
  handle:close()
  local pwdata = {}
  for line in data:gmatch("[^\n]+") do
    local uid, hash, name, home, shell = line:match(format)
    pwdata[tonumber(uid)] = {
      hash = hash,
      name = name,
      home = home,
      shell = shell
    }
  end
  log("Priming users API")
  k.security.users.prime(pwdata)
end
