class WorldBuilder

  TERRAINS = [5]

  attr_reader :rows, :columns, :cells

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @cells = []

    rows.times do |row|
      cells << []

      columns.times do
        cells[row] << 0
      end
    end
  end

  def cell_count
    rows * columns
  end

  def seed_count
    cell_count / 2000
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

    7.times do
      cells.reverse.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          neighboring_cells = neighbors(cells, row_index, cell_index)

            if neighboring_cells.count{|x| x[1]==5} > 0
              tile = rand(6) + 1
              if tile > 4
                cells[row_index][cell_index] = 5
              else
                cells[row_index][cell_index] = 4
              end
            end
        end
      end
    end

    cells

  end

  def save(name, max_rows, max_cols)
    world = World.create(name: name, max_rows: max_rows, max_columns: max_cols)

    cell_array = []

    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        cell_array << Cell.new(world: world, row: row_index, column: cell_index, terrain_id: cell)
      end
    end

    Cell.import cell_array
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
end
