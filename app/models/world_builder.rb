class WorldBuilder

  TERRAINS = ['mountain']
  GRASS = ['seed_grass']
  TREES = ['tree']


  attr_reader :rows, :columns
  attr_accessor :cells

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @cells = []

    rows.times do |row|
      cells << []

      columns.times do
        cells[row] << 'water'
      end
    end
  end

  def cell_count
    rows * columns
  end

  def mountain_seed_count
    cell_count / 1500
  end

  def grass_seed_count
    cell_count / 1000
  end

  def tree_seed_count
    cell_count / 5
  end

  def neighbors(cells, row, col)
    neighboring_cells = Hash.new
    max_col = @columns
    max_row = @rows

    if col > 0
      neighboring_cells['west'] = cells[row][col - 1]
    end

    if col < max_col - 1
      neighboring_cells['east'] = cells[row][col + 1]
    end

    if col < max_col - 1 && row < max_row - 1
      neighboring_cells['south_east'] = cells[row + 1][col + 1]
    end

    if col > 0 && row < max_row - 1
      neighboring_cells['south_west'] = cells[row + 1][col - 1]
    end

    if row < max_row - 1
      neighboring_cells['south'] = cells[row + 1][col]
    end

    if row > 0 && col < max_col - 1
      neighboring_cells['north_east'] = cells[row - 1][col + 1]
    end

    if row > 0 && col > 0
      neighboring_cells['north_west'] = cells[row - 1][col - 1]
    end

    if row > 0
      neighboring_cells['north'] = cells[row - 1][col]
    end
    neighboring_cells
  end

  def basic_neighbors(cells, row, col)
    basic_neighboring_cells = Hash.new
    max_col = @columns
    max_row = @rows

    if row > 0
      basic_neighboring_cells['north'] = cells[row - 1][col]
    end

    if col < max_col - 1
      basic_neighboring_cells['east'] = cells[row][col + 1]
    end

    if row < max_row - 1
      basic_neighboring_cells['south'] = cells[row + 1][col]
    end

    if col > 0
      basic_neighboring_cells['west'] = cells[row][col - 1]
    end
    basic_neighboring_cells
  end


  def far_away(cell, row, col)
    far_away_cells = Hash.new
    max_col = @columns
    max_row = @rows

    if row < max_row - 4 && col < max_col - 4
      far_away_cells['south_west_corner'] = cells[row + 3][col]
      far_away_cells['north_east_corner'] = cells[row][col + 3]
      far_away_cells['south_east_corner'] = cells[row + 3][col + 3]
      far_away_cells['origin'] = cells[row][col]
    end
    far_away_cells
  end

  def save(name, max_rows, max_cols, id)
    cells_array = cells
    world = World.create(name: name, max_rows: max_rows, max_columns: max_cols, cells: cells_array, id: id)
  end

  #### METHODS HELEN & DAVID MADE FOR REFACTORING

  def make_interior_of_beach_tiles_and_dirt
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)
        turn_grass_next_to_water_to_sand(neighboring_cells, row_index, cell_index)
      end
    end
  end

  def turn_grass_next_to_water_to_sand(neighboring_cells, row_index, cell_index)
    if cells[row_index][cell_index] == 'grass' || cells[row_index][cell_index] == 'seed_grass'
      if neighboring_cells.count{|x| x[1] == 'sand_shallow_n'} > 0
        cells[row_index][cell_index] = 'dirt'
      elsif neighboring_cells.count{|x| x[1] == 'sand_shallow_s'} > 0
        cells[row_index][cell_index] = 'dirt'
      elsif neighboring_cells.count{|x| x[1] == 'sand_shallow_w'} > 0
        cells[row_index][cell_index] = 'dirt'
      elsif neighboring_cells.count{|x| x[1] == 'sand_shallow_e'} > 0
        cells[row_index][cell_index] = 'dirt'
      elsif neighboring_cells.count{|x| x[1] == 'sand_shallow_nw'} > 0
        cells[row_index][cell_index] = 'dirt'
      elsif neighboring_cells.count{|x| x[1] == 'sand_shallow_sw'} > 0
        cells[row_index][cell_index] = 'dirt'
      elsif neighboring_cells.count{|x| x[1] == 'sand_shallow_se'} > 0
        cells[row_index][cell_index] = 'dirt'
      elsif neighboring_cells.count{|x| x[1] == 'sand_shallow_ne'} > 0
        cells[row_index][cell_index] = 'dirt'
      end
    end
  end

  def is_grass_or_mountain?(cells, row_index, cell_index)
    ['grass', 'mountain'].include?(cells[row_index][cell_index])
  end

  def change_cell_to_grass_with_southeast_sand(neighboring_cells, cells, row_index, cell_index)
    if neighboring_cells["east"] == 'dirt'
      if neighboring_cells["south"] == 'dirt'
        cells[row_index][cell_index] = 'grass_sand_se'
      end
    end
    cells[row_index][cell_index]
  end

  def change_cell_to_grass_with_southwest_sand(neighboring_cells, cells, row_index, cell_index)
    if neighboring_cells["west"] == 'dirt'
      if neighboring_cells["south"] == 'dirt'
        cells[row_index][cell_index] = 'grass_sand_sw'
      end
    end
    cells[row_index][cell_index]
  end

  def change_cell_to_grass_with_northeast_sand(neighboring_cells, cells, row_index, cell_index)
    if neighboring_cells["east"] == 'dirt'
      if neighboring_cells["north"] == 'dirt'
        cells[row_index][cell_index] = 'grass_sand_ne'
      end
    end
    cells[row_index][cell_index]
  end

  def change_cell_to_grass_with_northwest_sand(neighboring_cells, cells, row_index, cell_index)
    if neighboring_cells["west"] == 'dirt'
      if neighboring_cells["north"] == 'dirt'
        cells[row_index][cell_index] = 'grass_sand_nw'
      end
    end
    cells[row_index][cell_index]
  end
