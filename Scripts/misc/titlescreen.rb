#==============================================================================
# +++ MOG - Hijiri Title Screen (v1.0) +++
#==============================================================================
# By Moghunter
# http://www.atelier-rgss.com/
#==============================================================================
# Tela de título animada com o tema da Hijiri Byakuren, para os fans de Touhou.
# Naturalmente é possível customizar qualquer tipo de personagem.
#==============================================================================
module MOG_HIJIRI_TITLE_SCRREN
  #Definição da velocidade de deslize da imagem de fundo.
  BACKGROUND_SCROLL_SPEED = [0, 0]
  #Definição da quantidade de partículas.
  NUMBER_OF_PARTICLES = 10
  #Definição do tipo de blend da partícula.
  PARTICLES_BLEND_TYPE  = 1
  #Definição da posição do personagem.
  CHARACTER_POSITION = [0, 0]
  #Definição da posição do comando.
  COMMAND_POSITION = [0, 5]
  #Ativar o efeito de aura na imagem do personagem.
  CHARACTER_AURA_EFFECT = true
  #Ativar o efeito de flutuar.
  CHARACTER_FLOAT_EFFECT = true
  CHARACTER_FLOAT_RANGE = 10
  CHARACTER_FLOAT_SPEED = 9
  #Definição da posição do círculo mágico
  MAGIC_CIRCLE_POSITION = [0, 0]
  #Ativar Logo.
  LOGO = true
  #Definição da duração do logo.
  LOGO_DURATION = 2
  #Definição do tempo de transição.
  TRASITION_DURATION = 30
end

$imported = {} if $imported.nil?
$imported[:mog_hijiri_title_screen] = true

$displayedlogo = false
$showedtransition = false

def game_magics
  if DataManager.save_file_exists? && skip_title?
    DataManager.load_game(0)
    return true
  end
  return false
end

#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title
  include MOG_HIJIRI_TITLE_SCRREN

  #--------------------------------------------------------------------------
  # ● Main
  #--------------------------------------------------------------------------
  def main
    if !game_magics
      execute_logo if LOGO && !$displayedlogo
      $displayedlogo = true
      Graphics.update
      Graphics.freeze
      execute_setup
      execute_loop
      dispose
    else
      $game_system.on_after_load
      SceneManager.goto(Scene_Map)
    end
  end

  #--------------------------------------------------------------------------
  # ● Execute Setup
  #--------------------------------------------------------------------------
  def execute_setup
    @phase = 0
    @active = false
    @continue_enabled = DataManager.save_file_exists?
    @com_index = @continue_enabled ? 1 : 0
    @com_index_old = @com_index
    @com_index_max = 2
    create_sprites
  end

  #--------------------------------------------------------------------------
  # ● Execute Lopp
  #--------------------------------------------------------------------------
  def execute_loop
    if !$showedtransition
      Graphics.transition(TRASITION_DURATION)
    else
      Graphics.transition(TRASITION_DURATION/6)
    end

    $showedtransition = true

    play_title_music
    loop do
      Input.update
      update
      Graphics.update
      break if SceneManager.scene != self
    end
  end
end


