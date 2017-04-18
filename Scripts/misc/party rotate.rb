############################################
#                                          #
#     ONE BUTTON PARTY ROTATE SCRIPT       #
#                                          #
#       v1.0 for RPG Maker VX Ace          #
#                                          #
# Created by Jason "Wavelength" Commander  #
#                                          #
############################################

# "When the world keeps spinning round, my world's upside down...
#     ...and I wouldn't change a thing"
#                                     ~ Lifehouse


############################################
#                                          #
#           ABOUT THIS SCRIPT              #
#                                          #
############################################

# This script allows the player to rotate the party's formation
#     on the map, using a single button press.  No need for
#     the player to visit the menu to select a party leader,
#     for example.

# Options are included in the script that you can use to control
#     how many party members should be used in the rotation logic,
#     whether to skip KO'ed party members as party leaders, and
#     which button activates the Party Rotate.

# This script is compatible with nearly all other scripts.
#     Use caution with other scripts that assign a function
#     to whatever button you're assigning to "Party Rotate".


############################################
#                                          #
#              TERMS OF USE                #
#                                          #
############################################

# Free to use for non-commercial projects - just credit me

# Unlike most of my other scripts, you may also freely use this
#     script in commercial projects - just credit me.

# You may freely share or modify this script, but you cannot
#     sell it (even if modified) without my written permission

# Please preserve the header (with version #) and terms of use;
#     besides that, feel free to remove any commenting you please


############################################
#                                          #
#         HOW TO USE THIS SCRIPT           #
#                                          #
############################################

# This script should be placed in the "Materials" section
#     of the script editor.  In general, this script should
#     be placed below other scripts that modify Game_Map.


############################################
#                                          #
#     ONE BUTTON PARTY ROTATE SETUP        #
#                                          #
############################################

module Rotate

# All of the following options can be left alone if desired, or you can
#   modify them to better customize the script to your game.

# Choose the button players can use to instantly rotate the party.
#   Acceptable buttons are as follows:
#   :A :B :C :X :Y :Z :L :R (NOTE: these correspond to "game buttons" as
#                               defined on the F1 Keyboard/Gamepad tabs)
#   :DOWN :LEFT :RIGHT :UP
#   :SHIFT :CTRL :ALT
#   :F5 :F6 :F7 :F8 :F9

  Button = :Y

# This is the maximum number of members you want to be rotated when
#   the player hits the "Party Rotate" button.  For most games this
#   should be equal to the size of the active party, but there might
#   be reasons you'd want to set it differently.

  Max_Members = 4

# Set this option to "true" if you want KOed party members to be
#   "skipped" if the Party Rotate would make them the party leader.
#   Set it to "false" to allow KOed members to be the party leader
#   when a Party Rotate is done.

  Skip_If_KO = true

# Set the sounds that will be played when the player presses the
#   Party Rotate button.  Enter the filename of the sound, the
#   volume, and the pitch, in that order.  "Disallow Sound" will
#   be played if the Party Rotate can't be done (e.g. 1-member party).

  Rotate_Sound = ["Audio/SE/Recovery", 80, 100]
  Disallow_Sound = ["Audio/SE/Buzzer1", 80, 100]

end

class Scene_Map < Scene_Base

  #--------------------------------------------------------------------------
  # * Update Scene Transition
  #--------------------------------------------------------------------------
  alias :one_button_update :update_scene
  def update_scene
    one_button_update
    if Input.trigger?(Rotate::Button)
      one_button_rotate unless scene_changing?
    end
  end

  #--------------------------------------------------------------------------
  # * Perform the One Button Rotate
  #--------------------------------------------------------------------------
  def one_button_rotate
    ok = true
    count = [$game_party.members.size, Rotate::Max_Members].min
    # If there are fewer than 2 party members, can't do a swap
    if count <= 1
      ok = false
    end
    # If all other party members are KOed, can't do a swap
    if Rotate::Skip_If_KO
      ok_swap = false
      for i in 1..(count - 1)
        unless $game_party.members[i].death_state?
          ok_swap = true
        end
      end
      if ok_swap == false
        ok = false
      end
    end
    # Do the following if a swap is possible
    if ok
      ok_leader = false
      # Do the following loop until an acceptable leader is found
      while (!ok_leader) do
        for i in 0..(count - 2)
          $game_party.swap_order(i, i + 1)
        end
        # Acceptable leader unless "Skip if KO'ed" is TRUE and member is KOed
        unless (($game_party.members[0].death_state?) and (Rotate::Skip_If_KO))
          ok_leader = true
        end
        Audio.se_play(Rotate::Rotate_Sound[0], Rotate::Rotate_Sound[1], Rotate::Rotate_Sound[2])
      end
    # Otherwise, simply play the Disallow Sound
    else
      Audio.se_play(Rotate::Disallow_Sound[0], Rotate::Disallow_Sound[1], Rotate::Disallow_Sound[2])
    end
  end

end