#############

  def generate!

    ###### Make Seed Grass Fields
    grass_seed_count.times do
      row = rand(rows)
      col = rand(columns)

      if row > (rows/20) && row < (rows - rows/10)
        if col > (columns/20) && col < (columns - columns/10)
          if cells[row][col] == 'water'
            cells[row][col] = GRASS.sample
          end
        end
      end
    end

    2.times do
      cells.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          neighboring_cells = neighbors(cells, row_index, cell_index)

          if cells[row_index][cell_index] == 'seed_grass'
            tile = rand(4) + 1
            if tile == 4
              unless row_index + 1 == rows
                cells[row_index + 1][cell_index] = 'seed_grass'
              end
              unless row_index == 0
                cells[row_index - 1][cell_index] = 'seed_grass'
              end
              unless cell_index + 1 == columns
                cells[row_index][cell_index + 1] = 'seed_grass'
              end
              unless cell_index == 0
                cells[row_index][cell_index - 1] = 'seed_grass'
              end
            elsif tile == 3
              unless row_index + 1 == rows || cell_index == 0
                cells[row_index + 1][cell_index - 1] = 'seed_grass'
              end
              unless row_index == 0 || cell_index + 1 == columns
                cells[row_index - 1][cell_index + 1] = 'seed_grass'
              end
              unless row_index + 1 == rows || cell_index + 1 == columns
                cells[row_index + 1][cell_index + 1] = 'seed_grass'
              end
              unless row_index == 0 || cell_index == 0
                cells[row_index - 1][cell_index - 1] = 'seed_grass'
              end
            elsif tile == 2
              unless row_index + 1 == rows || cell_index + 1 == columns
                cells[row_index][cell_index + 1] = 'seed_grass'
              end
              unless row_index == 0 || cell_index == 0
                cells[row_index][cell_index - 1] = 'seed_grass'
              end
            else
            end
          end
        end
      end
    end

    ###### Make Seed Mountain Ranges
    mountain_seed_count.times do
      row = rand(rows)
      col = rand(columns)

      if row > (rows/20) && row < (rows - rows/7)
        if col > (columns/20) && col < (columns - columns/7)
          cells[row][col] = TERRAINS.sample
        end
      end
    end

    2.times do
      cells.reverse.each_with_index do |row, row_index|
        row.reverse.each_with_index do |cell, cell_index|
          neighboring_cells = neighbors(cells, row_index, cell_index)

          if cells[row_index][cell_index] == 'mountain'
            tile = rand(4) + 1
            if tile == 4
              unless row_index + 1 == rows
                cells[row_index + 1][cell_index] = 'mountain'
              end
              unless row_index == 0
                cells[row_index - 1][cell_index] = 'mountain'
              end
              unless cell_index + 1 == columns
                cells[row_index][cell_index + 1] = 'mountain'
              end
              unless cell_index == 0
                cells[row_index][cell_index - 1] = 'mountain'
              end
            elsif tile == 3
              unless row_index + 1 == rows || cell_index == 0
                cells[row_index + 1][cell_index - 1] = 'mountain'
              end
              unless row_index == 0 || cell_index + 1 == columns
                cells[row_index - 1][cell_index + 1] = 'mountain'
              end
              unless row_index + 1 == rows || cell_index + 1 == columns
                cells[row_index + 1][cell_index + 1] = 'mountain'
              end
              unless row_index == 0 || cell_index == 0
                cells[row_index - 1][cell_index - 1] = 'mountain'
              end
            elsif tile == 2
              unless row_index + 1 == rows || cell_index + 1 == columns
                cells[row_index][cell_index + 1] = 'mountain'
              end
              unless row_index == 0 || cell_index == 0
                cells[row_index][cell_index - 1] = 'mountain'
              end
            else
            end
          end
        end
      end
    end

    ###### Make Rings of Grass and Beach around Seeded Terrains
    2.times do
      cells.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          neighboring_cells = neighbors(cells, row_index, cell_index)

          if cells[row_index][cell_index] == 'water'
            if neighboring_cells.count{|x| x[1] == 'seed_grass'} > 0
              cells[row_index][cell_index] = 'grass'
            elsif neighboring_cells.count{|x| x[1] == 'mountain'} > 0
              cells[row_index][cell_index] = 'grass'
            end
          end

          if cells[row_index][cell_index] == 'water'
            if neighboring_cells.count{|x| x[1] == 'grass'} > 0
              cells[row_index][cell_index] = 'dirt'
            end
          end
        end
      end
    end

    ###### Make Ring of Shallow around all Dirt
    ###### Convert all Seed_Grass to Grass
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        if cells[row_index][cell_index] == 'seed_grass'
          cells[row_index][cell_index] = 'grass'
        elsif cells[row_index][cell_index] == 'water'
          if neighboring_cells.count{|x| x[1] == 'dirt'} > 0
            cells[row_index][cell_index] = 'shallow_water'
          end
        end
      end
    end

    #### Exterior Beach Smoothing
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        if cells[row_index][cell_index] == 'dirt'
          if neighboring_cells["west"] == 'shallow_water'
            if neighboring_cells["north"] != 'shallow_water'
              if neighboring_cells["south"] != 'shallow_water'
                cells[row_index][cell_index] = 'sand_shallow_w'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if neighboring_cells["east"] == 'shallow_water'
            if neighboring_cells["north"] != 'shallow_water'
              if neighboring_cells["south"] != 'shallow_water'
                cells[row_index][cell_index] = 'sand_shallow_e'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if neighboring_cells["north"] == 'shallow_water'
            if neighboring_cells["west"] != 'shallow_water'
              if neighboring_cells["east"] != 'shallow_water'
                cells[row_index][cell_index] = 'sand_shallow_n'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if neighboring_cells["south"] == 'shallow_water'
            if neighboring_cells["east"] != 'shallow_water'
              if neighboring_cells["west"] != 'shallow_water'
                cells[row_index][cell_index] = 'sand_shallow_s'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if neighboring_cells["west"] == 'shallow_water'
            if neighboring_cells["north"] == 'shallow_water'
              cells[row_index][cell_index] = 'sand_shallow_nw'
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if neighboring_cells["west"] == 'shallow_water'
            if neighboring_cells["south"] == 'shallow_water'
              cells[row_index][cell_index] = 'sand_shallow_sw'
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if neighboring_cells["east"] == 'shallow_water'
            if neighboring_cells["north"] == 'shallow_water'
              cells[row_index][cell_index] = 'sand_shallow_ne'
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if neighboring_cells["east"] == 'shallow_water'
            if neighboring_cells["south"] == 'shallow_water'
              cells[row_index][cell_index] = 'sand_shallow_se'
            end
          end
        end
      end
    end

    ######## Deep/Shallow Water Smoothing
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        if cells[row_index][cell_index] == 'water'

          if neighboring_cells["west"] == 'shallow_water'
            if neighboring_cells["east"] == 'shallow_water'
              if neighboring_cells["south"] == 'shallow_water'
                cells[row_index][cell_index] = 'shallow_water_n'
              end
            end
          end

          if neighboring_cells["west"] == 'shallow_water'
            if neighboring_cells["east"] == 'shallow_water'
              if neighboring_cells["north"] == 'shallow_water'
                cells[row_index][cell_index] = 'shallow_water_s'
              end
            end
          end

          if neighboring_cells["west"] == 'shallow_water'
            if neighboring_cells["north"] != 'shallow_water'
              if neighboring_cells["south"] != 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_w'
              end
            end
          end


          if neighboring_cells["east"] == 'shallow_water'
            if neighboring_cells["north"] != 'shallow_water'
              if neighboring_cells["south"] != 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_e'
              end
            end
          end

          if neighboring_cells["north"] == 'shallow_water'
            if neighboring_cells["west"] != 'shallow_water'
              if neighboring_cells["east"] != 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_n'
              end
            end
          end

          if neighboring_cells["south"] == 'shallow_water'
            if neighboring_cells["east"] != 'shallow_water'
              if neighboring_cells["west"] != 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_s'
              end
            end
          end

          if neighboring_cells["north_west"] == 'shallow_water'
            if neighboring_cells["west"] == 'shallow_water'
              if neighboring_cells["north"] == 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_nw'
              end
            end
          end

          if neighboring_cells["south_west"] == 'shallow_water'
            if neighboring_cells["west"] == 'shallow_water'
              if neighboring_cells["south"] == 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_sw'
              end
            end
          end

          if neighboring_cells["north_east"] == 'shallow_water'
            if neighboring_cells["east"] == 'shallow_water'
              if neighboring_cells["north"] == 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_ne'
              end
            end
          end

          if neighboring_cells["south_east"] == 'shallow_water'
            if neighboring_cells["east"] == 'shallow_water'
              if neighboring_cells["south"] == 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_se'
              end
            end
          end

        end
      end
    end

    #### Make Interior of Beach Tiles, Dirt.
    make_interior_of_beach_tiles_and_dirt

    ##### Mountain Cleanup
    2.times do
      cells.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          neighboring_cells = neighbors(cells, row_index, cell_index)
          basic_neighboring_cells = basic_neighbors(cells, row_index, cell_index)

          if cells[row_index][cell_index] == 'mountain'
            if basic_neighboring_cells.count{|x| x[1] == 'mountain'} < 2
              cells[row_index][cell_index] = 'grass'
            end
          end

          if cells[row_index][cell_index] == 'mountain'
            if neighboring_cells.count{|x| x[1] == 'mountain'} + neighboring_cells.count{|x| x[1] == 'grass'} < 8
              cells[row_index][cell_index] = 'grass'
            end
          end

          if cells[row_index][cell_index] == 'grass'
            if neighboring_cells.count{|x| x[1] == 'mountain'} > 6
              cells[row_index][cell_index] = 'mountain'
            end
          end

          if cells[row_index][cell_index] == 'mountain'
            if neighboring_cells.count{|x| x[1] == 'grass'} > 5
              cells[row_index][cell_index] = 'grass'
            end
          end
        end
      end
    end

    #####Angled Sand into Grass
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        if is_grass_or_mountain?(cells, row_index, cell_index)

          cells[row_index][cell_index] = change_cell_to_grass_with_southeast_sand(neighboring_cells, cells, row_index, cell_index)

          cells[row_index][cell_index] = change_cell_to_grass_with_southwest_sand(neighboring_cells, cells, row_index, cell_index)

          cells[row_index][cell_index] = change_cell_to_grass_with_northeast_sand(neighboring_cells, cells, row_index, cell_index)

          cells[row_index][cell_index] = change_cell_to_grass_with_northwest_sand(neighboring_cells, cells, row_index, cell_index)
        end
      end
    end

    ###### Smooth Remaining Sand
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        if cells[row_index][cell_index] == 'dirt'

          if neighboring_cells.count{|x| x[1] == 'grass'} > 7
            cells[row_index][cell_index] = 'grass_sand_middle'
          end

          if neighboring_cells["south"] == 'grass' || neighboring_cells["south"] == 'mountain'
            if neighboring_cells["west"] == 'dirt'  || neighboring_cells["west"] == 'grass_sand_ne' || neighboring_cells["west"] == 'grass_sand_n'
              if neighboring_cells["east"] == 'dirt' || neighboring_cells["east"] == 'grass_sand_nw' || neighboring_cells["east"] == 'grass_sand_n'
                cells[row_index][cell_index] = 'grass_sand_n'
              end
            end
          end

          if neighboring_cells["north"] == 'grass' || neighboring_cells["north"] == 'mountain'
            if neighboring_cells["west"] == 'dirt'  || neighboring_cells["west"] == 'grass_sand_se' || neighboring_cells["west"] == 'grass_sand_s'
              if neighboring_cells["east"] == 'dirt' || neighboring_cells["east"] == 'grass_sand_sw' || neighboring_cells["east"] == 'grass_sand_s'
                cells[row_index][cell_index] = 'grass_sand_s'
              end
            end
          end

          if neighboring_cells["west"] == 'grass' || neighboring_cells["west"] == 'mountain'
            if neighboring_cells["north"] == 'dirt'  || neighboring_cells["north"] == 'grass_sand_se' || neighboring_cells["north"] == 'grass_sand_e'
              if neighboring_cells["south"] == 'dirt' || neighboring_cells["south"] == 'grass_sand_ne' || neighboring_cells["south"] == 'grass_sand_e'
                cells[row_index][cell_index] = 'grass_sand_e'
              end
            end
          end

          if neighboring_cells["east"] == 'grass' || neighboring_cells["east"] == 'seed_grass' || neighboring_cells["east"] == 'mountain'
            if neighboring_cells["north"] == 'dirt'  || neighboring_cells["north"] == 'grass_sand_sw' || neighboring_cells["north"] == 'grass_sand_w'
              if neighboring_cells["south"] == 'dirt' || neighboring_cells["south"] == 'grass_sand_nw' || neighboring_cells["south"] == 'grass_sand_w'
                cells[row_index][cell_index] = 'grass_sand_w'
              end
            end
          end

          if neighboring_cells["north"] == 'grass' || neighboring_cells ["north"] == 'mountain'
            if neighboring_cells["east"] == 'grass' || neighboring_cells ["east"] == 'mountain'
              cells[row_index][cell_index] = 'grass_sand_sw'
            end
          end

          if neighboring_cells["south"] == 'grass' || neighboring_cells ["south"] == 'mountain'
            if neighboring_cells["east"] == 'grass' || neighboring_cells ["east"] == 'mountain'
              cells[row_index][cell_index] = 'grass_sand_nw'
            end
          end

          if neighboring_cells["south"] == 'grass' || neighboring_cells ["south"] == 'mountain'
              if neighboring_cells["west"] == 'grass' || neighboring_cells ["west"] == 'mountain'
                cells[row_index][cell_index] = 'grass_sand_ne'
              end
          end

          if neighboring_cells["north"] == 'grass' || neighboring_cells ["north"] == 'mountain'
              if neighboring_cells["west"] == 'grass' || neighboring_cells ["west"] == 'mountain'
                cells[row_index][cell_index] = 'grass_sand_se'
              end
          end

        end
      end
    end

    ####### Mountain Smoothing
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        if cells[row_index][cell_index] == 'mountain'
          if neighboring_cells["west"] == 'grass'
            if neighboring_cells["north"] != 'grass'
              if neighboring_cells["south"] != 'grass'
                cells[row_index][cell_index] = 'mountain_grass_w'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'mountain'
          if neighboring_cells["east"] == 'grass'
            if neighboring_cells["north"] != 'grass'
              if neighboring_cells["south"] != 'grass'
                cells[row_index][cell_index] = 'mountain_grass_e'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'mountain'
          if neighboring_cells["north"] == 'grass'
            if neighboring_cells["west"] != 'grass'
              if neighboring_cells["east"] != 'grass'
                cells[row_index][cell_index] = 'mountain_grass_n'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'mountain'
          if neighboring_cells["south"] == 'grass'
            if neighboring_cells["east"] != 'grass'
              if neighboring_cells["west"] != 'grass'
                cells[row_index][cell_index] = 'mountain_grass_s'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'mountain'
          if neighboring_cells["west"] == 'grass'
            if neighboring_cells["north"] == 'grass'
              cells[row_index][cell_index] = 'mountain_grass_nw'
            end
          end
        end

        if cells[row_index][cell_index] == 'mountain'
          if neighboring_cells["west"] == 'grass'
            if neighboring_cells["south"] == 'grass'
              cells[row_index][cell_index] = 'mountain_grass_sw'
            end
          end
        end

        if cells[row_index][cell_index] == 'mountain'
          if neighboring_cells["east"] == 'grass'
            if neighboring_cells["north"] == 'grass'
              cells[row_index][cell_index] = 'mountain_grass_ne'
            end
          end
        end

        if cells[row_index][cell_index] == 'mountain'
          if neighboring_cells["east"] == 'grass'
            if neighboring_cells["south"] == 'grass'
              cells[row_index][cell_index] = 'mountain_grass_se'
            end
          end
        end
      end
    end

    #### Arctic Zones ####
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        if row_index >= (rows - rows/10) || row_index <= (0 + rows/10)
          if cells[row_index][cell_index] == 'mountain_grass_n'
            cells[row_index][cell_index] = 'mountain_snow_n'
          end

          if cells[row_index][cell_index] == 'mountain_grass_ne'
            cells[row_index][cell_index] = 'mountain_snow_ne'
          end
          if cells[row_index][cell_index] == 'mountain_grass_nw'
            cells[row_index][cell_index] = 'mountain_snow_nw'
          end

          if cells[row_index][cell_index] == 'mountain_grass_e'
            cells[row_index][cell_index] = 'mountain_snow_e'
          end

          if cells[row_index][cell_index] == 'mountain_grass_se'
            cells[row_index][cell_index] = 'mountain_snow_se'
          end

          if cells[row_index][cell_index] == 'mountain_grass_s'
            cells[row_index][cell_index] = 'mountain_snow_s'
          end

          if cells[row_index][cell_index] == 'mountain_grass_sw'
            cells[row_index][cell_index] = 'mountain_snow_sw'
          end

          if cells[row_index][cell_index] == 'mountain_grass_w'
            cells[row_index][cell_index] = 'mountain_snow_w'
          end
        end

        if row_index < (0 + rows/10) || row_index > (rows - rows/10)
          if cells[row_index][cell_index] == 'grass' || cells[row_index][cell_index] == 'dirt'
            cells[row_index][cell_index] = 'snow'
          elsif cells[row_index][cell_index] == 'sand_shallow_e'
            cells[row_index][cell_index] = 'snow_water_e'
          elsif cells[row_index][cell_index] == 'sand_shallow_w'
            cells[row_index][cell_index] = 'snow_water_w'
          elsif cells[row_index][cell_index] == 'sand_shallow_s'
            cells[row_index][cell_index] = 'snow_water_s'
          elsif cells[row_index][cell_index] == 'sand_shallow_n'
            cells[row_index][cell_index] = 'snow_water_n'
          elsif cells[row_index][cell_index] == 'sand_shallow_ne'
            cells[row_index][cell_index] = 'snow_water_ne'
          elsif cells[row_index][cell_index] == 'sand_shallow_nw'
            cells[row_index][cell_index] = 'snow_water_nw'
          elsif cells[row_index][cell_index] == 'sand_shallow_se'
            cells[row_index][cell_index] = 'snow_water_se'
          elsif cells[row_index][cell_index] == 'sand_shallow_sw'
            cells[row_index][cell_index] = 'snow_water_sw'
          elsif cells[row_index][cell_index] == 'grass_sand_n'
            cells[row_index][cell_index] = 'snow'
          elsif cells[row_index][cell_index] == 'grass_sand_s'
            cells[row_index][cell_index] = 'snow'
          elsif cells[row_index][cell_index] == 'grass_sand_e'
            cells[row_index][cell_index] = 'snow'
          elsif cells[row_index][cell_index] == 'grass_sand_w'
            cells[row_index][cell_index] = 'snow'
          elsif cells[row_index][cell_index] == 'grass_sand_ne'
            cells[row_index][cell_index] = 'snow'
          elsif cells[row_index][cell_index] == 'grass_sand_nw'
            cells[row_index][cell_index] = 'snow'
          elsif cells[row_index][cell_index] == 'grass_sand_se'
            cells[row_index][cell_index] = 'snow'
          elsif cells[row_index][cell_index] == 'grass_sand_sw'
            cells[row_index][cell_index] = 'snow'
          end
        end

      end
    end

    #### Tundra Zones #####
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        if neighboring_cells.count{|x| x[1] == 'tundra'} > 7
          cells[row_index][cell_index] = 'tundra'
        end

        if neighboring_cells.count{|x| x[1] == 'grass'} > 7
          cells[row_index][cell_index] = 'grass'
        end

        if row_index < (0 + rows/5) || row_index > (rows - rows/5)
          if cells[row_index][cell_index] == 'grass_sand_e'
            cells[row_index][cell_index] = 'tundra_sand_e'
          elsif cells[row_index][cell_index] == 'grass_sand_w'
            cells[row_index][cell_index] = 'tundra_sand_w'
          elsif cells[row_index][cell_index] == 'grass_sand_n'
            cells[row_index][cell_index] = 'tundra_sand_n'
          elsif cells[row_index][cell_index] == 'grass_sand_s'
            cells[row_index][cell_index] = 'tundra_sand_s'
          elsif cells[row_index][cell_index] == 'grass_sand_nw'
            cells[row_index][cell_index] = 'tundra_sand_nw'
          elsif cells[row_index][cell_index] == 'grass_sand_sw'
            cells[row_index][cell_index] = 'tundra_sand_sw'
          elsif cells[row_index][cell_index] == 'grass_sand_ne'
            cells[row_index][cell_index] = 'tundra_sand_ne'
          elsif cells[row_index][cell_index] == 'grass_sand_se'
            cells[row_index][cell_index] = 'tundra_sand_se'
          elsif cells[row_index][cell_index] == 'grass'
            cells[row_index][cell_index] = 'tundra'
          end
        end

        if row_index <= (0 + rows/5) || row_index >= (rows - rows/5)
          if cells[row_index][cell_index] == 'mountain_grass_n'
            cells[row_index][cell_index] = 'mountain_tundra_n'
          elsif cells[row_index][cell_index] == 'mountain_grass_ne'
            cells[row_index][cell_index] = 'mountain_tundra_ne'
          elsif cells[row_index][cell_index] == 'mountain_grass_nw'
            cells[row_index][cell_index] = 'mountain_tundra_nw'
          elsif cells[row_index][cell_index] == 'mountain_grass_e'
            cells[row_index][cell_index] = 'mountain_tundra_e'
          elsif cells[row_index][cell_index] == 'mountain_grass_se'
            cells[row_index][cell_index] = 'mountain_tundra_se'
          elsif cells[row_index][cell_index] == 'mountain_grass_s'
            cells[row_index][cell_index] = 'mountain_tundra_s'
          elsif cells[row_index][cell_index] == 'mountain_grass_sw'
            cells[row_index][cell_index] = 'mountain_tundra_sw'
          elsif cells[row_index][cell_index] == 'mountain_grass_w'
            cells[row_index][cell_index] = 'mountain_tundra_w'
          end
        end

      end
    end

    ###### Blend North Arctic with Tundra
    ###### Blend South Arctic with Tundra
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)



        if row_index == (0 + rows/10)
          if cells[row_index][cell_index] == 'tundra'
            cells[row_index][cell_index] = 'tundra_snow_n'
          elsif cells[row_index][cell_index] == 'tundra_sand_w'
            cells[row_index][cell_index] = 'sand_snow_n'
          elsif cells[row_index][cell_index] == 'tundra_sand_ne'
            cells[row_index][cell_index] = 'sand_snow_n'
          elsif cells[row_index][cell_index] == 'tundra_sand_e'
            cells[row_index][cell_index] = 'sand_snow_n'
          elsif cells[row_index][cell_index] == 'tundra_sand_se'
            cells[row_index][cell_index] = 'tundra_snow_n'
          elsif cells[row_index][cell_index] == 'tundra_sand_sw'
            cells[row_index][cell_index] = 'sand_snow_n'
          elsif cells[row_index][cell_index] == 'tundra_sand_nw'
            cells[row_index][cell_index] = 'tundra_snow_n'
          elsif cells[row_index][cell_index] == 'tundra_sand_n'
            cells[row_index][cell_index] = 'tundra_snow_n'
          elsif cells[row_index][cell_index] == 'sand_shallow_w'
            cells[row_index][cell_index] = 'sand_shallow_w_snow_ne'
          elsif cells[row_index][cell_index] == 'sand_shallow_e'
            cells[row_index][cell_index] = 'sand_shallow_w_snow_nw'
          elsif cells[row_index][cell_index] == 'sand_shallow_nw'
            cells[row_index][cell_index] = 'snow_shallow_nw_sand_s'
          elsif cells[row_index][cell_index] == 'sand_shallow_ne'
            cells[row_index][cell_index] = 'snow_shallow_ne_sand_s'
          elsif cells[row_index][cell_index] == 'sand_shallow_n'
            cells[row_index][cell_index] = 'snow_shallow_n_sand_s'
          elsif cells[row_index][cell_index] == 'dirt'
            cells[row_index][cell_index] = 'sand_snow_n'
          elsif cells[row_index][cell_index] == 'tundra_sand_s'
            cells[row_index][cell_index] = 'sand_snow_n'
          elsif cells[row_index][cell_index] == 'sand_shallow_se'
            cells[row_index][cell_index] = 'snow_shallow_se'
          elsif cells[row_index][cell_index] == 'sand_shallow_sw'
            cells[row_index][cell_index] = 'snow_shallow_sw'
          end
        end



        if row_index == (rows - rows/10)
          if cells[row_index][cell_index] == 'tundra'
            cells[row_index][cell_index] = 'tundra_snow_s'
          elsif cells[row_index][cell_index] == 'tundra_sand_n'
            cells[row_index][cell_index] = 'sand_snow_s'
          elsif cells[row_index][cell_index] == 'tundra_sand_w'
            cells[row_index][cell_index] = 'tundra_snow_s'
          elsif cells[row_index][cell_index] == 'tundra_sand_ne'
            cells[row_index][cell_index] = 'tundra_snow_s'
          elsif cells[row_index][cell_index] == 'tundra_sand_e'
            cells[row_index][cell_index] = 'tundra_snow_s'
          elsif cells[row_index][cell_index] == 'tundra_sand_se'
            cells[row_index][cell_index] = 'tundra_snow_s'
          elsif cells[row_index][cell_index] == 'tundra_sand_sw'
            cells[row_index][cell_index] = 'tundra_snow_s'
          elsif cells[row_index][cell_index] == 'tundra_sand_nw'
            cells[row_index][cell_index] = 'sand_snow_s'
          elsif cells[row_index][cell_index] == 'tundra_sand_s'
            cells[row_index][cell_index] = 'tundra_snow_s'
          elsif cells[row_index][cell_index] == 'sand_shallow_e'
            cells[row_index][cell_index] = 'sand_shallow_e_snow_sw'
          elsif cells[row_index][cell_index] == 'sand_shallow_w'
            cells[row_index][cell_index] = 'sand_shallow_w_snow_se'
          elsif cells[row_index][cell_index] == 'sand_shallow_n'
            cells[row_index][cell_index] = 'snow_water_n'
          elsif cells[row_index][cell_index] == 'sand_shallow_ne'
            cells[row_index][cell_index] = 'snow_water_ne'
          elsif cells[row_index][cell_index] == 'sand_shallow_nw'
            cells[row_index][cell_index] = 'snow_water_nw'
          elsif cells[row_index][cell_index] == 'sand_shallow_sw'
            cells[row_index][cell_index] = 'snow_shallow_sw_sand_n'
          elsif cells[row_index][cell_index] == 'dirt'
            cells[row_index][cell_index] = 'sand_snow_s'
          elsif cells[row_index][cell_index] == 'sand_shallow_s'
            cells[row_index][cell_index] = 'snow_shallow_s_sand_n'
          end
        end
      end
    end

    cells
  end
end












