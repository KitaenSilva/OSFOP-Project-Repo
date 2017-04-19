def lib_get(get)
  load "scripts/lib/" + get + ".rb"
end

class Akiniator

  def initialize
    @URL = "api-en4.akinator.com"
    @SESS = nil
    @SIGNATURE = nil
    @STEP = 0
    @Currentanswers = []
    hello
  end

  def parse_questions
    temp = []
    @Currentanswers.each_index { |index|
      temp << [index, @Currentanswers.at(index)["answer"]]
    }
    return temp
  end

  def gaindata(data)
    @STEP = data["parameters"]["step"]
    @Currentanswers = data["parameters"]["answers"]
  end

  def hello
    data = JSON.decode EFE.request(@URL, "/ws/new_session?partner=1")
    @SESS = data["parameters"]["identification"]["session"]
    gaindata(data)
    @SIGNATURE = data["parameters"]["identification"]["signature"]
    @STEP = data["parameters"]["step_information"]["step"]
    @Currentanswers = data["parameters"]["step_information"]["answers"]
    puts @SESS
    puts @SIGNATURE
  end

  def sendanswer(index)
    data = JSON.decode EFE.request(@URL, "/ws/answer?session=#{@SESS}&signature=#{@SIGNATURE}&step=#{@STEP}&answer=#{index}")
    gaindata(data)
  end
end
