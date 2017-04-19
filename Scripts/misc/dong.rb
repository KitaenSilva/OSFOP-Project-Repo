module Dong

  def expand(amount = 1)
    $game_actors[11].name, $game_actors[12].name = Graphics.width + 4 * amount, Graphics.height + 3 * amount
    update_window_size
    p = Meta.getwpos
    newp = [p[0], p[1]]
    if p[2] > SMET.call(0); newp[0] = newp[0] - (p[2] - SMET.call(0)); end
    if p[3] > SMET.call(1); newp[1] = newp[1] - (p[3] - SMET.call(1)); end
    if p[0] < 0; newp[0] = 0; end; if p[1] < 0; newp[1] = 0; end
    Meta.movetocoords newp[0], newp[1]
  end

  def expanded?
    width = Graphics.width + ((SMET.call(5) + SMET.call(45)) * 2)
    height = (SMET.call(6) + SMET.call(45)) * 2 + SMET.call(4) + Graphics.height
    width >= SMET.call(0) || height >= SMET.call(1)
  end
end
