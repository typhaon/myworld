class Cell < ActiveRecord::Base
  belongs_to :terrain
  belongs_to :world

    def create_terrain(terrain_name)
    if terrain_name == 'water'
      tile = 'blue'
    elsif terrain_name == 'dirt'
      tile = 'burlywood'
    else
      tile = 'limegreen'
    end
    tile
  end
end
