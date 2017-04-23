#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  This sprite is used to display characters. It observes an instance of the
# Game_Character class and automatically changes sprite state.
#==============================================================================

class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :character
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     character : Game_Character
  #--------------------------------------------------------------------------
  def initialize(viewport, light_viewport, character = nil)
    super(viewport)
    @character = character
    @balloon_duration = 0
    @sprite = Sprite.new(viewport)
    @light_sprite = Sprite.new(light_viewport)
    @lv = light_viewport
    @light_sprite.blend_type = 1
    update
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    puts "disposing "+@character.character_name + "..."
    @light_sprite.dispose
    @light_sprite = nil
    @sprite.dispose
    @sprite = nil
    end_animation
    end_balloon
    super
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_bitmap
    update_src_rect
    update_position
    update_other
    update_balloon
    setup_new_effect
  end
  #--------------------------------------------------------------------------
  # * Get Tileset Image That Includes the Designated Tile
  #--------------------------------------------------------------------------
  def tileset_bitmap(tile_id)
    Cache.tileset($game_map.tileset.tileset_names[5 + tile_id / 256])
  end

  def tileset_bitmap_lightmap(id)
    Cache.lightmap_tileset($game_map.tileset.tileset_names[5 + id / 256])
  end
  #--------------------------------------------------------------------------
  # * Update Transfer Origin Bitmap
  #--------------------------------------------------------------------------
  def update_bitmap
    if graphic_changed?
      @tile_id = @character.tile_id
      @character_name = @character.character_name
      @character_index = @character.character_index
      if @tile_id > 0
        set_tile_bitmap
      else
        set_character_bitmap
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Graphic Changed
  #--------------------------------------------------------------------------
  def graphic_changed?
    @tile_id != @character.tile_id ||
      @character_name != @character.character_name ||
      @character_index != @character.character_index
  end
  #--------------------------------------------------------------------------
  # * Set Tile Bitmap
  #--------------------------------------------------------------------------
  def set_tile_bitmap
    @light_sprite.visible = false
    sx = (@tile_id / 128 % 2 * 8 + @tile_id % 8) * 32;
    sy = @tile_id % 256 / 8 % 16 * 32;
    @sprite.bitmap = tileset_bitmap(@tile_id)
    @sprite.src_rect.set(sx, sy, 32, 32)
    @sprite.ox = 16
    @sprite.oy = 32
=begin
    begin
      @light_sprite.bitmap = tileset_bitmap_lightmap(@tile_id)
      @light_sprite.visible = true
      @light_sprite.src_rect.set(sx, sy, 32, 32)
      @light_sprite.ox = 16
      @light_sprite.oy = 32
      @light_sprite.blend_type = 0
      @light_sprite.z = 1
       puts "Lightmap loaded for " + $game_map.tileset.tileset_names[5 + @tile_id / 256]
    rescue => err
      puts "LIGHTMAP CANNOT BE LOADED FOR " + $game_map.tileset.tileset_names[5 + @character.tile_id / 256] + ", cause: #{err}"
      @light_sprite.bitmap = nil
      @light_sprite.visible = false
    end