#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title

  #--------------------------------------------------------------------------
  # ● Execute Logo
  #--------------------------------------------------------------------------
  def execute_logo
    Graphics.transition
    create_logo
    loop do
      Input.update
      update_logo
      Graphics.update
      break if !@logo_phase
    end
    dispose_logo
  end

  #--------------------------------------------------------------------------
  # ● Create Logo
  #--------------------------------------------------------------------------
  def create_logo
    @logo = Sprite.new
    @logo.z = 100
    @logo.opacity = 0
    @logo_duration = [0, 60 * LOGO_DURATION]
    @logo.bitmap = Cache.title1("Logo") rescue nil
    @logo_phase = @logo.bitmap != nil ? true : false
  end

  #--------------------------------------------------------------------------
  # ● Dispose Logo
  #--------------------------------------------------------------------------
  def dispose_logo
    Graphics.freeze
    @logo.bitmap.dispose if @logo.bitmap != nil
    @logo.dispose
  end

  #--------------------------------------------------------------------------
  # ● Update Logo
  #--------------------------------------------------------------------------
  def update_logo
    return if !@logo_phase
    update_logo_command
    if @logo_duration[0] == 0
      @logo.opacity += 5
      @logo_duration[0] = 1 if @logo.opacity >= 255
    elsif @logo_duration[0] == 1
      @logo_duration[1] -= 1
      @logo_duration[0] = 2 if @logo_duration[1] <= 0
    else
      @logo.opacity -= 5
      @logo_phase = false if @logo.opacity <= 0
    end
  end

  #--------------------------------------------------------------------------
  # ● Update Logo Command
  #--------------------------------------------------------------------------
  def update_logo_command
    return if @logo_duration[0] == 2
    if Input.trigger?(:C) or Input.trigger?(:B)
      @logo_duration = [2, 0]
    end
  end
end

def skip_title?
  !File.exists?("title_key.txt")
end

#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title

  #--------------------------------------------------------------------------
  # ● Create Sprites
  #--------------------------------------------------------------------------
  def create_sprites
    create_background
    create_commands
    create_particles
    create_particles3
    create_character
    create_layout
    create_magic_circle
    create_magic_circle2
  end

  #--------------------------------------------------------------------------
  # ● Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background = Plane.new
    @background.bitmap = Cache.title1("Background")
    @background_scroll = [BACKGROUND_SCROLL_SPEED[0], BACKGROUND_SCROLL_SPEED[1], 0]
    @background.z = 0
  end

  #--------------------------------------------------------------------------
  # ● Create Magic Circle
  #--------------------------------------------------------------------------
  def create_magic_circle
    @magic_cicle = Sprite.new
    @magic_cicle.bitmap = Cache.title1("Magic_Circle")
    @magic_cicle.ox = @magic_cicle.bitmap.width / 2
    @magic_cicle.oy = @magic_cicle.bitmap.height / 2
    @magic_cicle.x = @magic_cicle.ox + MAGIC_CIRCLE_POSITION[0]
    @magic_cicle.y = @magic_cicle.oy + MAGIC_CIRCLE_POSITION[1]
    @magic_cicle.z = 1
    @magic_cicle.blend_type = 0
    @magic_cicle.opacity = 0
    @magic_cicle_speed = 0
  end

  #--------------------------------------------------------------------------
  # ● Create Magic Circle
  #--------------------------------------------------------------------------
  def create_magic_circle2
    return
    @magic_cicle2 = Sprite.new
    @magic_cicle2.bitmap = Cache.title1("Magic_Circle")
    @magic_cicle2.ox = @magic_cicle2.bitmap.width / 2
    @magic_cicle2.oy = @magic_cicle2.bitmap.height / 2
    @magic_cicle2.x = @magic_cicle2.ox #+ MAGIC_CIRCLE2_POSITION[0]
    @magic_cicle2.y = @magic_cicle2.oy #+ MAGIC_CIRCLE2_POSITION[1]
    @magic_cicle2.z = 3
    @magic_cicle2.blend_type = 0
    @magic_cicle2.opacity = 0
    @magic_cicle2_speed = 0
  end


  #--------------------------------------------------------------------------
  # ● Create Layout
  #--------------------------------------------------------------------------
  def create_layout
    @layout = Sprite.new
    @layout.bitmap = Cache.title1("Layout")
    @layout.z = 20
    @layout.opacity = 0
  end

  #--------------------------------------------------------------------------
  # ● Create Commands
  #--------------------------------------------------------------------------
  def create_commands
    @com = []
    for index in 0...3
      if index != 1
        @com.push(Title_Commands.new(nil, index))
      elsif index == 1 && !skip_title?
        @com.push(Title_Commands.new(nil, index))
      end
    end
  end

  #--------------------------------------------------------------------------
  # ● Create Particles
  #--------------------------------------------------------------------------
  def create_particles
    @particles_sprite =[]
    for i in 0...NUMBER_OF_PARTICLES
      @particles_sprite.push(Particles_Title.new(nil))
    end
  end

  #--------------------------------------------------------------------------
  # ● Create Particles
  #--------------------------------------------------------------------------
  def create_particles3
    @particles_sprite3 =[]
    for i in 0...NUMBER_OF_PARTICLES
      @particles_sprite3.push(Particles_Title3.new(nil))
    end
  end

  #--------------------------------------------------------------------------
  # ● Create Character
  #--------------------------------------------------------------------------
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

