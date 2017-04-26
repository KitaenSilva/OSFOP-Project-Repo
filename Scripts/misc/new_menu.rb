# THESE ARE GIMMICKS FOR THE MENU SIMULATION

$HUNGER = 0.9

$THIRST = 0.95

$REST = 0.7

$MOOD = 0.8

#==============================================================================
#                                Menu Items
#------------------------------------------------------------------------------
# ▼ Scene_Menu
#------------------------------------------------------------------------------
# - This class performs the menu screen processing.
#------------------------------------------------------------------------------
class Scene_Menu < Scene_MenuBase

  def start
    super

    create_text_windows
    create_stat_window
    create_command_window
    create_logo

    create_location_window
    create_name_window
    create_cg
    bind_command_window
  end

  def create_text_windows
    @wt1 = Window_Text1.new
    @wt2 = Window_Text2.new
    @Lore = Window_Info.new
    @av = Info_avatar.new("niko_wew")

    @Lore.hook=@av

    @Lore.refresh

    @wt1.windowskin = Cache.system("Window_straight")
    @wt2.windowskin = Cache.system("Window_straight")
    @Lore.windowskin = Cache.system("Lore_window")
  end

  def create_stat_window
    @stat_window = Window_Stat.new
    @stat_window.windowskin = Cache.system("Window_straight")
  end

  def create_logo
    @lw = Window_Logo.new
    @lw.windowskin = Cache.system("Logo")
  end

  def create_command_window
    def command_item
      @actor = $game_party.members[0]
      SceneManager.call(Scene_Item)
    end

    def command_skill
      @actor = $game_party.members[0]
      SceneManager.call(Scene_Skill)
    end

    def command_equip
      @actor = $game_party.members[0]
      SceneManager.call(Scene_Equip)
    end

    def command_status
      @actor = $game_party.members[0]
      SceneManager.call(Scene_Status)
    end

    def command_save
      @actor = $game_party.members[0]
      SceneManager.call(Scene_Save)
    end

    def command_end
      @actor = $game_party.members[0]
      SceneManager.call(Scene_End)
    end

    @command_window = Window_MenuCommand.new
    @command_window.set_handler(:item,    method(:command_item))
    @command_window.set_handler(:skill,   method(:command_skill))
    @command_window.set_handler(:equip,   method(:command_equip))
    @command_window.set_handler(:status,  method(:command_status))
    @command_window.set_handler(:save,    method(:command_save))
    @command_window.set_handler(:end,     method(:command_end))
    @command_window.set_handler(:cancel,  method(:return_scene))
    @command_window.windowskin = Cache.system("Window_straight")
  end

  def create_location_window
    @map_window = Window_Location.new
    @map_window.windowskin = Cache.system("Window_straight")
  end

  def create_name_window
    @pro_window = Window_Name.new
    @pro_window.windowskin = Cache.system("Window_straight")
  end

  def create_cg
    @cg = Window_character_CG.new
    @cg.windowskin = Cache.system("Window_character_CG")
  end

  def bind_command_window
    @command_window.hook_info(@Lore)
  end

end

class Window_Text1 < Window_Base
  def initialize
    super(0, 0, 136, 48)
    refresh
  end

  def refresh
    self.contents.clear
    change_color(system_color)
    draw_text(0, 0, 115, line_height, "Commands:", 1)
  end
end

class Window_Text2 < Window_Base
  def initialize
    super(136, 0, 136, 48)
    refresh
  end

  def refresh
    self.contents.clear
    change_color(system_color)
    draw_text(0, 0, 115, line_height, "Stats:", 1)
  end
end

class Window_Info < Window_Base
  def initialize
    @line = 0
    super(0, 232, 272, 184)
    self.padding = 0
  end

  attr_accessor :hook

  def refresh
    self.contents.clear
    @av = hook
    change_color(system_color)
    contents.font.size = 16
    @av.visible = false
    #autowrap(("a"*31)+"\n"+("b"*31)+"\n"+("c"*31)+"\n"+("d"*31)+"\n"+("e"*38)+"\n"+("f"*38)+"\n"+("g"*38)+"\n"+("h"*38)+"\n"+("i"*38)+"\n"+("j"*38)+"\n"+("k"*38)+"\n"+("l"*38)+"\n"+("m"*38)+"\n"+("n"*38)+"\n"+("n"*38))
    #autowrap("")
  end

  def draw_line(text)
    draw_text(3, (@line * 12)-3, 300, line_height, text)
    @line += 1
  end

  def contents_width
    width
  end

  def contents_height
    height
  end

  def bind_avatar(av)
    @la
  end

  def autowrap(text)
    show(make(text))
  end

  def make(text)
    Text_generator.make(text, @av.visible)
  end

  def show(generatedtext)
    @line = 0
    generatedtext.each do |line|
      draw_line(line)
    end
  end

  def fullclean
    self.contents.clear
    avatar(false)
  end

  def clean
    self.contents.clear
  end

  def put(text)
    clean
    contents.font.size = 16
    autowrap(text)
  end

  def avatar(enable, av = "")
    if enable
      @av.visible = true
      face = av
      @av.draw(face)
    else
      @av.visible = false
    end
  end

