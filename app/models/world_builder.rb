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
    ###### Clean stray Mountains
    ###### Convert all Seed_Grass to Grass
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)
        basic_neighboring_cells = basic_neighbors(cells, row_index, cell_index)

        if cells[row_index][cell_index] == 'water'
          if neighboring_cells.count{|x| x[1] == 'dirt'} > 0
            cells[row_index][cell_index] = 'shallow_water'
          end
        end

        if cells[row_index][cell_index] == 'mountain'
          if basic_neighboring_cells.count{|x| x[1] == 'mountain'} < 2
            cells[row_index][cell_index] = 'grass'
          end
        end

        if cells[row_index][cell_index] == 'seed_grass'
          cells[row_index][cell_index] = 'grass'
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

    #### Make Interior of Beach Tiles, Dirt.
    make_interior_of_beach_tiles_and_dirt

    ###### Angled Sand into Grass

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

    ##### Beach Trees

    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        far_away_cells = far_away(cells, row_index, cell_index)

        if cells[row_index][cell_index] == 'dirt'
          tile = rand(3)
          if tile == 0
            cells[row_index][cell_index] = 'dirt_0'
          end
        end

        if cells[row_index][cell_index] == 'sand_shallow_nw'
          tile = rand(4)
          if tile == 0
            cells[row_index][cell_index] = 'sand_shallow_nw_0'
          end
        end

        if cells[row_index][cell_index] == 'sand_shallow_ne'
          tile = rand(4)
          if tile == 0
            cells[row_index][cell_index] = 'sand_shallow_ne_0'
          end
        end

        if cells[row_index][cell_index] == 'sand_shallow_w'
          tile = rand(4)
          if tile == 0
            cells[row_index][cell_index] = 'sand_shallow_w_0'
          end
        end

        if cells[row_index][cell_index] == 'grass_sand_e'
          tile = rand(4)
          if tile == 0
            cells[row_index][cell_index] = 'grass_sand_e_0'
          end
        end

        if cells[row_index][cell_index] == 'grass_sand_n'
          tile = rand(4)
          if tile == 0
            cells[row_index][cell_index] = 'grass_sand_n_0'
          end
        end

        if cells[row_index][cell_index] == 'grass_sand_s'
          tile = rand(4)
          if tile == 0
            cells[row_index][cell_index] = 'grass_sand_s_0'
          end
        end

        if cells[row_index][cell_index] == 'grass_sand_se'
          tile = rand(4)
          if tile == 0
            cells[row_index][cell_index] = 'grass_sand_se_0'
          end
        end

        if cells[row_index][cell_index] == 'grass_sand_ne'
          tile = rand(4)
          if tile == 0
            cells[row_index][cell_index] = 'grass_sand_ne_0'
          end
        end

        if cells[row_index][cell_index] == 'grass_sand_nw'
          tile = rand(4)
          if tile == 0
            cells[row_index][cell_index] = 'grass_sand_nw_0'
          end
        end

        if cells[row_index][cell_index] == 'grass_sand_sw'
          tile = rand(4)
          if tile == 0
            cells[row_index][cell_index] = 'grass_sand_sw_0'
          end
        end

        if cells[row_index][cell_index] == 'grass'
          if far_away_cells.count{|x| x[1] == 'grass'} == 4
            tile = rand(500)
            if tile == 0
              cells[row_index][cell_index] = 'house_1'
              cells[row_index][cell_index + 1] = 'house_2'
              cells[row_index][cell_index + 2] = 'house_3'
              cells[row_index][cell_index + 3] = 'house_4'
              cells[row_index + 1][cell_index] = 'house_5'
              cells[row_index + 1][cell_index + 1] = 'house_6'
              cells[row_index + 1][cell_index + 2] = 'house_7'
              cells[row_index + 1][cell_index + 3] = 'house_8'
              cells[row_index + 2][cell_index] = 'house_9'
              cells[row_index + 2][cell_index + 1] = 'house_10'
              cells[row_index + 2][cell_index + 2] = 'house_11'
              cells[row_index + 2][cell_index + 3] = 'house_12'
              cells[row_index + 3][cell_index] = 'house_13'
              cells[row_index + 3][cell_index + 1] = 'house_14'
              cells[row_index + 3][cell_index + 2] = 'house_15'
              cells[row_index + 3][cell_index + 3] = 'house_16'
            end

            if tile == 1
              cells[row_index][cell_index + 1] = 'ruin_1'
              cells[row_index][cell_index + 2] = 'ruin_2'
              cells[row_index + 1][cell_index + 1] = 'ruin_3'
              cells[row_index + 1][cell_index + 2] = 'ruin_4'
            end

          end

          tile = rand(4)
          if tile == 0
            cells[row_index][cell_index] = 'grass_tree_0'
          end
          if tile == 1
            cells[row_index][cell_index] = 'grass_tree_1'
          end
        end



      end
    end



    #     ### Arctic Zones ###

    #     if cells[row_index][cell_index] == 'water'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #         tile = rand(10)
    #         if tile == 1
    #           cells[row_index][cell_index] = 'frozen_water_1'
    #         end
    #       end
    #     end

    #     if cells[row_index][cell_index] == 'grass'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #           cells[row_index][cell_index] = 'snow'
    #       end
    #     end

    #     if cells[row_index][cell_index] == 'mountain'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #         tile = rand(4) + 1
    #           if tile == 1
    #             cells[row_index][cell_index] = 'snow_mountain_1'
    #           elsif tile == 2
    #             cells[row_index][cell_index] = 'snow_mountain_2'
    #           elsif tile == 3
    #             cells[row_index][cell_index] = 'snow_mountain_3'
    #           elsif tile == 4
    #             cells[row_index][cell_index] = 'snow_mountain_4'
    #           end
    #       end
    #     end

    #     if cells[row_index][cell_index] == 'dirt'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #         if neighboring_cells["west"] == 'shallow_water'
    #           if neighboring_cells["north"] != 'shallow_water'
    #             if neighboring_cells["south"] != 'shallow_water'
    #               cells[row_index][cell_index] = 'snow_water_w'
    #             end
    #           end
    #         end
    #       end
    #     end

    #     if cells[row_index][cell_index] == 'dirt'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #         if neighboring_cells["east"] == 'shallow_water'
    #           if neighboring_cells["north"] != 'shallow_water'
    #             if neighboring_cells["south"] != 'shallow_water'
    #               cells[row_index][cell_index] = 'snow_water_e'
    #             end
    #           end
    #         end
    #       end
    #     end

    #     if cells[row_index][cell_index] == 'dirt'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #         if neighboring_cells["north"] == 'shallow_water'
    #           if neighboring_cells["west"] != 'shallow_water'
    #             if neighboring_cells["east"] != 'shallow_water'
    #               cells[row_index][cell_index] = 'snow_water_n'
    #             end
    #           end
    #         end
    #       end
    #     end

    #     if cells[row_index][cell_index] == 'dirt'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #         if neighboring_cells["south"] == 'shallow_water'
    #           if neighboring_cells["east"] != 'shallow_water'
    #             if neighboring_cells["west"] != 'shallow_water'
    #               cells[row_index][cell_index] = 'snow_water_s'
    #             end
    #           end
    #         end
    #       end
    #     end

    #     if cells[row_index][cell_index] == 'dirt'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #         if neighboring_cells["north_west"] == 'shallow_water'
    #           if neighboring_cells["west"] == 'shallow_water'
    #             if neighboring_cells["north"] == 'shallow_water'
    #               cells[row_index][cell_index] = 'snow_water_nw'
    #             end
    #           end
    #         end
    #       end
    #     end

    #     if cells[row_index][cell_index] == 'dirt'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #         if neighboring_cells["south_west"] == 'shallow_water'
    #           if neighboring_cells["west"] == 'shallow_water'
    #             if neighboring_cells["south"] == 'shallow_water'
    #               cells[row_index][cell_index] = 'snow_water_sw'
    #             end
    #           end
    #         end
    #       end
    #     end

    #    if cells[row_index][cell_index] == 'dirt'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #         if neighboring_cells["north_east"] == 'shallow_water'
    #           if neighboring_cells["east"] == 'shallow_water'
    #             if neighboring_cells["north"] == 'shallow_water'
    #               cells[row_index][cell_index] = 'snow_water_ne'
    #             end
    #           end
    #         end
    #       end
    #     end

    #     if cells[row_index][cell_index] == 'dirt'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #         if neighboring_cells["south_east"] == 'shallow_water'
    #           if neighboring_cells["east"] == 'shallow_water'
    #             if neighboring_cells["south"] == 'shallow_water'
    #               cells[row_index][cell_index] = 'snow_water_se'
    #             end
    #           end
    #         end
    #       end
    #     end

    #     if cells[row_index][cell_index] == 'dirt'
    #       if row_index < (0 + rows/10) || row_index > (rows - rows/10)
    #         if neighboring_cells["south_east"] == 'shallow_water' || neighboring_cells["south_west"] == 'shallow_water' ||
    #         neighboring_cells["north_east"] == 'shallow_water' || neighboring_cells["north_west"] == 'shallow_water'
    #           if neighboring_cells["east"] != 'shallow_water'
    #             if neighboring_cells["south"] != 'shallow_water'
    #               if neighboring_cells["west"] != 'shallow_water'
    #                 if neighboring_cells["north"] != 'shallow_water'
    #                   cells[row_index][cell_index] = 'snow_water_connect'
    #                 end
    #               end
    #             end
    #           end
    #         end
    #       end
    #     end

    # ######## Deep/Shallow Water Smoothing


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



















    cells

  end

  def save(name, max_rows, max_cols, id)
    cells_array = cells
    world = World.create(name: name, max_rows: max_rows, max_columns: max_cols, cells: cells_array, id: id)
  end




end
