=begin
===============================================================================
 Scene_Combine by efeberk
 Version: RGSS3
===============================================================================
 This script will allow to combine two items and generate a new item from
 combined items. The scene is similiar with item_window. Actually you can use
 Scene_Combine instead of Scene_Item because there is an option named "Use" that
 allows you to use items. Why you need Item scene?

 Example : You have 1 potion and 1 stimulant. Combine them and generate a new
 Ultra stimulant.
--------------------------------------------------------------------------------

How to open Scene_Combine:

SceneManager.call(Scene_Combine)

Note : This script works on Items, Weapons and Armors
=end

module EFE
  COMBINE_BUTTON = "Combine"
  USE_BUTTON = "Use"
  SUCCESS = "Items have been combined succesfully"

  #Item name will be colored when you select an item in the list.
  SELECTED_COLOR = 14


  COMBINATIONS = [

  #[[item1, :type], [item2, :type], [result, :type]],
  #[[item1, :type], [item2, :type], [result, :type]],
  [[1, :item], [2, :weapon], [3, :armor]],
  [[8, :item], [9, :item], [3, :armor]]

  ]
end

#==============================================================================
# ** Window_ItemKategory
#------------------------------------------------------------------------------
#  This window is for selecting a category of normal items and equipment
# on the item screen or shop screen.
#==============================================================================

class Window_ItemKategory < Window_HorzCommand
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :item_window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 4
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    @item_window.category = current_symbol if @item_window
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::item,     :item)
    add_command(Vocab::weapon,   :weapon)
    add_command(Vocab::armor,    :armor)
    add_command(Vocab::key_item, :key_item)
  end
  #--------------------------------------------------------------------------
  # * Set Item Window
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    @item_window = item_window
    update
  end
end


class Window_ItemListe < Window_Selectable

  attr_reader :accepted_items
  attr_reader :combining

  def initialize(x, y, width, height)
    super
    @combining = false
    @accepted_items = []
    @category = :none
    @data = []
  end

  def combining=(combine)
    @combining = combine
  end

  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end

  def col_max
    return 2
  end

  def item_max
    @data ? @data.size : 1
  end

  def item
    @data && index >= 0 ? @data[index] : nil
  end

  def current_item_enabled?
    enable?(@data[index])
  end

  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item) && !item.key_item?
    when :weapon
      item.is_a?(RPG::Weapon)
    when :armor
      item.is_a?(RPG::Armor)
    when :key_item
      item.is_a?(RPG::Item) && item.key_item?
    else
      false
    end
  end

  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end

  def enable?(item)
    return true if @combining
    $game_party.usable?(item)
  end

  def make_item_list
    @data = $game_party.all_items.select {|item| include?(item) }
    @data.push(nil) if include?(nil)
  end

  def select_last
    select(@data.index($game_party.last_item.object) || 0)
  end

  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      k = [item.id, :item] if item.is_a?(RPG::Item)
      k = [item.id, :weapon] if item.is_a?(RPG::Weapon)
      k = [item.id, :armor] if item.is_a?(RPG::Armor)
      change_color(normal_color, enable?(item))
      change_color(text_color(EFE::SELECTED_COLOR), enable?(item)) if @accepted_items.include?(k)
      draw_item_name(item, rect.x, rect.y, enable?(item))
      draw_item_number(rect, item)
    end
  end

  def draw_item_number(rect, item)
    draw_text(rect, sprintf(":%2d", $game_party.item_number(item)), 2)
  end

  def update_help
    @help_window.set_item(item)
  end

  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end


class Window_AcceptCombination < Window_HorzCommand

  def initialize(x, y)
    super(x, y)
    self.z = 0
  end

  def window_width
    return Graphics.width
  end

  def col_max
    return 2
  end

  def make_command_list
    add_command(EFE::COMBINE_BUTTON, :combine)
    add_command(EFE::USE_BUTTON, :use)
  end
end

