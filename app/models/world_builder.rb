class WorldBuilder

  TERRAINS = ['mountain']
  GRASS = ['seed_grass']
  TREES = ['tree']


  attr_reader :rows, :columns, :cells

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

  def seed_count
    cell_count / 1500
  end

  def grass_seed_count
    cell_count / 1000
  end

  def tree_seed_count
    cell_count / 5
  end

  def generate!
    # This method should contain the logic for generating the world.
    # The cells variable already contains a grid that is rows * columns
    # large and every cell contains 0.

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

      if row < max_row - 4
        far_away_cells['far_south'] = cells[row + 4][col]
      end

      if col < max_col - 4
        far_away_cells['far_east'] = cells[row][col + 4]
      end

      if col > 3
        far_away_cells['far_west'] = cells[row][col - 4]
      end

      if row > 3
        far_away_cells['far_north'] = cells[row - 4][col]
      end
      far_away_cells
    end

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

    seed_count.times do
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

    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)
        basic_neighboring_cells = basic_neighbors(cells, row_index, cell_index
          )
        if cells[row_index][cell_index] == 'water'
          if neighboring_cells.count{|x| x[1] == 'dirt'} > 0
            cells[row_index][cell_index] = 'shallow_water'
          end
        end

        if cells[row_index][cell_index] == 'mountain'
          if basic_neighboring_cells.count{|x| x[1] == 'mountain'} < 1
            cells[row_index][cell_index] = 'grass'
          end
        end
      end
    end

    ### Arctic Zones ###

    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        ### Arctic Zones ###

        if cells[row_index][cell_index] == 'water'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
            tile = rand(10)
            if tile == 1
              cells[row_index][cell_index] = 'frozen_water_1'
            end
          end
        end

        if cells[row_index][cell_index] == 'grass'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
              cells[row_index][cell_index] = 'snow'
          end
        end

        if cells[row_index][cell_index] == 'mountain'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
            tile = rand(4) + 1
              if tile == 1
                cells[row_index][cell_index] = 'snow_mountain_1'
              elsif tile == 2
                cells[row_index][cell_index] = 'snow_mountain_2'
              elsif tile == 3
                cells[row_index][cell_index] = 'snow_mountain_3'
              elsif tile == 4
                cells[row_index][cell_index] = 'snow_mountain_4'
              end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
            if neighboring_cells["west"] == 'shallow_water'
              if neighboring_cells["north"] != 'shallow_water'
                if neighboring_cells["south"] != 'shallow_water'
                  cells[row_index][cell_index] = 'snow_water_w'
                end
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
            if neighboring_cells["east"] == 'shallow_water'
              if neighboring_cells["north"] != 'shallow_water'
                if neighboring_cells["south"] != 'shallow_water'
                  cells[row_index][cell_index] = 'snow_water_e'
                end
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
            if neighboring_cells["north"] == 'shallow_water'
              if neighboring_cells["west"] != 'shallow_water'
                if neighboring_cells["east"] != 'shallow_water'
                  cells[row_index][cell_index] = 'snow_water_n'
                end
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
            if neighboring_cells["south"] == 'shallow_water'
              if neighboring_cells["east"] != 'shallow_water'
                if neighboring_cells["west"] != 'shallow_water'
                  cells[row_index][cell_index] = 'snow_water_s'
                end
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
            if neighboring_cells["north_west"] == 'shallow_water'
              if neighboring_cells["west"] == 'shallow_water'
                if neighboring_cells["north"] == 'shallow_water'
                  cells[row_index][cell_index] = 'snow_water_nw'
                end
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
            if neighboring_cells["south_west"] == 'shallow_water'
              if neighboring_cells["west"] == 'shallow_water'
                if neighboring_cells["south"] == 'shallow_water'
                  cells[row_index][cell_index] = 'snow_water_sw'
                end
              end
            end
          end
        end

       if cells[row_index][cell_index] == 'dirt'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
            if neighboring_cells["north_east"] == 'shallow_water'
              if neighboring_cells["east"] == 'shallow_water'
                if neighboring_cells["north"] == 'shallow_water'
                  cells[row_index][cell_index] = 'snow_water_ne'
                end
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
            if neighboring_cells["south_east"] == 'shallow_water'
              if neighboring_cells["east"] == 'shallow_water'
                if neighboring_cells["south"] == 'shallow_water'
                  cells[row_index][cell_index] = 'snow_water_se'
                end
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if row_index < (0 + rows/10) || row_index > (rows - rows/10)
            if neighboring_cells["south_east"] == 'shallow_water' || neighboring_cells["south_west"] == 'shallow_water' ||
            neighboring_cells["north_east"] == 'shallow_water' || neighboring_cells["north_west"] == 'shallow_water'
              if neighboring_cells["east"] != 'shallow_water'
                if neighboring_cells["south"] != 'shallow_water'
                  if neighboring_cells["west"] != 'shallow_water'
                    if neighboring_cells["north"] != 'shallow_water'
                      cells[row_index][cell_index] = 'snow_water_connect'
                    end
                  end
                end
              end
            end
          end
        end

        ########

        if cells[row_index][cell_index] == 'water'
          if neighboring_cells["west"] == 'shallow_water'
            if neighboring_cells["north"] != 'shallow_water'
              if neighboring_cells["south"] != 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_w'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'water'
          if neighboring_cells["east"] == 'shallow_water'
            if neighboring_cells["north"] != 'shallow_water'
              if neighboring_cells["south"] != 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_e'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'water'
          if neighboring_cells["north"] == 'shallow_water'
            if neighboring_cells["west"] != 'shallow_water'
              if neighboring_cells["east"] != 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_n'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'water'
          if neighboring_cells["south"] == 'shallow_water'
            if neighboring_cells["east"] != 'shallow_water'
              if neighboring_cells["west"] != 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_s'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'water'
          if neighboring_cells["north_west"] == 'shallow_water'
            if neighboring_cells["west"] == 'shallow_water'
              if neighboring_cells["north"] == 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_nw'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'water'
          if neighboring_cells["south_west"] == 'shallow_water'
            if neighboring_cells["west"] == 'shallow_water'
              if neighboring_cells["south"] == 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_sw'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'water'
          if neighboring_cells["north_east"] == 'shallow_water'
            if neighboring_cells["east"] == 'shallow_water'
              if neighboring_cells["north"] == 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_ne'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'water'
          if neighboring_cells["south_east"] == 'shallow_water'
            if neighboring_cells["east"] == 'shallow_water'
              if neighboring_cells["south"] == 'shallow_water'
                cells[row_index][cell_index] = 'water_shallow_se'
              end
            end
          end
        end

        #### Beach Smooth

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
          if neighboring_cells["north_west"] == 'shallow_water'
            if neighboring_cells["west"] == 'shallow_water'
              if neighboring_cells["north"] == 'shallow_water'
                cells[row_index][cell_index] = 'sand_shallow_nw'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if neighboring_cells["south_west"] == 'shallow_water'
            if neighboring_cells["west"] == 'shallow_water'
              if neighboring_cells["south"] == 'shallow_water'
                cells[row_index][cell_index] = 'sand_shallow_sw'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if neighboring_cells["north_east"] == 'shallow_water'
            if neighboring_cells["east"] == 'shallow_water'
              if neighboring_cells["north"] == 'shallow_water'
                cells[row_index][cell_index] = 'sand_shallow_ne'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'dirt'
          if neighboring_cells["south_east"] == 'shallow_water'
            if neighboring_cells["east"] == 'shallow_water'
              if neighboring_cells["south"] == 'shallow_water'
                cells[row_index][cell_index] = 'sand_shallow_se'
              end
            end
          end
        end

        #### Grass/Sand Smooth

        # if cells[row_index][cell_index] == 'grass'
        #   if neighboring_cells["east"] == 'dirt' || neighboring_cells["east"] == 'sand_shallow_e'
        #     if neighboring_cells["north"] != 'dirt' && neighboring_cells["north"] != 'sand_shallow_n'
        #       if neighboring_cells["south"] != 'dirt' && neighboring_cells["south"] != 'sand_shallow_s'
        #         cells[row_index][cell_index] = 'grass_sand_e'
        #       end
        #     end
        #   end
        # end

        # if cells[row_index][cell_index] == 'grass'
        #   if neighboring_cells["east"] == 'dirt' || neighboring_cells["east"] == 'sand_shallow_e'
        #     if neighboring_cells["north"] != 'dirt' && neighboring_cells["north"] != 'sand_shallow_n'
        #       if neighboring_cells["south"] != 'dirt' && neighboring_cells["south"] != 'sand_shallow_s'
        #         cells[row_index][cell_index] = 'grass_sand_e'
        #       end
        #     end
        #   end
        # end

        #     # if neighboring_cells["west"] != 'grass' && neighboring_cells["west"] != 'grass_sand_w'
        #     #   if neighboring_cells["north"] != 'dirt' && neighboring_cells["north"] != 'sand_shallow_n'
        #     #     if neighboring_cells["south"] != 'dirt' && neighboring_cells["south"] != 'sand_shallow_s'
        #           cells[row_index][cell_index] = 'grass_sand_w'
        #         end
        #   #     end
        #   #   end
        #   # end
        # end

        # if cells[row_index][cell_index] == 'grass'
        #   if neighboring_cells["south"] == 'shallow_water'
        #     if neighboring_cells["east"] != 'shallow_water'
        #       if neighboring_cells["west"] != 'shallow_water'
        #         cells[row_index][cell_index] = 'sand_shallow_s'
        #       end
        #     end
        #   end
        # end

        # if cells[row_index][cell_index] == 'grass'
        #   if neighboring_cells["north_west"] == 'shallow_water'
        #     if neighboring_cells["west"] == 'shallow_water'
        #       if neighboring_cells["north"] == 'shallow_water'
        #         cells[row_index][cell_index] = 'sand_shallow_nw'
        #       end
        #     end
        #   end
        # end

        # if cells[row_index][cell_index] == 'grass'
        #   if neighboring_cells["south_west"] == 'shallow_water'
        #     if neighboring_cells["west"] == 'shallow_water'
        #       if neighboring_cells["south"] == 'shallow_water'
        #         cells[row_index][cell_index] = 'sand_shallow_sw'
        #       end
        #     end
        #   end
        # end

        # if cells[row_index][cell_index] == 'grass'
        #   if neighboring_cells["north_east"] == 'shallow_water'
        #     if neighboring_cells["east"] == 'shallow_water'
        #       if neighboring_cells["north"] == 'shallow_water'
        #         cells[row_index][cell_index] = 'sand_shallow_ne'
        #       end
        #     end
        #   end
        # end

      end
    end

    cells.each_with_index do |row, row_index|

      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        if cells[row_index][cell_index] == 'grass'
          if neighboring_cells["west"] == 'sand_shallow_w'
            cells[row_index][cell_index] = 'grass_sand_w'
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
