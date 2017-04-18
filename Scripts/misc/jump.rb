#------------------------------------------------------------------------------#
#  Galv's Jump Ability
#------------------------------------------------------------------------------#
#  For: RPGMAKER VX ACE
#  Version 1.6
#------------------------------------------------------------------------------#
#  2013-06-02 - Version 1.6 - fixed a bug with region block jumping
#  2013-03-14 - Version 1.5 - fixed priority bug when jumping behind things
#                           - cleaned up code a bit
#  2013-01-15 - Version 1.4 - added follower jumping
#  2013-01-11 - Version 1.3 - added ability to make event pages block jumping
#  2012-12-05 - Version 1.2 - fixed some more bugs
#  2012-11-30 - Version 1.1 - fixed jumping in vehicles bug
#  2012-11-29 - Version 1.0 - release
#------------------------------------------------------------------------------#
#  This script allows the player to jump with the press of a button. The player
#  will jump as far as their max distance will take them without landing on a
#  blocked tile. Use regions to block players jumping completely to prevent the
#  player from doing things like jumping between rooms.
#------------------------------------------------------------------------------#
#  INSTRUCTIONS:
#  Put script under Materials and above Main
#  Read options and settings below.
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
#  COMMENT FOR EVENT (Must be first event command)
#------------------------------------------------------------------------------#
#
#  <block>
#
#  add this comment as the first event command of a page to make it unable to
#  be jumped over. Change the page to a new event page without the comment when
#  you want it to be jumpable.

#------------------------------------------------------------------------------#
#  NOTETAG FOR ACTORS, ARMORS, WEAPONS
#------------------------------------------------------------------------------#
#
#  <jump_bonus: x>        # Adds that many tiles to jump distance
#
#------------------------------------------------------------------------------#
#  Only the jump bonus for the party leader and his/her equips are calculated
#------------------------------------------------------------------------------#
#  SCRIPT CALL:
#  You can change an actor's jump bonus (that was set with the notetag) during
#  the game with a script call:
#
#  jump_bonus(actor_id,jump_bonus)
#
#  EXAMPLE:
#  jump_bonus(3,2)         # Changes actor 3's jump bonus to 2
#------------------------------------------------------------------------------#

($imported ||= {})["Galvs_Jump_Ability"] = true
module Galv_Jump

#------------------------------------------------------------------------------#
#  SCRIPT SETUP OPTIONS
#------------------------------------------------------------------------------#

  DISABLE_SWITCH = 1         # Cannot jump when this switch is ON

  BUTTON = :X                # Button to press to jump. :X is "a" key.

  DEFAULT_DISTANCE = 2       # Distance player can jump with no bonuses
  SPRINT_BONUS = 1           # Distance increased with a running jump

  JUMP_SE = ["drop", 50, 120]

  MAX_JUMP_BONUS = 3         # The maximum bonus you can get from equips/actors

  NO_JUMP_REGIONS = [1, 2, 3] # Region ID's that the player cannot jump over

#------------------------------------------------------------------------------#
#  END SCRIPT SETUP OPTIONS
#------------------------------------------------------------------------------#

end

class RPG::BaseItem
  def jump_bonus
    if @jump_bonus.nil?
      if @note =~ /<jump_bonus: (.*)>/i
        @jump_bonus = $1.to_i
      else
        @jump_bonus = 0
      end
    end
    @jump_bonus
  end
end # RPG::BaseItem