end

module Text_generator
  def self.make(text, image)
    work = []
    @line = 0
    text.split("\n").each do |line|
      if image && @line < 4
        result = make_line(line, 31, " " * 7)
      else
        result = make_line(line, 38)
      end
      result.each do |newline|
        work.push(newline)
        @line += 1
      end
    end
    return work
  end

  def self.make_line(snippet, limit, append = "")
    temp = []
    currentline = ""
    snippet.split(" ").each do |word|
      work = currentline
      if !work.empty?
        work += " "
      end
      work += word
      if work.length > limit
        temp.push(append + currentline)
        currentline = word
      else
        currentline = work
      end
    end
    temp.push(append + currentline)
    return temp
  end
end

class Info_avatar < Window_Base
  def initialize(actorface)
    super(1, 233, 50, 50)
    @af = actorface
    self.padding = 1
    self.windowskin = Cache.system("Lore_avatar")
    draw
  end

  def draw(newface = "")
    if newface != ""
      @af = newface
    end
    self.contents.clear
    bitmap = Cache.face(@af)
    rect = Rect.new(0, 0, 96, 96)
    contents.stretch_blt(Rect.new(0, 0, 48, 48), bitmap, rect)
    bitmap.dispose
  end

  def contents_width
    width
  end

  def contents_height
    height
  end
end

class Window_Stat < Window_Base
  def initialize
    super(136, 48, 136, 184)
    refresh
  end

  def refresh
    self.contents.clear
    change_color(hp_gauge_color1)
    draw_actor_hunger(@actor, 0 , 0)
    draw_actor_thirst(@actor, 0 , 25)
    draw_actor_rest(@actor, 0 , 50)
    draw_actor_mood(@actor, 0 , 75)
  end

  def draw_actor_hunger(actor, x, y, width = 136)
    draw_gauge(x, y, 115, $HUNGER, hp_gauge_color1, hp_gauge_color2)
    change_color(normal_color)
    draw_text(5, y, 100, line_height, "Hunger")
  end

  def draw_actor_thirst(actor, x, y, width = 136)
    draw_gauge(x, y, 115, $THIRST, hp_gauge_color1, hp_gauge_color2)
    change_color(normal_color)
    draw_text(5, y, 100, line_height, "Thirst")
  end

  def draw_actor_rest(actor, x, y, width = 136)
    draw_gauge(x, y, 115, $REST, hp_gauge_color1, hp_gauge_color2)
    change_color(normal_color)
    draw_text(5, y, 100, line_height, "Rest")
  end

  def draw_actor_mood(actor, x, y, width = 136)
    draw_gauge(x, y, 115, $MOOD, hp_gauge_color1, hp_gauge_color2)
    change_color(normal_color)
    draw_text(5, y, 100, line_height, "Mood")
  end

end

class Window_Location < Window_Base
  def initialize
    super(272, 368, 272, 48)
    refresh
  end
  def refresh
    self.contents.clear
    @actor = $game_party.members[0]
    change_color(hp_gauge_color1)
    draw_text(0, 0, 250, line_height, "Location:")
    change_color(system_color)
    mapname = getmapname($data_mapinfos[$game_map.map_id].name)
    if mapname.length > 14
      contents.font.size = 16
    end
    draw_text(100, 0, 200, line_height, "#{mapname}")
  end
end

class Window_character_CG < Window_Base
  def initialize
    super(272, 48, 272, 320)
    self.padding = 0
    refresh
  end

  def refresh
    pic = Cache.picture("test_cg")
    contents.stretch_blt(Rect.new(0, 0, 272, 320), pic, pic.rect)
    pic.dispose
  end

  def contents_width
    width
  end

  def contents_height
    height
  end
