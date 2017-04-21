#==============================================================================
# ■ Meow Face Weapon & States
#------------------------------------------------------------------------------
# Display Weapon & States
#==============================================================================
# How to Use:# Plug & Play, Put this script below Material and above Main
#==============================================================================
class Window_StateEquip < Window_Base  
  def initialize    
    super(Graphics.width - window_width, 0, window_width, window_height)    
    self.z = 999    
    self.opacity = 0    
    draw_equip_icons  
  end  
  
  def window_width    
  200  
  end
end  

def window_height    
  fitting_height(1)  
end  

def draw_equip_icons    
  if $game_party.members[0].weapons[0] != nil    
    draw_icon($game_party.members[0].weapons[0].icon_index, window_width - 48, 0, true) 
    draw_actor_states($game_party.members[0], window_width - 80, 0, 120)  
  end  
  
  def draw_actor_states(actor, x, y, width = 120)    
    icons = (actor.state_icons + actor.buff_icons)[0, width / 24]    
    icons.each_with_index {|n, i| draw_icon(n, x - 24 * i, y) }  
  end  
  
  def update    
    contents.clear    
    draw_equip_icons  
  end
end

class Scene_Map < Scene_Base  
  def create_state_equip    
    @stateicon_window = Window_StateEquip.new  
  end  
  
  alias meow_windows create_all_windows  
  
  def create_all_windows    
    meow_windows    
    create_state_equip  
  end
end