#===============================================================================
# JSON Encoder/Decoder
# Version 1.1
# Author: game_guy
#-------------------------------------------------------------------------------
# Intro:
# JSON (JavaScript Object Notation) is a lightweight data-interchange
# format. It is easy for humans to read and write. It is easy for machines to
# parse and generate.
# This is a simple JSON Parser or Decoder. It'll take JSON thats been
# formatted into a string and decode it into the proper object.
# This script can also encode certain ruby objects into JSON.
#
# Features:
# Decodes JSON format into ruby strings, arrays, hashes, integers, booleans.
#
# Instructions:
# This is a scripters utility. To decode JSON data, call
# JSON.decode("json string")
# -Depending on "json string", this method can return any of the values:
#  -Integer
#  -String
#  -Boolean
#  -Hash
#  -Array
#  -Nil
#
# To Encode objects, use
# JSON.encode(object)
# -This will return a string with JSON. Object can be any one of the following
#  -Integer
#  -String
#  -Boolean
#  -Hash
#  -Array
#  -Nil
#
# Credits:
# game_guy ~ Creating it.
#===============================================================================
module JSON

  TOKEN_NONE = 0;
  TOKEN_CURLY_OPEN = 1;
  TOKEN_CURLY_CLOSED = 2;
  TOKEN_SQUARED_OPEN = 3;
  TOKEN_SQUARED_CLOSED = 4;
  TOKEN_COLON = 5;
  TOKEN_COMMA = 6;
  TOKEN_STRING = 7;
  TOKEN_NUMBER = 8;
  TOKEN_TRUE = 9;
  TOKEN_FALSE = 10;
  TOKEN_NULL = 11;

  @index = 0
  @json = ""
  @length = 0

  def self.decode(json)
    @json = json
    @index = 0
    @length = @json.length
    return self.parse
  end

  def self.encode(obj)
    if obj.is_a?(Hash)
      return self.encode_hash(obj)
    elsif obj.is_a?(Array)
      return self.encode_array(obj)
    elsif obj.is_a?(Fixnum) || obj.is_a?(Float)
      return self.encode_integer(obj)
    elsif obj.is_a?(String)
      return self.encode_string(obj)
    elsif obj.is_a?(TrueClass) || obj.is_a?(FalseClass)
      return self.encode_bool(obj)
    elsif obj.is_a?(NilClass)
      return "null"
    end
    return nil
  end

  def self.encode_hash(hash)
    string = "{"
    hash.each_key {|key|
      string += "\"#{key}\":" + self.encode(hash[key]).to_s + ","
    }
    string[string.size - 1, 1] = "}"
    return string
  end

  def self.encode_array(array)
    string = "["
    array.each {|i|
      string += self.encode(i).to_s + ","
    }
    string[string.size - 1, 1] = "]"
    return string
  end

  def self.encode_string(string)
    return "\"#{string}\""
  end

  def self.encode_integer(int)
    return int.to_s
  end

  def self.encode_bool(bool)
    return (bool.is_a?(TrueClass) ? "true" : "false")
  end

  def self.next_token(debug = 0)
    char = @json[@index, 1]
    @index += 1
    case char
    when "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-"
      return TOKEN_NUMBER
    when "{"
      return TOKEN_CURLY_OPEN
    when "}"
      return TOKEN_CURLY_CLOSED
    when '"'
      return TOKEN_STRING
    when ","
      return TOKEN_COMMA
    when "["
      return TOKEN_SQUARED_OPEN
    when "]"
      return TOKEN_SQUARED_CLOSED
    when ":"
      return TOKEN_COLON
    end
    @index -= 1
    if @json[@index, 5] == "false"
      @index += 5
      return TOKEN_FALSE
    elsif @json[@index, 4] == "true"
      @index += 4
      return TOKEN_TRUE
    elsif @json[@index, 4] == "null"
      @index += 4
      return TOKEN_NULL
    end
    return TOKEN_NONE
  end

  def self.parse(debug = 0)
    complete = false
    while !complete
      if @index >= @length
        break
      end
      token = self.next_token
      case token
      when TOKEN_NONE
        return nil
      when TOKEN_NUMBER
        return self.parse_number
      when TOKEN_CURLY_OPEN
        return self.parse_object
      when TOKEN_STRING
        return self.parse_string
      when TOKEN_SQUARED_OPEN
        return self.parse_array
      when TOKEN_TRUE
        return true
      when TOKEN_FALSE
        return false
      when TOKEN_NULL
        return nil
      end
    end
  end

  def self.parse_object
    obj = {}
    complete = false
    while !complete
      token = self.next_token
      if token == TOKEN_CURLY_CLOSED
        complete = true
        break
      elsif token == TOKEN_NONE
        return nil
      elsif token == TOKEN_COMMA
      else
        name = self.parse_string
        return nil if name == nil
        token = self.next_token
        return nil if token != TOKEN_COLON
        value = self.parse
        obj[name] = value
      end
    end
    return obj
  end

  def self.parse_string
    complete = false
    string = ""
    while !complete
      break if @index >= @length
      char = @json[@index, 1]
      @index += 1
      case char
      when '"'
        complete = true
        break
      else
        string += char.to_s
      end
    end
    if !complete
      return nil
    end
    return string
  end

  def self.parse_number
    @index -= 1
    negative = @json[@index, 1] == "-" ? true : false
    string = ""
    complete = false
    while !complete
      break if @index >= @length
      char = @json[@index, 1]
      @index += 1
      case char
      when "{", "}", ":", ",", "[", "]"
        @index -= 1
        complete = true
        break
      when "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
        string += char.to_s
      end
    end
    return string.to_i
  end

  def self.parse_array
    obj = []
    complete = false
    while !complete
      token = self.next_token(1)
      if token == TOKEN_SQUARED_CLOSED
        complete = true
        break
      elsif token == TOKEN_NONE
        return nil
      elsif token == TOKEN_COMMA
      else
        @index -= 1
        value = self.parse
        obj.push(value)
      end
    end
    return obj
  end