=end

  end
  #--------------------------------------------------------------------------
  # * Set Character Bitmap
  #--------------------------------------------------------------------------
  def set_character_bitmap
    @sprite.bitmap = Cache.character(@character_name)
    sign = @character_name[/^[\!\$]./]
    if sign && sign.include?("$")
      @cw = @sprite.bitmap.width / 3
      @ch = @sprite.bitmap.height / 4
    else
      @cw = @sprite.bitmap.width / 12
      @ch = @sprite.bitmap.height / 8
    end

    begin
      @light_sprite.bitmap = Cache.lightmap(@character.character_name)
      @light_sprite.visible = true
    rescue
      puts "LIGHTMAP CANNOT BE LOADED FOR " + @character.character_name
      @light_sprite.bitmap = nil
      @light_sprite.visible = false
    end

    @sprite.ox = @cw / 2
    @sprite.oy = @ch
    @light_sprite.ox = @cw / 2
    @light_sprite.oy = @ch
  end
  #--------------------------------------------------------------------------
  # * Update Transfer Origin Rectangle
  #--------------------------------------------------------------------------
  def update_src_rect
    if @tile_id == 0
      index = @character.character_index
      pattern = @character.pattern < 3 ? @character.pattern : 1
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      @sprite.src_rect.set(sx, sy, @cw, @ch)
      @light_sprite.src_rect.set(sx, sy, @cw, @ch)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Position
  #--------------------------------------------------------------------------
  def update_position
    move_animation(@character.screen_x - x, @character.screen_y - y)
    @light_sprite.x = @character.screen_x
    @light_sprite.y = @character.screen_y
    @sprite.x = @character.screen_x
    @sprite.y = @character.screen_y
    @sprite.z = @character.screen_z
  end
  #--------------------------------------------------------------------------
  # * Update Other
  #--------------------------------------------------------------------------
  def update_other
    @sprite.opacity = @character.opacity
    @sprite.blend_type = @character.blend_type
    @sprite.bush_depth = @character.bush_depth
    @light_sprite.bush_depth = @character.bush_depth
    @sprite.visible = !@character.transparent
    @light_sprite.visible = !@character.transparent
  end

  def self.sprite_attr(*args)
    args.each do |arg|
      class_eval("def #{arg};@sprite.#{arg};end")
      class_eval("def #{arg}=(val);@sprite.#{arg}=val;@light_sprite.#{arg}=val;end")
    end
  end
  #--------------------------------------------------------------------------
  # * Set New Effect
  #--------------------------------------------------------------------------
  def setup_new_effect
    if !animation? && @character.animation_id > 0
      animation = $data_animations[@character.animation_id]
      start_animation(animation)
    end
    if !@balloon_sprite && @character.balloon_id > 0
      @balloon_id = @character.balloon_id
      start_balloon
    end
  end
  #--------------------------------------------------------------------------
  # * Move Animation
  #--------------------------------------------------------------------------
  def move_animation(dx, dy)
    if @animation && @animation.position != 3
      @ani_ox += dx
      @ani_oy += dy
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
  #--------------------------------------------------------------------------
  # * End Animation
  #--------------------------------------------------------------------------
  def end_animation
    super
    @character.animation_id = 0
  end
  #--------------------------------------------------------------------------
  # * Start Balloon Icon Display
  #--------------------------------------------------------------------------
  def start_balloon
    dispose_balloon
    @balloon_duration = 8 * balloon_speed + balloon_wait
    @balloon_sprite = ::Sprite.new(@lv)
    @balloon_sprite.bitmap = Cache.system("Balloon")
    @balloon_sprite.ox = 16
    @balloon_sprite.oy = 32
    update_balloon
  end
  #--------------------------------------------------------------------------
  # * Free Balloon Icon
  #--------------------------------------------------------------------------
  def dispose_balloon
    if @balloon_sprite
      @balloon_sprite.dispose
      @balloon_sprite = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Update Balloon Icon
  #--------------------------------------------------------------------------
  def update_balloon
    if @balloon_duration > 0
      @balloon_duration -= 1
      if @balloon_duration > 0
        @balloon_sprite.x = x
        @balloon_sprite.y = y - height - 32
        @balloon_sprite.z = z + 200
        sx = balloon_frame_index * 32
        sy = (@balloon_id - 1) * 32
        @balloon_sprite.src_rect.set(sx, sy, 32, 32)
      else
        end_balloon
      end
    end
  end
  #--------------------------------------------------------------------------
  # * End Balloon Icon
  #--------------------------------------------------------------------------
  def end_balloon
    dispose_balloon
    @character.balloon_id = 0
  end
  #--------------------------------------------------------------------------
  # * Balloon Icon Display Speed
  #--------------------------------------------------------------------------
  def balloon_speed
    return 8
  end
  #--------------------------------------------------------------------------
  # * Wait Time for Last Frame of Balloon
  #--------------------------------------------------------------------------
  def balloon_wait
    return 12
  end
  #--------------------------------------------------------------------------
  # * Frame Number of Balloon Icon
  #--------------------------------------------------------------------------
  def balloon_frame_index
    return 7 - [(@balloon_duration - balloon_wait) / balloon_speed, 0].max
  end
  sprite_attr :src_rect
  sprite_attr :visible
  sprite_attr :x, :y, :z
  sprite_attr :ox, :oy
  sprite_attr :zoom_x, :zoom_y
  sprite_attr :angle
  sprite_attr :mirror
  sprite_attr :bush_depth
  sprite_attr :opacity
  sprite_attr :color
  sprite_attr :tone
end
