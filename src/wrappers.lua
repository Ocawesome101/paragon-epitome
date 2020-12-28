-- wrappers 

do
  local __shutdown = computer.shutdown
  function computer.shutdown()
    computer.runlevel(0)
    __shutdown()
  end
end