end

#==============================================================================
# ■ Particles Title
#==============================================================================
class Particles_Title < Sprite

  include MOG_HIJIRI_TITLE_SCRREN

 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    @speed_x = 0
    @speed_y = 0
    @speed_a = 0
    @speed_o = 0
    self.bitmap = Cache.title1("Particles")
    self.blend_type = PARTICLES_BLEND_TYPE
    self.z = 4
    @cy_size = self.bitmap.height + (self.bitmap.height / 2)
    @cy_limit = Graphics.height - (@cy_size * 3)
    reset_setting(true)
  end

 #--------------------------------------------------------------------------
 # ● Reset Setting
 #--------------------------------------------------------------------------
  def reset_setting(initial = false)
    zoom = (50 + rand(100)) / 100.1
    self.zoom_x = zoom
    self.zoom_y = zoom
    self.x = rand(Graphics.width)
    self.y = initial == true ? rand(480) : (Graphics.height + @cy_size)
    self.opacity = 255
    z = rand(2)
    if z == 1
      self.z = 40
    else
      self.z = 20
    end
    @speed_y = -(1 + rand(3))
    @speed_x = (1 + rand(2))
    @speed_a = (1 + rand(2))
    @speed_o = (2 + rand(8))
  end

 #--------------------------------------------------------------------------
 # ● Dispose
 #--------------------------------------------------------------------------
  def dispose
    super
    self.bitmap.dispose if self.bitmap != nil
  end

 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------
  def update
    super
    self.y += @speed_y
    self.opacity -= @speed_o
    reset_setting if can_reset_setting?
  end

 #--------------------------------------------------------------------------
 # ● Can Reset Setting
 #--------------------------------------------------------------------------
  def can_reset_setting?
    return true if self.opacity == 0
    return true if self.y < -@cy_size
    return false
  end

end

#==============================================================================
# ■ Particles Title
#==============================================================================
class Particles_Title3 < Sprite

  include MOG_HIJIRI_TITLE_SCRREN

 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    @speed_x = 0
    @speed_y = 0
    @speed_a = 0
    @next_pos = [440, 190]
    self.bitmap = Cache.title1("Particles3")
    self.blend_type = PARTICLES_BLEND_TYPE
    self.z = 4
    @cy_size = self.bitmap.height + (self.bitmap.height / 2)
    @cy_limit = Graphics.height + @cy_size
    @rg = [Graphics.width - self.bitmap.width , 0]
    @phase = 0
    reset_setting(true)
  end

 #--------------------------------------------------------------------------
 # ● Reset Setting
 #--------------------------------------------------------------------------
  def reset_setting(initial = false)
    zoom = (50 + rand(100)) / 100.1
    self.zoom_x = zoom
    self.zoom_y = zoom
    self.x = 280 + rand(250) # - 160
    self.y = 190 + rand(self.bitmap.height) #initial == true ? rand(480) : -@cy_size
    self.opacity = 255
    @speed_y = (1 + rand(3))
    @speed_x = (1 + rand(2))
    @speed_a = (1 + rand(2))
    @rg[1] = (Graphics.height / 2) + rand(128)
    @phase = 0
  end

 #--------------------------------------------------------------------------
 # ● Dispose
 #--------------------------------------------------------------------------
  def dispose
    super
    self.bitmap.dispose if self.bitmap != nil
  end

 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------
  def update
    super
     # self.x += @speed_x
    self.y -= @speed_y
    self.opacity -= 3
    reset_setting if can_reset_setting?
  end

 #--------------------------------------------------------------------------
 # ● Can Reset Setting
 #--------------------------------------------------------------------------
  def can_reset_setting?
    return true if self.y < 0
    return false
  end

