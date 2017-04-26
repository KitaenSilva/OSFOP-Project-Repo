# This file is what new_menu's idlemanager hooks into

$dummydata = [
  [
    {:messageUUID => 999},
    [
      ["niko_pancakes", "And i will have so many pancakes!"],
      ["kit_frown", "Yes, but we have to gather all the ingredients first."],
      ["niko", "Oh yeah..."],
      ["alula_gasp", "Doesn't matter, it will be the best pancakes ever!"]
    ], true
  ],
  [
    {:messageUUID => 1234},
    [
      ["niko_pancakes", "And i will have so many pancakes!"],
      ["kit_frown", "Yes, but we have to gather all the ingredients first."],
      ["niko", "Oh yeah..."],
      ["alula_gasp", "Doesn't matter, it will be the best pancakes ever!"]
    ], true
  ]
]

$DIALOGUE =
[
  [
    {:messageUUID => 999},
    [
      ["alula", "Hey, entity, how is it being a robot?"],
      ["amentity2", "First off, i'm not entity, i'm \"Amentity\", there's a difference."],
      ["amentity_smile", "Second off, it's actually pretty good, now that we're on our way to saving the world, life's pretty good so far."],
      ["alula_gasp", "So... that means you wanna taste a speciality of mine the next time we stop?"],
      ["amentity_shame", "Uuuh... I never said that..."],
      ["amentity_83c", "But sure, why not?"]
    ], false
  ],
  [
    {:messageUUID => 420},
      [
        ["rue_pchoo", "I haz become lazor."]
      ], true
  ]
]

module Dialogue

  def self.newdialogue
    approved = []
    $DIALOGUE.each do |val|
      if !Dialogue.disabled?(val[0][:messageUUID])
        approved.push(val)
      end
    end
    return approved.sample
  end

  def self.disable(*vals)
    vals.each do |val|
      $game_actors[13].name.push(val)
      puts "Disabled " + val.to_s
    end
  end

  def self.disabled?(val)
      #can be heavily modified
    $game_actors[13].name.each do |check|
      if check == val
        return true
      end
    end
    return false
  end
end

class Dialoguetrail
  def initialize(data)
    @UUID = data[0][:messageUUID]
    @DataTrail = data[1]
    @special = data[2]
    print data
    print "\n"
    return self
  end

=begin
  example of "data":

  [
    {:messageUUID => 1234},
    [
      ["niko_pancakes", "And i will have so many pancakes!"],
      ["kit_frown", "Yes, but we have to gather all the ingredients first."],
      ["niko", "Oh yeah..."],
      ["alula_gasp", "Doesn't matter, it will be the best pancakes ever!"]
    ], true
  ]
=end

  def start
    resetclock
    @index = 0
  end

  def resetclock
    @lastactivity = Time.now
  end

  def stop
    if @special && last?
      Dialogue.disable(@UUID)
    end
  end

  def last?
    if changed?
      resetclock
      @index = @index + 1
    end
    return @DataTrail.length <= @index
  end

  def changed?
    if @DataTrail[@index] != nil && @DataTrail[@index].length > 2
      (Time.now - @DataTrail[@index][2]) > @lastactivity
    else
      (Time.now - 5) > @lastactivity
    end
  end

  def currentline
    return @DataTrail[@index][1]
  end

  def currentavatar
    return @DataTrail[@index][0]
  end

end
