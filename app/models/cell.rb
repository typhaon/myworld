class Cell < ActiveRecord::Base
  belongs_to :terrain
  belongs_to :world

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
