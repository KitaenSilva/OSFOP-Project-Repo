def getusername
  name = " " * 128
  size = "128"

  Win32API.new("Secur32.dll", "GetUserNameEx", ["I", "P", "P"], "I").call(3, name, size)
  if name.unpack("A*")[0] == ""
    Win32API.new("Advapi32.dll", "GetUserName", [ "P", "P"], "I").call(name, size)
    return name.unpack("A*")[0].split(" ")[0].capitalize
  else
    return name.unpack("A*")[0].split(" ")[0].capitalize
  end
end
