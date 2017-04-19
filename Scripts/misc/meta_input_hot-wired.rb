# THIS CODE ONLY WORKS IN WINDOWS AND IS NOT INTENDED FOR CROSS-PLATFORM USE (yet)

if Win32API != nil
  SWPO = Win32API.new "user32", "SetWindowPos", ["l", "i", "i", "i", "i", "i", "p"], "i"
  WINX = Win32API.new "user32", "FindWindowEx", ["l", "l", "p", "p"], "i"
  SMET = Win32API.new "user32", "GetSystemMetrics", ["i"], "i"
  GWRF = Win32API.new "user32", "GetWindowRect", ["i", "p"], "i"
  MOVW = Win32API.new "user32", "MoveWindow", ["l", "i", "i", "i", "i", "i"], "i"

  SELF_WINDOW = WINX.call(0, 0, "RGSS Player", 0)
    # SELF_WINDOW = WINX.call(0,0,0,"Start Command Prompt With Ruby - irb")

  RECT = [0, 0, 0, 0]
end


module Meta
  def self.query(querytext, caps = false)
    if Win32API == nil
      msgbox "ERROR NO WINAPI"
      return ""
    end
    createwindow = Win32API.new("user32", "CreateWindowEx", "lpplllllllll", "l")
    showwindow   = Win32API.new("user32", "ShowWindow", %w(l l), "l")

    inputwidth, inputheight = 100, 100

    xy = self.getwpos

    x = (xy[0] + (Graphics.width/2)) - (inputwidth/2) - 16
    y = (xy[1] + (Graphics.height)) - (inputheight) - 8

    ew = createwindow.call((0x00000100|0x00000200|0x00000008), "Edit", "", ((0x00800000)), x, y, inputwidth, inputheight, 0, 0, 0, 0)
    showwindow.call(ew, 1)

    msgbox querytext

    getWindowText       = Win32API.new( "user32", "GetWindowText", "LPI", "I")
    getWindowTextLength = Win32API.new("user32", "GetWindowTextLength", "L", "I")
    showwindow.call(ew , 0)
    buf_len = getWindowTextLength.call(ew)
    str = " " * (buf_len + 1)
      # Retreive the text.
    getWindowText.call(ew , str, str.length)
    str = str.delete("\000")
    if caps
      str.upcase!
    end
    return str
  end
  def self.getwpos
    if Win32API == nil
      msgbox "ERROR NO WINAPI"
      return 0, 0
    end
    r = RECT.pack("llll")
    GWRF.call(SELF_WINDOW, r)
    full = r.unpack("llll")
    full[0] = full[0] + 8
    full[1] = full[1] + 8
    full[0, 2]
  end
  def self.move(dx, dy)
    if Win32API == nil
      msgbox "ERROR NO WINAPI"
      return
    end
    resw = SMET.call(0)
    resh = SMET.call(1)
    width = Graphics.width + ((SMET.call(5) + SMET.call(45)) * 2)
    height = (SMET.call(6) + SMET.call(45)) * 2 + SMET.call(4) + Graphics.height
    p = self.getwpos
    x = p[0]-8; y = p[1]-8
    y = 0 if y < 0;x = 0 if x < 0
    MOVW.call(SELF_WINDOW, x+dx, y+dy, width, height, 0)
  end
  def self.movetocoords(x, y)
    if Win32API == nil
      msgbox "ERROR NO WINAPI"
      return
    end
    width = Graphics.width + ((SMET.call(5) + SMET.call(45)) * 2)
    height = (SMET.call(6) + SMET.call(45)) * 2 + SMET.call(4) + Graphics.height
    MOVW.call(SELF_WINDOW, x-8, y-8, width, height, 0)
  end
  def self.ree(amount)
    amount.times do |i|
      $Schedule_buffer[:shift] << Schedule_function.new("winmov", [5, 5])
      $Schedule_buffer[:shift] << Schedule_function.new("winmov", [-10, -10])
      $Schedule_buffer[:shift] << Schedule_function.new("winmov", [0, 10])
      $Schedule_buffer[:shift] << Schedule_function.new("winmov", [10, -10])
      $Schedule_buffer[:shift] << Schedule_function.new("winmov", [-5, 5])
    end
  end
  def self.shake(shakestuffz)
    if (shakestuffz[2] >= shakestuffz[1]) && shakestuffz[1] != -1
      $AllDoTheHarlemShake = false
      self.movetocoords(shakestuffz[3][0], shakestuffz[3][1])
      return
    end
    r = Random.new
    xtens = r.rand(shakestuffz[0])
    ytens = r.rand(shakestuffz[0])
    xtens = xtens * -1 if r.rand(2) == 1; ytens = ytens * -1 if r.rand(2) == 1
    self.movetocoords(xtens + shakestuffz[3][0], ytens + shakestuffz[3][1])
    $ShakeMusic[2] += 1
  end
  def self.startshake(intensity, amount)
    $ShakeMusic = [intensity, amount, 0, self.getwpos]
    $AllDoTheHarlemShake = true
  end
  def self.stopshake
    $AllDoTheHarlemShake = false
    self.movetocoords($ShakeMusic[3][0], $ShakeMusic[3][1])
  end
  def self.grablocation()
    req = EFE.request("ip-api.com", "/json")
    puts req
    if req != nil
      res = JSON.decode(req)
      puts res
      puts res["status"]
      if res["status"] == "success"
        if res["country"] == "United States"
          $location = res["regionName"]
        else
          $location = res["country"]
        end
      else
        $location = "earth"
      end
    else
      $location = "earth"
    end
    return $location
  end
end

Schedule_function = Struct.new(:type, :vars)
$Schedule_buffer = { :shift => [], :full => [] }
$AllDoTheHarlemShake = false
$ShakeMusic = [0, 0, 0, [0, 0]] #intensity, shaking amount, shakes done, original coords, opt(shaketype, extrainfo)

module Schedule
  def self.run
    if !$Schedule_buffer[:shift].empty?
      task = $Schedule_buffer[:shift].shift
      case task[:type]
      when "winmov"
        Meta.move(task[:vars][0], task[:vars][1])
      end
    end
    if !$Schedule_buffer[:full].empty?
      i = 0
      fi = $Schedule_buffer[:full].length
      while i < fi
        task = $Schedule_buffer[:full].shift
          #case task[:type]
              # nothing yet
          #end
        i += 1
      end
    end
    if $AllDoTheHarlemShake
      Meta.shake($ShakeMusic)
    end
  end
end
