class Meta
  def self.query(querytext)
    createwindow = Win32API.new("user32", "CreateWindowEx", "lpplllllllll", "l")
    showwindow   = Win32API.new("user32", "ShowWindow", %w(l l), "l")

    ew = createwindow.call((0x00000100|0x00000200), "Edit", "Input", ((0x00800000)), 250, 250, 50, 75, 0, 0, 0, 0)
    showwindow.call(ew, 1)

    msgbox querytext

    getWindowText       = Win32API.new( "user32", "GetWindowText", "LPI", "I")
    getWindowTextLength = Win32API.new("user32", "GetWindowTextLength", "L", "I")
    showwindow.call(ew , 0)
    buf_len = getWindowTextLength.call(ew)
    str = " " * (buf_len + 1)
    # Retreive the text.
    getWindowText.call(ew , str, str.length)
      return str.delete("\000")
  end
end
