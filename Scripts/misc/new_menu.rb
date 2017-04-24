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
  end

  def create_text_windows
    @wt1 = Window_Text1.new
    @wt2 = Window_Text2.new
    @Lw = Window_Lore.new

    @wt1.windowskin = Cache.system("Window_straight")
    @wt2.windowskin = Cache.system("Window_straight")
    @Lw.windowskin = Cache.system("Window_straight")
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

class Window_Lore <Window_Base
  def initialize
    super(0, 232, 272, 184)
    refresh
  end

  def refresh
    self.contents.clear
    change_color(system_color)
    draw_text(0, 0, 272 - (2 * standard_padding), line_height, "Insert lore here", 1)
  end

  #NEEDS HEAVY WORK
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
    draw_text(100, 0, 150, line_height, "#{$data_mapinfos[$game_map.map_id].name}", 1)
  end
end

class Window_character_CG < Window_Base
  def initialize
    super(272, 48, 272, 320)
    self.padding = 0
    refresh
  end

  def refresh

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
  end

  def window_width
    return 136
  end

  def visible_line_number
    6
  end

  def make_command_list
    add_main_commands
    add_original_commands
  end

  def add_main_commands
    add_command("Inventory", :item, main_commands_enabled)
    add_command("Magic",      :skill,  main_commands_enabled)
    add_command("Equipments", :equip,  main_commands_enabled)
    add_command("Status",     :status, main_commands_enabled)
    add_command("Save",       :save,   main_commands_enabled)
    add_command("Quit Game",  :end,    main_commands_enabled)
  end

  def add_original_commands
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
  end
end

if $game_actors != nil
  #for in-game refresh stuffz, dont worry about dis
  $game_actors[11].name = 1088
  $game_actors[12].name = 832
  update_window_size
end
