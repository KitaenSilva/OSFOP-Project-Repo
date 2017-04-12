#==============================================================================
# ** Window_NameInput
#------------------------------------------------------------------------------
#  This window is used to select text characters on the name input screen.
#==============================================================================

class Window_NameInput < Window_Selectable
  #--------------------------------------------------------------------------
  # * Character Tables (Latin)
  #--------------------------------------------------------------------------
  LATIN1 = [ "A", "B", "C", "D", "E",  "a", "b", "c", "d", "e",
             "F", "G", "H", "I", "J",  "f", "g", "h", "i", "j",
             "K", "L", "M", "N", "O",  "k", "l", "m", "n", "o",
             "P", "Q", "R", "S", "T",  "p", "q", "r", "s", "t",
             "U", "V", "W", "X", "Y",  "u", "v", "w", "x", "y",
             "Z", "[", "]", "^", "_",  "z", "{", "}", "|", "~",
             "0", "1", "2", "3", "4",  "!", "#", "$", "%", "&",
             "5", "6", "7", "8", "9",  "(", ")", "*", "+", "-",
             "/", "=", "@", "<", ">",  ":", ";", " ", "Page", "OK"]
  LATIN2 = [ "\u00C1", "\u00C9", "\u00CD", "\u00D3", "\u00DA",  "\u00E1", "\u00E9", "\u00ED", "\u00F3", "\u00FA",
             "\u00C0", "\u00C8", "\u00CC", "\u00D2", "\u00D9",  "\u00E0", "\u00E8", "\u00EC", "\u00F2", "\u00F9",
             "\u00C2", "\u00CA", "\u00CE", "\u00D4", "\u00DB",  "\u00E2", "\u00EA", "\u00EE", "\u00F4", "\u00FB",
             "\u00C4", "\u00CB", "\u00CF", "\u00D6", "\u00DC",  "\u00E4", "\u00EB", "\u00EF", "\u00F6", "\u00FC",
             "\u0100", "\u0112", "\u012A", "\u014C", "\u016A",  "\u0101", "\u0113", "\u012B", "\u014D", "\u016B",
             "\u00C3", "\u00C5", "\u00C6", "\u00C7", "\u00D0",  "\u00E3", "\u00E5", "\u00E6", "\u00E7", "\u00F0",
             "\u00D1", "\u00D5", "\u00D8", "\u0160", "\u0174",  "\u00F1", "\u00F5", "\u00F8", "\u0161", "\u0175",
             "\u00DD", "\u0176", "\u0178", "\u017D", "\u00DE",  "\u00FD", "\u00FF", "\u0177", "\u017E", "\u00FE",
             "\u0132", "\u0152", "\u0133", "\u0153", "\u00DF",  "\u00AB", "\u00BB", " ", "Page", "OK"]
  #--------------------------------------------------------------------------
  # * Character Tables (Japanese)
  #--------------------------------------------------------------------------
  JAPAN1 = [ "\u3042", "\u3044", "\u3046", "\u3048", "\u304A",  "\u304C", "\u304E", "\u3050", "\u3052", "\u3054",
             "\u304B", "\u304D", "\u304F", "\u3051", "\u3053",  "\u3056", "\u3058", "\u305A", "\u305C", "\u305E",
             "\u3055", "\u3057", "\u3059", "\u305B", "\u305D",  "\u3060", "\u3062", "\u3065", "\u3067", "\u3069",
             "\u305F", "\u3061", "\u3064", "\u3066", "\u3068",  "\u3070", "\u3073", "\u3076", "\u3079", "\u307C",
             "\u306A", "\u306B", "\u306C", "\u306D", "\u306E",  "\u3071", "\u3074", "\u3077", "\u307A", "\u307D",
             "\u306F", "\u3072", "\u3075", "\u3078", "\u307B",  "\u3041", "\u3043", "\u3045", "\u3047", "\u3049",
             "\u307E", "\u307F", "\u3080", "\u3081", "\u3082",  "\u3063", "\u3083", "\u3085", "\u3087", "\u308E",
             "\u3084", "\u3086", "\u3088", "\u308F", "\u3093",  "\u30FC", "\uFF5E", "\u30FB", "\uFF1D", "\u2606",
             "\u3089", "\u308A", "\u308B", "\u308C", "\u308D",  "\u3094", "\u3092", "\u3000", "\u30AB\u30CA", "\u6C7A\u5B9A"]
  JAPAN2 = [ "\u30A2", "\u30A4", "\u30A6", "\u30A8", "\u30AA",  "\u30AC", "\u30AE", "\u30B0", "\u30B2", "\u30B4",
             "\u30AB", "\u30AD", "\u30AF", "\u30B1", "\u30B3",  "\u30B6", "\u30B8", "\u30BA", "\u30BC", "\u30BE",
             "\u30B5", "\u30B7", "\u30B9", "\u30BB", "\u30BD",  "\u30C0", "\u30C2", "\u30C5", "\u30C7", "\u30C9",
             "\u30BF", "\u30C1", "\u30C4", "\u30C6", "\u30C8",  "\u30D0", "\u30D3", "\u30D6", "\u30D9", "\u30DC",
             "\u30CA", "\u30CB", "\u30CC", "\u30CD", "\u30CE",  "\u30D1", "\u30D4", "\u30D7", "\u30DA", "\u30DD",
             "\u30CF", "\u30D2", "\u30D5", "\u30D8", "\u30DB",  "\u30A1", "\u30A3", "\u30A5", "\u30A7", "\u30A9",
             "\u30DE", "\u30DF", "\u30E0", "\u30E1", "\u30E2",  "\u30C3", "\u30E3", "\u30E5", "\u30E7", "\u30EE",
             "\u30E4", "\u30E6", "\u30E8", "\u30EF", "\u30F3",  "\u30FC", "\uFF5E", "\u30FB", "\uFF1D", "\u2606",
             "\u30E9", "\u30EA", "\u30EB", "\u30EC", "\u30ED",  "\u30F4", "\u30F2", "\u3000", "\u82F1\u6570", "\u6C7A\u5B9A"]
  JAPAN3 = [ "\uFF21", "\uFF22", "\uFF23", "\uFF24", "\uFF25",  "\uFF41", "\uFF42", "\uFF43", "\uFF44", "\uFF45",
             "\uFF26", "\uFF27", "\uFF28", "\uFF29", "\uFF2A",  "\uFF46", "\uFF47", "\uFF48", "\uFF49", "\uFF4A",
             "\uFF2B", "\uFF2C", "\uFF2D", "\uFF2E", "\uFF2F",  "\uFF4B", "\uFF4C", "\uFF4D", "\uFF4E", "\uFF4F",
             "\uFF30", "\uFF31", "\uFF32", "\uFF33", "\uFF34",  "\uFF50", "\uFF51", "\uFF52", "\uFF53", "\uFF54",
             "\uFF35", "\uFF36", "\uFF37", "\uFF38", "\uFF39",  "\uFF55", "\uFF56", "\uFF57", "\uFF58", "\uFF59",
             "\uFF3A", "\uFF3B", "\uFF3D", "\uFF3E", "\uFF3F",  "\uFF5A", "\uFF5B", "\uFF5D", "\uFF5C", "\uFF5E",
             "\uFF10", "\uFF11", "\uFF12", "\uFF13", "\uFF14",  "\uFF01", "\uFF03", "\uFF04", "\uFF05", "\uFF06",
             "\uFF15", "\uFF16", "\uFF17", "\uFF18", "\uFF19",  "\uFF08", "\uFF09", "\uFF0A", "\uFF0B", "\uFF0D",
             "\uFF0F", "\uFF1D", "\uFF20", "\uFF1C", "\uFF1E",  "\uFF1A", "\uFF1B", "\u3000", "\u304B\u306A", "\u6C7A\u5B9A"]
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(edit_window)
    super(edit_window.x, edit_window.y + edit_window.height + 8,
          edit_window.width, fitting_height(9))
    @edit_window = edit_window
    @page = 0
    @index = 0
    refresh
    update_cursor
    activate
  end
  #--------------------------------------------------------------------------
  # * Get Text Table
  #--------------------------------------------------------------------------
  def table
    return [JAPAN1, JAPAN2, JAPAN3] if $game_system.japanese?
    return [LATIN1, LATIN2]
  end
  #--------------------------------------------------------------------------
  # * Get Text Character
  #--------------------------------------------------------------------------
  def character
    @index < 88 ? table[@page][@index] : ""
  end
  #--------------------------------------------------------------------------
  # * Determining if Page Changed and Cursor Location
  #--------------------------------------------------------------------------
  def is_page_change?
    @index == 88
  end
  #--------------------------------------------------------------------------
  # * Determine Cursor Location: Confirmation
  #--------------------------------------------------------------------------
  def is_ok?
    @index == 89
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Displaying Item
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.x = index % 10 * 32 + index % 10 / 5 * 16
    rect.y = index / 10 * line_height
    rect.width = 32
    rect.height = line_height
    rect
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(normal_color)
    90.times {|i| draw_text(item_rect(i), table[@page][i], 1) }
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    cursor_rect.set(item_rect(@index))
  end
  #--------------------------------------------------------------------------
  # * Determine if Cursor is Moveable
  #--------------------------------------------------------------------------
  def cursor_movable?
    active
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #     wrap : Wraparound allowed
  #--------------------------------------------------------------------------
  def cursor_down(wrap)
    if @index < 80 or wrap
      @index = (index + 10) % 90
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #     wrap : Wraparound allowed
  #--------------------------------------------------------------------------
  def cursor_up(wrap)
    if @index >= 10 or wrap
      @index = (index + 80) % 90
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Right
  #     wrap : Wraparound allowed
  #--------------------------------------------------------------------------
  def cursor_right(wrap)
    if @index % 10 < 9
      @index += 1
    elsif wrap
      @index -= 9
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Left
  #     wrap : Wraparound allowed
  #--------------------------------------------------------------------------
  def cursor_left(wrap)
    if @index % 10 > 0
      @index -= 1
    elsif wrap
      @index += 9
    end
  end
  #--------------------------------------------------------------------------
  # * Move to Next Page
  #--------------------------------------------------------------------------
  def cursor_pagedown
    @page = (@page + 1) % table.size
    refresh
  end
  #--------------------------------------------------------------------------
  # * Move to Previous Page
  #--------------------------------------------------------------------------
  def cursor_pageup
    @page = (@page + table.size - 1) % table.size
    refresh
  end
  #--------------------------------------------------------------------------
  # * Cursor Movement Processing
  #--------------------------------------------------------------------------
  def process_cursor_move
    last_page = @page
    super
    update_cursor
    Sound.play_cursor if @page != last_page
  end
  #--------------------------------------------------------------------------
  # * Handling Processing for OK and Cancel Etc.
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    process_jump if Input.trigger?(:A)
    process_back if Input.repeat?(:B)
    process_ok   if Input.trigger?(:C)
  end
  #--------------------------------------------------------------------------
  # * Jump to OK
  #--------------------------------------------------------------------------
  def process_jump
    if @index != 89
      @index = 89
      Sound.play_cursor
    end
  end
  #--------------------------------------------------------------------------
  # * Go Back One Character
  #--------------------------------------------------------------------------
  def process_back
    Sound.play_cancel if @edit_window.back
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    if !character.empty?
      on_name_add
    elsif is_page_change?
      Sound.play_ok
      cursor_pagedown
    elsif is_ok?
      on_name_ok
    end
  end
  #--------------------------------------------------------------------------
  # * Add Text to Name
  #--------------------------------------------------------------------------
  def on_name_add
    if @edit_window.add(character)
      Sound.play_ok
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Decide Name
  #--------------------------------------------------------------------------
  def on_name_ok
    if @edit_window.name.empty?
      if @edit_window.restore_default
        Sound.play_ok
      else
        Sound.play_buzzer
      end
    else
      Sound.play_ok
      call_ok_handler
    end
  end
end
