#------------------------------------------------------------------------------#
#  Galv's Messages Without Wait
#------------------------------------------------------------------------------#
#  For: RPGMAKER VX ACE
#  Version 1.1
#------------------------------------------------------------------------------#
#  2012-10-24 - Version 1.1 - alias names updated for compatibility
#  2012-10-21 - Version 1.0 - release
#------------------------------------------------------------------------------#
#  Changes message system to allow the player to move around while message boxes
#  are on the screen. These dialog boxes disappear after moving a certain
#  distance - much like the game Chrono Trigger.
#
#  INSTRUCTIONS
#  Flip the disable switch ON to make the messages stop player movement again.
#  See script setup options for settings.
#------------------------------------------------------------------------------#
 
$imported = {} if $imported.nil?
$imported["No_Wait_Messages"] = true
 
module Message_wait
 
#------------------------------------------------------------------------------#
#  SCRIPT SETUP OPTIONS
#------------------------------------------------------------------------------#
 
  DISABLE_SWITCH = 37            # Switch ID. Turn switch ON to disable script.
 
  MESSAGE_RANGE = 5   # tiles   # Distance in tiles before dialogue disappears.
   
  RANGE_VAR = 1       # var ID  # A variable that can modify the MESSAGE_RANGE
                                # value in-game in case required. Make 0 if you
                                # do not want to use this. Never make the range
                                # 1 or less... you'll break your game. Heh.
   
#------------------------------------------------------------------------------#
#  SCRIPT SETUP OPTIONS
#------------------------------------------------------------------------------#
 
end
 
 
class Window_Message < Window_Base
 
  alias galv_msgwait_update update
  def update
    close_window if out_of_range? && $game_message.busy? && !$game_switches[Message_wait::DISABLE_SWITCH]
    galv_msgwait_update
  end
   
  alias galv_msgwait_open open
  def open
    @mod_y = @mod_x = 0
    case $game_player.direction
    when 8
      @mod_y = -1
    when 6
      @mod_x = 1
    when 4
      @mod_x = -1
    when 2
      @mod_y = +1
    end
    @get_x = $game_player.x + @mod_x
    @get_y = $game_player.y + @mod_y
    galv_msgwait_open
  end
   
  def close_window
    close
  end
 
  def out_of_range?
    return false if @get_x.nil? || @get_y.nil?
    @range = Message_wait::MESSAGE_RANGE
    @range_mod = $game_variables[Message_wait::RANGE_VAR]
    return true if @get_x > $game_player.x + @range + @range_mod
    return true if @get_x < $game_player.x - @range - @range_mod
    return true if @get_y < $game_player.y - @range - @range_mod
    return true if @get_y > $game_player.y + @range + @range_mod
  end
 
#------------------------------------------------------------------------------#
#  OVERWRITES
#------------------------------------------------------------------------------#
  def process_all_text
    open_and_wait
    text = convert_escape_characters($game_message.all_text)
    pos = {}
    new_page(text, pos)
    process_character(text.slice!(0, 1), text, pos) until text.empty? || close?
  end
 
  def input_pause
    self.pause = true
    wait(10)
    Fiber.yield until Input.trigger?(:B) || Input.trigger?(:C) || close?
    Input.update
    self.pause = false
  end
#------------------------------------------------------------------------------#
 
end # Window_Message < Window_Base
 
 
class Game_Interpreter
   
  alias galv_msgwait_wait_for_message wait_for_message
  def wait_for_message
    if !$game_switches[Message_wait::DISABLE_SWITCH]
      Fiber.yield while $game_message.num_input? || $game_message.choice? || $game_message.item_choice?
      return 
    end
    galv_msgwait_wait_for_message
  end
   
end # Game_Interpreter
 
 
class Game_Player < Game_Character
   
  alias galv_msgwait_movable? movable?
  def movable?
    if !$game_switches[Message_wait::DISABLE_SWITCH]
      return false if moving?
      return false if @move_route_forcing || @followers.gathering?
      return false if @vehicle_getting_on || @vehicle_getting_off
      return false if vehicle && !vehicle.movable?
      return true
    end
    galv_msgwait_movable?
  end
 
  alias galv_msgwait_start_map_event start_map_event
  def start_map_event(x, y, triggers, normal)
    return if $game_message.busy? && !$game_switches[Message_wait::DISABLE_SWITCH]
    galv_msgwait_start_map_event(x, y, triggers, normal)
  end
end # Game_Player < Game_Character
 
 
class Game_Event < Game_Character
   
  alias galv_msgwait_lock lock
  def lock
    return turn_toward_player if !$game_switches[Message_wait::DISABLE_SWITCH]
    galv_msgwait_lock
  end
 
end # Game_Event < Game_Character