end

=begin
===============================================================================
 EFE's Request Script
 Version: RGSS & RGSS2 & RGSS3
 Special thanks : Ryex, Gustavo Bicalho, Kubiwa Taicho
===============================================================================
 This script will allow to request to some servers WITHOUT posting.(Only GET)
--------------------------------------------------------------------------------
Used WINAPI functions:

WinHTTPOpen
WinnHTTLConnect
WinHTTPOpenRequest
WinHTTPSendRequest
WinHTTPReceiveResponse
WinHttpQueryDataAvailable
WinHttpReadData

Call:

EFE.request(host, path, post, port)

host : "www.rpgmakervxace.net" (without http:// prefix)
path : "/forum/login.php" ( the directory path of your php file )
post : "username=kfdsfdsl&password=24324234"
port : 80 is default.

=end

module EFE

  # I took this method from Gustavo Bicalho's WebKit script. Special thanks him.
  def self.to_ws(str)
    str = str.to_s();
    wstr = "";
    for i in 0..str.size
      wstr += str[i, 1]+"\0";
    end
    wstr += "\0";
    return wstr;
  end



  #EFES_WINAPI = Win32API.new('ods', 'naber', 'pp', 'p')
  WinHttpOpen = Win32API.new("winhttp", "WinHttpOpen", "PIPPI", "I")
  WinHttpConnect = Win32API.new("winhttp", "WinHttpConnect", "PPII", "I")
  WinHttpOpenRequest = Win32API.new("winhttp", "WinHttpOpenRequest", "PPPPPII", "I")
  WinHttpSendRequest = Win32API.new("winhttp", "WinHttpSendRequest", "PIIIIII", "I")
  WinHttpReceiveResponse = Win32API.new("winhttp", "WinHttpReceiveResponse", "PP", "I")
  WinHttpQueryDataAvailable = Win32API.new("winhttp", "WinHttpQueryDataAvailable", "PI", "I")
  WinHttpReadData = Win32API.new("winhttp", "WinHttpReadData", "PPIP", "I")
  #WinHttpWriteData = Win32API.new('winhttp','WinHttpWriteData',"PPIP",'I')

=begin
  def self.request2(host, path, post="")
    pr = path
    if(post != "")
      pr = pr + "?" + post
    end
    pr = pr.to_s
    a = EFES_WINAPI.call(to_ws(host), to_ws(pr))
    return a
  end
=end

  def self.request(host, path, post="", port=80)
    p = path
    if(post != "")
      p = p + "?" + post
    end
    p = p.to_s
    pwszUserAgent = ""
    pwszProxyName = ""
    pwszProxyBypass = ""
    httpOpen = WinHttpOpen.call(pwszUserAgent, 0, pwszProxyName, pwszProxyBypass, 0)
    if httpOpen
      httpConnect = WinHttpConnect.call(httpOpen, to_ws(host), port, 0)
      if httpConnect
        httpOpenR = WinHttpOpenRequest.call(httpConnect, nil, to_ws(p), "", "", 0, 0)
        if httpOpenR
          httpSendR = WinHttpSendRequest.call(httpOpenR, 0, 0 , 0, 0, 0, 0)
          if httpSendR
            httpReceiveR = WinHttpReceiveResponse.call(httpOpenR, nil)
            if httpReceiveR
              received = 0
              httpAvailable = WinHttpQueryDataAvailable.call(httpOpenR, received)
              if httpAvailable
                ali = " "*1024
                n = 0
                httpRead = WinHttpReadData.call(httpOpenR, ali, 1024, o=[n].pack("i!"))
                n=o.unpack("i!")[0]
                return ali[0, n]
              else
                return "Error about query data available"
              end
            else
              return "Error when receiving response"
            end
          else
            return "Error when sending request"
          end

        else
          return "Error when opening request"
        end

      else
        return "Error when connecting to the host"
      end

    else
      return "Error when opening connection"
    end
  end
end
