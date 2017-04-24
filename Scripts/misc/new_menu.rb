module MOD
#==============================================================================
#                          Menu Modification Begins
#------------------------------------------------------------------------------
# ● Font Configuration
#------------------------------------------------------------------------------
  Font.default_name      = ["THSpatial", "THSpatial", "THSpatial"]
  Font.default_bold      = false
  Font.default_italic    = false
  Font.default_shadow    = false
  Font.default_outline   = true
  Font.default_color     = Color.new(255, 255, 255, 255)
  Font.default_out_color = Color.new(0, 0, 0, 182)
#------------------------------------------------------------------------------
# ● Windowskin Graphics
#------------------------------------------------------------------------------
  WINDOW = ("Window")
#==============================================================================
# ▼ Object Initialization
#       x : window X coordinate
#       y : window Y coordinate
#------------------------------------------------------------------------------
# ● Logo Window [Main Menu]
#------------------------------------------------------------------------------
  LogoX = 0
  LogoY = 0
#------------------------------------------------------------------------------
# ● Health Window
#------------------------------------------------------------------------------
  HealthX = 0
  HealthY = 48
#------------------------------------------------------------------------------
# ● Mana Window
#------------------------------------------------------------------------------
  ManaX = 160
  ManaY = 48
#------------------------------------------------------------------------------
# ● Level Window
#------------------------------------------------------------------------------
  LevelX = 0
  LevelY = 123
#------------------------------------------------------------------------------
# ● Experience Window
#------------------------------------------------------------------------------
  ExpX = 160
  ExpY = 123
#------------------------------------------------------------------------------
# ● Menu Command Window
#------------------------------------------------------------------------------
  CommandX = 0
  CommandY = 198
#------------------------------------------------------------------------------
# ● Gold Window
#------------------------------------------------------------------------------
  GoldX = 160
  GoldY = 198
#------------------------------------------------------------------------------
# ● Variable 1 Window
#------------------------------------------------------------------------------
  Var1X = 0
  Var1Y = 246
#------------------------------------------------------------------------------
# ● Variable 2 Window
#------------------------------------------------------------------------------
  Var2X = 160
  Var2Y = 246
#------------------------------------------------------------------------------
# ● Variable 3 Window
#------------------------------------------------------------------------------
  Var3X = 0
  Var3Y = 294
#------------------------------------------------------------------------------
# ● Variable 4 Window
#------------------------------------------------------------------------------
  Var4X = 160
  Var4Y = 294
#------------------------------------------------------------------------------
# ● Mapname Window
#------------------------------------------------------------------------------
  MapX = 0
  MapY = 342
#------------------------------------------------------------------------------
# ● States Window
#------------------------------------------------------------------------------
  StateX = 160
  StateY = 342
#------------------------------------------------------------------------------
# ● Profile Window
#------------------------------------------------------------------------------
  ProX = 320
  ProY = 0
#------------------------------------------------------------------------------
# ● Text Alignment
#------------------------------------------------------------------------------
  ALIGNMENT = 2
end

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
    #create_background
    create_logo_window
    create_stat_window
    create_command_window
    create_location_window
    create_pro_window
  end

  def create_gold_window
    @gold_window = Window_Gold.new
    @gold_window.x = (MOD::GoldX)
    @gold_window.y = (MOD::GoldY)
    @gold_window.windowskin = Cache.system(MOD::WINDOW)
    @gold_window.width = 160
    @gold_window.height = 48
  end

  def create_logo_window
    @logo_window = Window_Logo.new((MOD::LogoX), (MOD::LogoY))
    @logo_window.x = (MOD::LogoX)
    @logo_window.y = (MOD::LogoY)
    @logo_window.windowskin = Cache.system(MOD::WINDOW)
  end

  def create_stat_window
    @stat_window = Window_Stat.new((MOD::HealthX), (MOD::HealthY))
    @stat_window.x = (MOD::HealthX)
    @stat_window.y = (MOD::HealthY)
    @stat_window.windowskin = Cache.system(MOD::WINDOW)
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
    @command_window.x = (MOD::CommandX)
    @command_window.y = (MOD::CommandY)
    @command_window.width = 160
  end

  def create_location_window
    @map_window = Window_Location.new((MOD::MapX), (MOD::MapY))
    @map_window.x = (MOD::MapX)
    @map_window.y = (MOD::MapY)
    @map_window.windowskin = Cache.system(MOD::WINDOW)
  end

  def create_pro_window
    @pro_window = Window_Pro.new((MOD::ProX), (MOD::ProY))
    @pro_window.x = (MOD::ProX)
    @pro_window.y = (MOD::ProY)
    @pro_window.windowskin = Cache.system(MOD::WINDOW)
  end
end

