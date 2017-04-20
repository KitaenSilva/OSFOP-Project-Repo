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
    @Question = ""
    @Progress = 0
    @haserr = false
    hello
  end

  def get_answers
    temp = []
    @Currentanswers.each_index { |index|
      temp << [index, @Currentanswers.at(index)["answer"]]
    }
    return temp
  end

  def get_question
    @Question
  end

  def progression
    @Progress
  end

  def gaindata(data)
    @haserr =  data["completion"] != "OK"
    if !@haserr
      @STEP = data["parameters"]["step"]
      @Currentanswers = data["parameters"]["answers"]
      @Question = data["parameters"]["question"]
      @Progress = data["parameters"]["progression"].to_f
    end
  end

  def hello
    data = JSON.decode EFE.request(@URL, "/ws/new_session?partner=1")
    @SESS = data["parameters"]["identification"]["session"]
    gaindata(data)
    @SIGNATURE = data["parameters"]["identification"]["signature"]
    @STEP = data["parameters"]["step_information"]["step"]
    @Currentanswers = data["parameters"]["step_information"]["answers"]
    @Question = data["parameters"]["step_information"]["question"]
  end

  def sendanswer(index)
    data = JSON.decode EFE.request(@URL, "/ws/answer?session=#{@SESS}&signature=#{@SIGNATURE}&step=#{@STEP}&answer=#{index}")
    gaindata(data)
  end

  def whoisit
    data = JSON.decode EFE.request(@URL, "/ws/list?session=#{@SESS}&signature=#{@SIGNATURE}&step=#{@STEP}")
    if data["completion"] != "OK"
      return "ERR"
    else
      return data["parameters"]["elements"][0]["element"]["name"]
    end
  end
end
