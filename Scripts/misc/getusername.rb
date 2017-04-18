def getusername
  require "Win32API"

  name = " " * 128
  size = "128"

  Win32API.new("Secur32.dll", "GetUserNameEx", ["I", "P", "P"], "I").call(3, name, size)

  return name.unpack("A*")[0].split(" ")[0].capitalize
end