class Menu_Portrait

  def create_sprites
    create_character
  end

  def create_character
    @character_float = [0, 0, 0]
    @character = Sprite.new
    @character.bitmap = Cache.title1("Character")
    @character.ox = @character.bitmap.width / 2
    @character.oy = @character.bitmap.height / 2
    fy = CHARACTER_FLOAT_EFFECT ? CHARACTER_FLOAT_RANGE : 0
    @character_org = [CHARACTER_POSITION[0] + @character.ox,
                      CHARACTER_POSITION[1] + @character.oy + fy]
    @character.x = @character_org[0]
    @character.y = @character_org[1]
    @character.z = 3
    @character.opacity = 0
    @char_zoom_speed = [0, 0, 0]

    @character2 = Sprite.new
    @character2.bitmap = Cache.title1("Character")
    @character2.ox = @character.ox
    @character2.oy = @character.oy
    @character2.x = @character_org[0]
    @character2.y = @character_org[1]
    @character2.z = @character.z - 1
    @character2.blend_type = 1
    @character2.opacity = 0
    @character2.visible = CHARACTER_AURA_EFFECT
    @character2.zoom_x = 1.0
    @character2.zoom_y = @character2.zoom_x
  end

  def dispose_character
    @character.bitmap.dispose
    @character.dispose
    @character2.bitmap.dispose
    @character2.dispose
  end

end

#==============================================================================
# ▼ Window Logo
#------------------------------------------------------------------------------
# - This windows displays Main Menu Logo.
#------------------------------------------------------------------------------
class Window_Logo < Window_Base
  def initialize(x, y)
    super(x, y, 320, 48)
    refresh
  end

  def refresh
    self.contents.clear
    @actor = $game_party.members[0]
    change_color(system_color)
    draw_text(0, 0, 300, line_height, "Testing some changes to the menu!", 1)
  end
end


class Window_Stat < Window_Base
  def initialize(x, y)
    super(x, y, 160, 75)
    refresh
  end

  def refresh
    self.contents.clear
    @actor = $game_party.members[0]
    change_color(hp_gauge_color1)
    draw_text(0, 0, 250, line_height, "Health Condition")
    draw_actor_hp(@actor, 0 , 20)
  end

  def draw_actor_hp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    draw_text(5, 20, 100, line_height, "Health")
    change_color(normal_color)
    draw_text(5, 20, 116, line_height, actor.hp, 2)
  end
end

class Window_Location < Window_Base
  def initialize(x, y)
    super(x, y, 160, 74)
    refresh
  end
  def refresh
    self.contents.clear
    @actor = $game_party.members[0]
    change_color(hp_gauge_color1)
    draw_text(0, 0, 250, line_height, "Location:")
    change_color(system_color)
    draw_text(0, 20, 250, line_height, "#{$data_mapinfos[$game_map.map_id].name}")
    draw_icon(231, contents.width - 23, -1, true)
  end
end

class Window_Pro < Window_Base
  def initialize(x, y)
    super(x, y, 224, 416)
    refresh
  end
  def refresh
    self.contents.clear
    @actor = $game_party.members[0]
    change_color(system_color)
    draw_text(0, 0, width, line_height, "Character Identity Card:")
         # Actor Face Position
    contents.fill_rect(0, 25, 96, 96, Font.default_out_color)
    draw_actor_face(@actor, 0, 25)
         # Actor Sprite Position
    contents.fill_rect(105, 25, width, 96, Font.default_out_color)
    draw_actor_graphic(@actor, 151, 90)
         # Actor Name Position
    contents.fill_rect(0, 130, width, 44, Font.default_out_color)
    change_color(system_color)
    draw_text(5, 130, width, line_height, "Character Name:")
    draw_actor_name(@actor, 5, 150)
         # Actor Class Position
    contents.fill_rect(0, 183, width, 44, Font.default_out_color)
    change_color(system_color)
    draw_text(5, 185, width, line_height, "Character Profile:")
    draw_actor_class(@actor, 5, 204)
         # Actor Parameters Position
    contents.fill_rect(0, 236, width, height, Font.default_out_color)
         #change_color(tp_gauge_color1)
    draw_text(5, 238, 200, line_height, "I DON'T NEED THESE, WOO!")
         #sprite.bitmap = Cache.picture("yellowgem")
         #draw_actor_param(@actor, 5, 258, 2)
         #draw_actor_param(@actor, 5, 278, 3)
         #draw_actor_param(@actor, 5, 298, 4)
         #draw_actor_param(@actor, 5, 318, 5)
         #draw_actor_param(@actor, 5, 338, 6)
         #draw_actor_param(@actor, 5, 358, 7)
  end
end

class Window_MenuCommand < Window_Command
  def self.init_command_position
    @@last_command_symbol = nil
  end

  def initialize
    super(0, 0)
    select_last
  end
  
  def window_width
    return 160
  end

  def visible_line_number
    1
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
