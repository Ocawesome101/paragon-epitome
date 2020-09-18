-- kernel-provided APIs, userspace edition --

log("src/klapis.lua")
do
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
end