end

#==============================================================================
# ■ Title Commands
#==============================================================================
class Title_Commands < Sprite
  include MOG_HIJIRI_TITLE_SCRREN

  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------
  def initialize(viewport = nil, index)
    super(viewport)
    @index = index
    @float = [0, 0, 0]
    self.bitmap = Cache.title1("Command" + index.to_s)
    self.ox = self.bitmap.width / 2
    self.oy = self.bitmap.height / 2
    indexy = index
    if indexy == 2 && skip_title?
      indexy = 1
    end
    @org_pos = [COMMAND_POSITION[0] + self.ox,
      COMMAND_POSITION[1] + self.oy + (self.bitmap.height + 2) * indexy,
      self.ox - 24]
    self.x = @org_pos[0] - self.bitmap.width - (self.bitmap.width * index)
    self.y = @org_pos[1]
    self.z = 25
    self.visible = true
    @next_pos = [@org_pos[0], @org_pos[1]]
  end

  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------
  def dispose_sprites
    self.bitmap.dispose
  end

  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------
  def update_sprites(index, active)
     # return if !active
    if index == @index
      self.opacity += 10
      @next_pos[0] = @org_pos[0]
      # update_float_effect
    else
      self.opacity -= 10 if self.opacity > 120
      @next_pos[0] = @org_pos[2]
      @float = [0, 0, 0]
    end
    update_slide(0, @next_pos[0])
    update_slide(1, @org_pos[1] + @float[0])
  end

 #--------------------------------------------------------------------------
 # ● Update Slide
 #--------------------------------------------------------------------------
  def update_slide(type, np)
    cp = type == 0 ? self.x : self.y
    sp = 3 + ((cp - np).abs / 10)
    if cp > np
      cp -= sp
      cp = np if cp < np
    elsif cp < np
      cp += sp
      cp = np if cp > np
    end
    self.x = cp if type == 0
    self.y = cp if type == 1
  end

  #--------------------------------------------------------------------------
  # ● Update Float Effect
  #--------------------------------------------------------------------------
  def update_float_effect
    @float[2] += 1
    return if @float[2] < 5
    @float[2] = 0
    @float[1] += 1
    case @float[1]
    when 1..5
      @float[0] -= 1
    when 6..15
      @float[0] += 1
    when 16..20
      @float[0] -= 1
    else
      @float[0] = 0
      @float[1] = 0
    end
  end

end