class Game_Player < Game_Character
  attr_accessor :priority_type

  alias galv_jump_player_initialize initialize
  def initialize
    galv_jump_player_initialize
    @jump_equip_bonus = 0
  end

  alias galv_jump_player_refresh refresh
  def refresh
    get_jump_equip_bonus
    galv_jump_player_refresh
  end

  def get_jump_equip_bonus
    bonus = 0 + $game_party.leader.jump_bonus
    $game_party.leader.equips.each { |eq| bonus += eq.jump_bonus if !eq.nil?}
    @jump_equip_bonus = [bonus, Galv_Jump::MAX_JUMP_BONUS].min
  end

  alias galv_jump_move_by_input move_by_input
  def move_by_input
    return if jumping?
    @priority_type = 1 if !jumping?
    galv_jump_move_by_input
    if !$game_switches[Galv_Jump::DISABLE_SWITCH] && Input.trigger?(Galv_Jump::BUTTON)
      do_jump if !$game_map.interpreter.running? && !jumping? && normal_walk?
    end
  end

  def do_jump
    get_bonuses
    @distance = Galv_Jump::DEFAULT_DISTANCE + @jump_bonus
    check_region
    check_distance
    if @can_jump
      RPG::SE.new(Galv_Jump::JUMP_SE[0], Galv_Jump::JUMP_SE[1], Galv_Jump::JUMP_SE[2]).play
      jump(@jump_x, @jump_y)
      @followers.each { |f| f.jump(@x - f.x, @y - f.y) }
    end
  end

  def get_bonuses
    @jump_bonus = 0 + @jump_equip_bonus
    @jump_bonus += Galv_Jump::SPRINT_BONUS if dash? && moving?
  end

  def check_region
    @max_x = 0
    @max_y = 0
    case @direction
    when 2
      @max_y = @distance
      (@distance+1).times { |i| return @max_y = i if stopper?(@x, @y+i+1) }
    when 4
      @max_x = -@distance
      (@distance+1).times { |i| return @max_x = -i if stopper?(@x-i-1, @y) }
    when 6
      @max_x = @distance
      (@distance+1).times { |i| return @max_x = i if stopper?(@x+i+1, @y) }
    when 8
      @max_y = -@distance
      (@distance+1).times { |i| return @max_y = -i if stopper?(@x, @y-i-1) }
    end
  end

  def stopper?(x, y)
    Galv_Jump::NO_JUMP_REGIONS.include?($game_map.region_id(x, y)) ||
      !$game_map.stopper_event?(x, y)
  end

  def canpass?(x, y)
    map_passable?(x, y, @direction) &&
      $game_map.blocking_event?(x, y) ||
      Galv_Jump::NO_JUMP_REGIONS.include?($game_map.region_id(x, y))
  end

  def check_distance
    @jump_x = 0
    @jump_y = 0
    ch = []
    @can_jump = true

    case @direction
    when 2
      @jump_y = @distance
      @distance.times { |i| ch << @jump_y - i if canpass?(@x, @y + @jump_y - i) }
      ch.delete_if {|x| x > @max_y }
      @jump_y = ch.max if !ch.empty?
    when 4
      @jump_x = -@distance
      @distance.times { |i| ch << @jump_x + i if canpass?(@x + @jump_x + i, @y) }
      ch.delete_if {|x| x < @max_x }
      @jump_x = ch.min if !ch.empty?
    when 6
      @jump_x = @distance
      @distance.times { |i| ch << @jump_x - i if canpass?(@x + @jump_x - i, @y) }
      ch.delete_if {|x| x > @max_x }
      @jump_x = ch.max if !ch.empty?
    when 8
      @jump_y = -@distance
      @distance.times { |i| ch << @jump_y + i if canpass?(@x, @y + @jump_y + i) }
      ch.delete_if {|x| x < @max_y }
      @jump_y = ch.min if !ch.empty?
    end
    if ch.empty?
      @jump_y = 0
      @jump_x = 0
      @can_jump = false
    end
  end

  def jump(x_plus, y_plus)
    @priority_type = 1.5
    super
  end
end # Game_Player < Game_Character


class Game_Map
  def blocking_event?(x, y)
    events_xy(x, y).each { |e| return false if e.priority_type == 1 }
    return true
  end

  def stopper_event?(x, y)
    events_xy(x, y).each { |e|
      next if e.list.nil?
      return false if e.list[0].code == 108 && e.list[0].parameters[0] == "<block>"
    }
    return true
  end
end # Game_Map


class Game_Actor < Game_Battler
  attr_accessor :jump_bonus

  alias galv_jump_actor_initialize initialize
  def initialize(actor_id)
    galv_jump_actor_initialize(actor_id)
    @jump_bonus = $data_actors[actor_id].jump_bonus
  end
end # Game_Actor < Game_Battler


class Scene_Menu < Scene_MenuBase
  def return_scene
    $game_player.refresh
    super
  end
end # Scene_Menu < Scene_MenuBase

class Game_Interpreter
  def jump_bonus(actor, bonus)
    $game_actors[actor].jump_bonus = bonus
    $game_player.refresh
  end
end # Game_Interpreter
