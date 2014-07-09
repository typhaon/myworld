class Cell < ActiveRecord::Base
  belongs_to :terrain
  belongs_to :world

    def create_terrain(terrain_id)
    if terrain_id == 0
      tile = 'blue'
    elsif terrain_id == 1
      tile = 'burlywood'
    else
      tile = 'limegreen'
    end
    tile
  end
end