#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title

  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------
  def dispose
    Graphics.freeze
    dispose_background
    dispose_particles
    dispose_particles3
    dispose_character
    dispose_layout
    dispose_commands
    dispose_magic_circle
    dispose_magic_circle2
  end

  #--------------------------------------------------------------------------
  # ● Dispose Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background.bitmap.dispose
    @background.dispose
  end

  #--------------------------------------------------------------------------
  # ● Dispose Magic Circle
  #--------------------------------------------------------------------------
  def dispose_magic_circle
    return if @magic_cicle == nil
    @magic_cicle.bitmap.dispose
    @magic_cicle.dispose
  end

  #--------------------------------------------------------------------------
  # ● Dispose Magic Circle2
  #--------------------------------------------------------------------------
  def dispose_magic_circle2
    return if @magic_cicle2 == nil
    @magic_cicle2.bitmap.dispose
    @magic_cicle2.dispose
  end

  #--------------------------------------------------------------------------
  # ● Dispose Layout
  #--------------------------------------------------------------------------
  def dispose_layout
    @layout.bitmap.dispose
    @layout.dispose
  end

  #--------------------------------------------------------------------------
  # ● Dispose Commands
  #--------------------------------------------------------------------------
  def dispose_commands
    @com.each {|sprite| sprite.dispose_sprites }
  end

 #--------------------------------------------------------------------------
 # ● Dispose Particles
 #--------------------------------------------------------------------------
  def dispose_particles
    @particles_sprite.each {|sprite| sprite.dispose }
  end

 #--------------------------------------------------------------------------
 # ● Dispose Particles 3
 #--------------------------------------------------------------------------
  def dispose_particles3
    @particles_sprite3.each {|sprite| sprite.dispose }
  end

  #--------------------------------------------------------------------------
  # ● Dispose Character
  #--------------------------------------------------------------------------
  def dispose_character
    @character.bitmap.dispose
    @character.dispose
    @character2.bitmap.dispose
    @character2.dispose
  end

end

#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title

  #--------------------------------------------------------------------------
  # ● Update Sprites
  #--------------------------------------------------------------------------
  def update_sprites
    update_background
    update_particles
    update_particles3
    update_character
    update_commands
    update_magic_circle
  end

  #--------------------------------------------------------------------------
  # ● Update Background
  #--------------------------------------------------------------------------
  def update_background
    if !$showedtransition
      @layout.opacity += 5
    else
      @layout.opacity += 25
    end
    @background_scroll[2] += 1
    return if @background_scroll[2] < 4
    @background_scroll[2] = 0
    @background.ox += @background_scroll[0]
    @background.oy += @background_scroll[1]
  end

  #--------------------------------------------------------------------------
  # ● Update Magic Circle
  #--------------------------------------------------------------------------
  def update_magic_circle
    return if @magic_cicle == nil
    @magic_cicle_speed += 1
    return if @magic_cicle_speed < 3
    @magic_cicle_speed = 0
    @magic_cicle.opacity += 3
    @magic_cicle.angle += 1
    return if @magic_cicle2 == nil
    @magic_cicle2.opacity += 3 if @magic_cicle2.opacity < 100
    @magic_cicle2.angle -= 1
  end

  #--------------------------------------------------------------------------
  # ● Update Commands
  #--------------------------------------------------------------------------
  def update_commands
    @com.each {|sprite| sprite.update_sprites(@com_index, @active)}
  end

  #--------------------------------------------------------------------------
  # ● Update Particles
  #--------------------------------------------------------------------------
  def update_particles
    return if @particles_sprite == nil
    @particles_sprite.each {|sprite| sprite.update }
  end

  #--------------------------------------------------------------------------
  # ● Update Particles 3
  #--------------------------------------------------------------------------
  def update_particles3
    return if @particles_sprite3 == nil
    @particles_sprite3.each {|sprite| sprite.update }
  end

  #--------------------------------------------------------------------------
  # ● Update Character
  #--------------------------------------------------------------------------
  def update_character
    return if @character == nil
    update_character_float_effect
    if !$showedtransition
      @character.opacity += 5
    else
      @character.opacity += 25
    end
    update_character_aura_effect
  end

  #--------------------------------------------------------------------------
  # ● Update Character Aura Effect
  #--------------------------------------------------------------------------
  def update_character_aura_effect
    return if !CHARACTER_AURA_EFFECT
    @character2.opacity -= 1
    @char_zoom_speed[0] += 1
    case @char_zoom_speed[0]
    when 1..120
      @char_zoom_speed[2] += 0.001
    when 121..240
      @char_zoom_speed[2] -= 0.001
    else
      @char_zoom_speed[0] = 0
      @char_zoom_speed[2] = 0
      @character2.zoom_x = 1.00
      @character2.zoom_y = 1.00
      @character2.opacity = 255
      @character2.y = @character.y
    end
    @character2.zoom_x = 1.00 + @char_zoom_speed[2]
    @character2.zoom_y = @character2.zoom_x
  end

  #--------------------------------------------------------------------------
  # ● Update Character Float Effect
  #--------------------------------------------------------------------------
  def update_character_float_effect
    return if !CHARACTER_FLOAT_EFFECT
    @character_float[0] += 1
    return if @character_float[0] < CHARACTER_FLOAT_SPEED
    @character_float[0] = 0
    @character_float[1] += 1
    case @character_float[1]
    when 0..CHARACTER_FLOAT_RANGE
      @character_float[2] -= 1
    when CHARACTER_FLOAT_RANGE..(CHARACTER_FLOAT_RANGE * 2) - 1
      @character_float[2] += 1
    else
      @character_float = [0, 0, 0]
    end
    @character.y = @character_org[1] + @character_float[2]
  end

