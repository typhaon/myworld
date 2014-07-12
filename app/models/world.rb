class World < ActiveRecord::Base

def create_terrain(terrain_id)
    if terrain_id == 0
      tile = 'blue'
    elsif terrain_id == 1
      tile = 'burlywood'
    elsif terrain_id == 2
      tile = 'limegreen'
    elsif terrain_id == 3
      tile = 'slategray'
    else
    end
    tile
  end

end

