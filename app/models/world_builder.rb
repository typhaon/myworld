class WorldBuilder

  TERRAINS = ['rock']

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
    cell_count / 500
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




    12.times do
      cells.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          neighboring_cells = neighbors(cells, row_index, cell_index)

          if cells[row_index][cell_index] == 'rock'
            cells[row_index][cell_index] = 'rock'
          elsif neighboring_cells.count{|x| x[1]=='rock'} > 6
            cells[row_index][cell_index] = 'rock'
          elsif neighboring_cells.count{|x| x[1]=='rock'} >
            tile = rand(2) + 1
            if tile == 2
              if row_index < 80 && row_index > 20
                cells[row_index][cell_index] = 'grass'
              else
                cells[row_index][cell_index] = 'mud'
              end
            else
              cells[row_index][cell_index] = 'dirt'
            end
          elsif neighboring_cells.count{|x| x[1]=='rock'} > 0
            tile = rand(4) + 1
            if tile == 4
              cells[row_index][cell_index] = 'rock'
            elsif tile == 3
              if row_index < 80 && row_index > 20
                cells[row_index][cell_index] = 'grass'
              else
                cells[row_index][cell_index] = 'mud'
              end
            elsif tile == 2
              cells[row_index][cell_index] = 'dirt'
            elsif tile == 1
              cells[row_index][cell_index] = 'water'
            end
          else
          end

        end
      end
    end

      3.times do
        cells.each_with_index do |row, row_index|
          row.each_with_index do |cell, cell_index|
            neighboring_cells = neighbors(cells, row_index, cell_index)

            if cells[row_index][cell_index] != 'water' && neighboring_cells.count{|x| x[1]=='water'} > 0
              if row_index > 80 || row_index < 20
                cells[row_index][cell_index] = 'ice'
              else
                cells[row_index][cell_index] = 'dirt'
              end
            else
            end
          end
        end
      end


      cells.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          neighboring_cells = neighbors(cells, row_index, cell_index)
          far_away_cells = far_away(cells, row_index, cell_index)

          if cells[row_index][cell_index] == 'water'
            if neighboring_cells.count{|x| x[1] == 'dirt'} > 0 || neighboring_cells.count{|x| x[1] == 'ice'} > 0
              cells[row_index][cell_index] = 'shallow_water'
            else
            end
          else
          end

          if cells[row_index][cell_index] == 'water' && neighboring_cells.count{|x| x[1] == 'shallow_water'} > 0
            tile = rand(2)
            if tile == 1
              cells[row_index][cell_index] = 'shallow_water'
            else
              cells[row_index][cell_index] = 'water'
            end
          else
          end

          if cells[row_index][cell_index] == 'shallow_water' && far_away_cells.count{|x| x[1] == 'shallow_water'} > 0
              cells[row_index][cell_index] = 'water'
          else
          end


        end
      end




    cells

  end

  def save(name, max_rows, max_cols)
    cells_array = cells
    world = World.create(name: name, max_rows: max_rows, max_columns: max_cols, cells: cells_array)
  end




end