end

#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title

  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------
  def update
    update_command
    update_sprites
  end

end

#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title

  #--------------------------------------------------------------------------
  # ● Update Command
  #--------------------------------------------------------------------------
  def update_command
    update_key
    refresh_index if @com_index_old != @com_index
  end

  #--------------------------------------------------------------------------
  # ● Update Key
  #--------------------------------------------------------------------------
  def update_key
    if Input.trigger?(:DOWN)
      add_index(1)
    elsif Input.trigger?(:UP)
      add_index(-1)
    elsif Input.trigger?(:C)
      select_command
    end
  end

  #--------------------------------------------------------------------------
  # ● Select Command
  #--------------------------------------------------------------------------
  def select_command
    #  if !@active
    #     @active = true
    #     return
    #  end
    case @com_index
    when 0; command_new_game
    when 1; command_continue
    when 2; command_shutdown
    end
  end

  #--------------------------------------------------------------------------
  # ● Add Index
  #--------------------------------------------------------------------------
  def add_index(value = 0)
    @com_index += value
    if !@continue_enabled and @com_index == 1
      @com_index = 2 if value == 1
      @com_index = 0 if value == -1
    end
    @com_index = 0 if @com_index > @com_index_max
    @com_index = @com_index_max if @com_index < 0
  end

  #--------------------------------------------------------------------------
  # ● Refresh Index
  #--------------------------------------------------------------------------
  def refresh_index
    @com_index_old = @com_index
    Sound.play_cursor
  end

  #--------------------------------------------------------------------------
  # ● Command New Game
  #--------------------------------------------------------------------------
  def command_new_game
    Sound.play_ok
    DataManager.setup_new_game
    fadeout_all
    $game_map.autoplay
    SceneManager.goto(Scene_Map)
  end

  #--------------------------------------------------------------------------
  # ● Command Continue
  #--------------------------------------------------------------------------
  def command_continue
    if !@continue_enabled
      Sound.play_cancel
      return
    else
      Sound.play_ok
    end
    SceneManager.call(Scene_Load)
  end

  #--------------------------------------------------------------------------
  # ● Command Shutdown
  #--------------------------------------------------------------------------
  def command_shutdown
    Sound.play_ok
    fadeout_all
    SceneManager.exit
  end

  #--------------------------------------------------------------------------
  # ● play_title_music
  #--------------------------------------------------------------------------
  def play_title_music
    $data_system.title_bgm.play
    RPG::BGS.stop
    RPG::ME.stop
  end

  #--------------------------------------------------------------------------
  # ● Fadeout_all
  #--------------------------------------------------------------------------
  def fadeout_all(time = 1000)
    RPG::BGM.fade(time)
    RPG::BGS.fade(time)
    RPG::ME.fade(time)
    Graphics.fadeout(time * Graphics.frame_rate / 1000)
    RPG::BGM.stop
    RPG::BGS.stop
    RPG::ME.stop
  end
end
