-- wrappers 

do
  computer.__shutdown = computer.shutdown
  function computer.shutdown()
    computer.runlevel(0)
  end
end
