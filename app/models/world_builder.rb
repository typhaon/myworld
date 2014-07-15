class WorldBuilder

  TERRAINS = ['grass']
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
    cell_count / 25
  end

  def tree_seed_count
    cell_count / 5
  end

  def generate!
    # This method should contain the logic for generating the world.
    # The cells variable already contains a grid that is rows * columns
    # large and every cell contains 0.

    seed_count.times do
      row = rand(rows)
      col = rand(columns)

      cells[row][col] = TERRAINS.sample
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


    3.times do
      cells.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          neighboring_cells = neighbors(cells, row_index, cell_index)

          if cells[row_index][cell_index] == 'grass'
            tile = rand(4) + 1
            if tile == 4
              unless row_index + 1 == rows
                cells[row_index + 1][cell_index] = 'grass'
              end
              unless row_index == 0
                cells[row_index - 1][cell_index] = 'grass'
              end
              unless cell_index + 1 == columns
                cells[row_index][cell_index + 1] = 'grass'
              end
              unless cell_index == 0
                cells[row_index][cell_index - 1] = 'grass'
              end
            elsif tile == 3
              unless row_index + 1 == rows || cell_index == 0
                cells[row_index + 1][cell_index - 1] = 'grass'
              end
              unless row_index == 0 || cell_index + 1 == columns
                cells[row_index - 1][cell_index + 1] = 'grass'
              end
              unless row_index + 1 == rows || cell_index + 1 == columns
                cells[row_index + 1][cell_index + 1] = 'grass'
              end
              unless row_index == 0 || cell_index == 0
                cells[row_index - 1][cell_index - 1] = 'grass'
              end
            else
              cells[row_index][cell_index] = 'grass'
            end
          end
        end
      end
    end


    3.times do
      cells.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          neighboring_cells = neighbors(cells, row_index, cell_index)

          if neighboring_cells['east'] == 'water' && neighboring_cells['west'] == 'water'
            if neighboring_cells['south'] == 'water' && neighboring_cells['north'] == 'water'
              cells[row_index][cell_index] = 'water'
            else
            end
          elsif neighboring_cells.count{|x| x[1] == 'water'} > 6
            cells[row_index][cell_index] = 'water'
          else
          end

          if cells[row_index][cell_index] == 'water' && neighboring_cells.count{|x| x[1] == 'grass'} > 6
            cells[row_index][cell_index] = 'grass'
          else
          end
        end
      end
    end



    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)
        if cells[row_index][cell_index] == 'grass' && neighboring_cells.count{|x| x[1] == 'water'} > 0
          cells[row_index][cell_index] = 'dirt'
        else
        end
      end
    end


    2.times do
      cells.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          neighboring_cells = neighbors(cells, row_index, cell_index)

          if cells[row_index][cell_index] == 'water' && neighboring_cells.count{|x| x[1] == 'dirt'} > 0
            cells[row_index][cell_index] = 'shallow_water'
          end

          if cells[row_index][cell_index] == 'water' && neighboring_cells.count{|x| x[1] == 'shallow_water'} > 6
            cells[row_index][cell_index] = 'shallow_water'
          end

          if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'water'} > 6
            cells[row_index][cell_index] = 'shallow_water'
          end

        end
      end
    end

    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        if cells[row_index][cell_index] == 'dirt' && neighboring_cells.count{|x| x[1] == 'shallow_water'} > 4
          cells[row_index][cell_index] = 'shallow_water'
        end

        if cells[row_index][cell_index] == 'grass' && neighboring_cells.count{|x| x[1] == 'shallow_water'} > 0
          cells[row_index][cell_index] = 'dirt'
        end
      end
    end

    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} > 4
          if neighboring_cells["west"] == 'dirt'
            if neighboring_cells["south_west"] == 'dirt'
              if neighboring_cells["south"] == 'dirt'
                if neighboring_cells["south_east"] == 'dirt'
                  if neighboring_cells["east"] == 'dirt'

                    cells[row_index][cell_index] = 'shallow_water_dirt_south_u'
                  end
                end
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} > 4
          if neighboring_cells["west"] == 'dirt'
            if neighboring_cells["south_west"] == 'dirt'
              if neighboring_cells["south"] == 'dirt'
                if neighboring_cells["north_west"] == 'dirt'
                  if neighboring_cells["north"] == 'dirt'

                    cells[row_index][cell_index] = 'shallow_water_dirt_west_u'
                  end
                end
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} > 4
          if neighboring_cells["west"] == 'dirt'
            if neighboring_cells["north_west"] == 'dirt'
              if neighboring_cells["north"] == 'dirt'
                if neighboring_cells["north_east"] == 'dirt'
                  if neighboring_cells["east"] == 'dirt'

                    cells[row_index][cell_index] = 'shallow_water_dirt_north_u'
                  end
                end
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} > 4
          if neighboring_cells["north"] == 'dirt'
            if neighboring_cells["north_east"] == 'dirt'
              if neighboring_cells["east"] == 'dirt'
                if neighboring_cells["south_east"] == 'dirt'
                  if neighboring_cells["south"] == 'dirt'

                    cells[row_index][cell_index] = 'shallow_water_dirt_east_u'
                  end
                end
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} > 2
          if neighboring_cells["west"] == 'dirt'
            if neighboring_cells["south_west"] == 'dirt'
              if neighboring_cells["south"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_south_west_L'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} > 2
          if neighboring_cells["west"] == 'dirt'
            if neighboring_cells["north_west"] == 'dirt'
              if neighboring_cells["north"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_north_west_L'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} > 2
          if neighboring_cells["east"] == 'dirt'
            if neighboring_cells["south_east"] == 'dirt'
              if neighboring_cells["south"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_south_east_L'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} > 2
          if neighboring_cells["east"] == 'dirt'
            if neighboring_cells["north_east"] == 'dirt'
              if neighboring_cells["north"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_north_east_L'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 3
          if neighboring_cells["south_west"] == 'dirt'
            if neighboring_cells["south_east"] == 'dirt'
              if neighboring_cells["south"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_south_shore'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 3
          if neighboring_cells["west"] == 'dirt'
            if neighboring_cells["north_west"] == 'dirt'
              if neighboring_cells["south_west"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_west_shore'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 3
          if neighboring_cells["north_west"] == 'dirt'
            if neighboring_cells["north_east"] == 'dirt'
              if neighboring_cells["north"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_north_shore'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 3
          if neighboring_cells["east"] == 'dirt'
            if neighboring_cells["north_east"] == 'dirt'
              if neighboring_cells["south_east"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_east_shore'
              end
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 2
          if neighboring_cells["east"] == 'dirt'
            if neighboring_cells["north_east"] == 'dirt' || neighboring_cells["south_east"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_east_shore'
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 2
          if neighboring_cells["north"] == 'dirt'
            if neighboring_cells["north_east"] == 'dirt' || neighboring_cells["north_west"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_north_shore'
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 2
          if neighboring_cells["west"] == 'dirt'
            if neighboring_cells["north_west"] == 'dirt' || neighboring_cells["south_west"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_west_shore'
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 2
          if neighboring_cells["south"] == 'dirt'
            if neighboring_cells["south_west"] == 'dirt' || neighboring_cells["south_east"] == 'dirt'
               cells[row_index][cell_index] = 'shallow_water_dirt_south_shore'
            end
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 1
          if neighboring_cells["south_west"] == 'dirt'
            cells[row_index][cell_index] = 'shallow_water_dirt_sw_corner'
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 1
          if neighboring_cells["north_east"] == 'dirt'
            cells[row_index][cell_index] = 'shallow_water_dirt_ne_corner'
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 1
          if neighboring_cells["south_east"] == 'dirt'
            cells[row_index][cell_index] = 'shallow_water_dirt_se_corner'
          end
        end

        if cells[row_index][cell_index] == 'shallow_water' && neighboring_cells.count{|x| x[1] == 'dirt'} == 1
          if neighboring_cells["north_west"] == 'dirt'
            cells[row_index][cell_index] = 'shallow_water_dirt_nw_corner'
          end
        end

      end
    end

    tree_seed_count.times do
      row = rand(rows)
      col = rand(columns)

      if cells[row][col] == 'grass'
        cells[row][col] = TREES.sample
      end
    end

    cells

  end

  def save(name, max_rows, max_cols, id)
    cells_array = cells
    world = World.create(name: name, max_rows: max_rows, max_columns: max_cols, cells: cells_array, id: id)
  end




end
