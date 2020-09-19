-- kernel-provided APIs, userspace edition --

log("src/klapis.lua")
do
  io.write("\27[92m*\27[97m Adding kernel APIs....")
  local k = k
  _G.k = nil
  package.loaded.sha3 = k.sha3
  package.loaded.sha2 = k.sha2
  package.loaded.ec25519 = k.ec25519
  package.loaded.uuid = k.uuid
  package.loaded.minitel = k.drv.net.minitel
  package.loaded.gert = k.drv.net.gert
  package.loaded.event = k.evt
  package.loaded.vt100 = k.tty
  io.write("Done.\n")
end