end

class Window_Logo < Window_Base
  def initialize
    super(272, 0, 48, 48)
    self.padding = 0
    refresh
  end

  def refresh
    self.contents.clear
    @actor = $game_actors[1]
    if @actor.name.include?("Kit") || @actor.name.include?("entity")
      if @actor.name.include?("entity")
        draw_actor_graphic(@actor, 24, 46)
      else
        draw_actor_graphic(@actor, 24, 48)
      end
    else
      draw_actor_graphic(@actor, 24, 40)
    end
  end

  def contents_width
    width
  end

  def contents_height
    height
  end

end

class Window_Name < Window_Base
  def initialize
    super(320, 0, 224, 48)
    refresh
  end
  def refresh
    self.contents.clear
    @actor = $game_party.members[0]
    draw_text(0, 0, width, line_height, "Name:")
    draw_actor_name(@actor, 60, 0)
  end
end

class Window_MenuCommand < Window_Command
  def self.init_command_position
    @@last_command_symbol = nil
  end

  def initialize
    super(0, 48, true, 184)
    select_last
    resetclock
    @idle = Idlemanager.new
    @isidle = false
  end

  def window_width
    return 136
  end

  def visible_line_number
    6
  end

  def hook_info(window)
    @iw = window
    @idle.hook(window)
  end

  def make_command_list
    add_main_commands
  end

  def add_main_commands
    add_command("Inventory", :item, main_commands_enabled)
    add_command("Magic",      :skill,  false)
    add_command("Equipments", :equip,  main_commands_enabled)
    add_command("Status",     :status, main_commands_enabled)
    add_command("Save",       :save,   main_commands_enabled)
    add_command("Quit Game",  :end,    true)
  end

  def main_commands_enabled
    $game_party.exists
  end

  def formation_enabled
    $game_party.members.size >= 2 && !$game_system.formation_disabled
  end

  def process_ok
    @@last_command_symbol = current_symbol
    super
  end

  def select_last
    select_symbol(@@last_command_symbol)
    @I = getindex
  end

  #Inactivity functions, dont mind these


  def update
    super
    return unless @iw != nil
    if activity?
      resetclock
      stopidle
    elsif inactive? && !@isidle
      startidle
    elsif inactive? && @isidle
      @idle.update
    end

  end

  def inactive?
    (Time.now - 10) > @lastactivity
  end

  def resetclock
    @lastactivity = Time.now
  end

  def activity?
    if @I != getindex
      @I = getindex
      return true
    end
    return false
  end

  def stopidle
    @idle.stop
    @isidle = false
  end

  def startidle
    puts "starting idle..."
    @idle.start
    @isidle = true
  end

end

class Idlemanager
  def initialize
    @shouldinterval = false
  end

  def hook(window)
    @iw = window
  end

  def update
    if @shouldinterval
      if intervalactive?
        @shouldinterval = false
        puts "new dialogue"
        start
      end
      return
    end

    if @first
      @first = false
      @iw.avatar(true, @dl.currentavatar)
      @iw.put(@dl.currentline)
      puts "putting " + @dl.currentline
    elsif @dl.changed?
      if @dl.last?
        @dl.stop
        startinterval
        @iw.fullclean
      else
        @iw.avatar(true, @dl.currentavatar)
        @iw.put(@dl.currentline)
        puts "putting " + @dl.currentline
      end
    end
  end

  def startinterval
    @interval = Time.now
    @shouldinterval = true
  end

  def intervalactive?
    (Time.now - 10) > @interval
  end

  def start
    if @iw == nil
      raise "Idle window was started, but without a hooked info-window"
    end
    # this will usually follow with a random number generator and stuff, but we only have dialogue atm
    newdiag = Dialogue.newdialogue
    @dl = Dialoguetrail.new(newdiag)
    @dl.start
    @first = true
  end

  def stop
    if @dl != nil
      @dl.stop
      @dl = nil
    end
    @iw.fullclean
  end
end

if $game_actors != nil
  #for in-game refresh stuffz, dont worry about dis
  $game_actors[11].name, $game_actors[12].name = auto_size
  puts $game_actors[13].name.to_s
  $game_actors[13].name = []
  update_window_size
  load "Scripts/misc/idle_data.rb"
  load "Scripts/misc/1 - window_resize.rb"
end