class Scene_Combine < Scene_ItemBase

  def start
    super
    create_help_window
    create_options_window
    create_category_window
    create_item_window
  end

  def create_options_window
    @options_window = Window_AcceptCombination.new(0, @help_window.y + @help_window.height)
    @options_window.set_handler(:combine, method(:combine_ok))
    @options_window.set_handler(:use, method(:use_ok))
    @options_window.set_handler(:cancel, method(:return_scene))
  end

  def combine_ok
    @item_window.combining = true
    @combine = true
    @category_window.item_window = @item_window
    @options_window.deactivate.unselect
    @category_window.activate.select(0)
  end

  def use_ok
    @item_window.combining = false
    @category_window.item_window = @item_window
    @options_window.deactivate.unselect
    @category_window.activate.select(0)
  end

  def create_category_window
    @category_window = Window_ItemKategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @help_window.height + @options_window.height
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:on_category_cancel))
  end

  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy
    @item_window = Window_ItemListe.new(0, wy, Graphics.width, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @category_window.deactivate.unselect
  end

  def on_category_ok
    @item_window.activate
    @item_window.select_last
  end

  def on_category_cancel
    @item_window.deactivate.unselect
    @item_window.accepted_items.clear
    @category_window.deactivate.unselect
    @options_window.activate.select(0)
  end

  def on_item_ok
    k = [@item_window.item.id, :item] if @item_window.item.is_a?(RPG::Item)
    k = [@item_window.item.id, :weapon] if @item_window.item.is_a?(RPG::Weapon)
    k = [@item_window.item.id, :armor] if @item_window.item.is_a?(RPG::Armor)
    if !@item_window.combining
      @options_window.deactivate
      $game_party.last_item.object = item
      determine_item
    else
      if @item_window.accepted_items.include?(k)
        @item_window.accepted_items.delete(k)
      else
        @item_window.accepted_items.push(k)
      end
      if @item_window.accepted_items.size == 2
        check_combinations(@item_window.accepted_items[0], @item_window.accepted_items[1])
        @item_window.refresh
      else
        @item_window.refresh
        @item_window.activate
      end
    end
  end

  def check_combinations(id1, id2)
    EFE::COMBINATIONS.each {|i|
      if (id1 == i[0] || id1 == i[1]) && (id2 == i[0] || id2 == i[1])
        @combineitem1 = $data_items[i[0][0]] if i[0][1] == :item
        @combineitem1 = $data_weapons[i[0][0]] if i[0][1] == :weapon
        @combineitem1 = $data_armors[i[0][0]] if i[0][1] == :armor
        @combineitem2 = $data_items[i[1][0]] if i[1][1] == :item
        @combineitem2 = $data_weapons[i[1][0]] if i[1][1] == :weapon
        @combineitem2 = $data_armors[i[1][0]] if i[1][1] == :armor
        @resultitem = $data_items[i[2][0]] if i[2][1] == :item
        @resultitem = $data_weapons[i[2][0]] if i[2][1] == :weapon
        @resultitem = $data_armors[i[2][0]] if i[2][1] == :armor
        @item_window.accepted_items.clear
        @item_window.refresh
        @item_window.activate
        $game_party.lose_item(@combineitem1, 1)
        $game_party.lose_item(@combineitem2, 1)
        $game_party.gain_item(@resultitem, 1)
        messagebox(EFE::SUCCESS, 400)
        return
      end
    }
    @item_window.accepted_items.clear
    @item_window.refresh
    @item_window.activate
  end

  def on_item_cancel
    @item_window.unselect
    @category_window.activate
  end

  def play_se_for_item
    Sound.play_use_item
  end

  def use_item
    super
    @item_window.redraw_current_item
  end
end

=begin
===============================================================================
 MessageBox by efeberk
 Version: RGSS3
===============================================================================
 This script will allow to open a new messagebox window only with a text.
--------------------------------------------------------------------------------

Call MessageBox in Script:

messagebox(text, width)

width : width of the window

=end

class Window_MessageBox < Window_Base

  def initialize(x, y, text, width)
    super(x, y, width, fitting_height(1))
    refresh(text)
  end


  def refresh(text)
    draw_text(0, 0, contents_width, line_height, text, 1)
  end

end

class Scene_MessageBox < Scene_Base

  def start
    super
    create_message_window
    create_background
  end

  def prepare(text, width)
    @text = text
    @width = width
  end

  def update
    super
    if Input.repeat?(:B) || Input.repeat?(:C)
      SceneManager.return
    end
  end

  def create_message_window
    @message_window = Window_MessageBox.new(0, 0, @text, @width)
    @message_window.width = @width
    @message_window.x = (Graphics.width / 2) - (@message_window.width / 2)
    @message_window.y = (Graphics.height / 2) - (@message_window.height / 2)
  end

  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(100, 100, 100, 128)
  end
end

def messagebox(text, width)
  SceneManager.call(Scene_MessageBox)
  SceneManager.scene.prepare(text, width)
end
