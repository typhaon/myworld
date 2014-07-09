class WorldBuilder

  TERRAINS = [1, 2]

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
    cell_count / 8
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

    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        neighboring_cells = neighbors(cells, row_index, cell_index)
          if neighboring_cells.count > 4
            cells[row_index][cell_index] = 1
          end
      end
    end

    cells
    # def save(name)
    #   world = World.create(name: name)

    #   (0..rows).each do |row|
    #     (0..columns).each do |column|
    #       Cell.create(world: world, row: row, column: column, terrain: cells[row][column])
    #     end
    #   end
    # end

    # (0..rows).each do |row|
    #   (0..columns).each do |column|
    #     neighboring_cells = neighbors(cells, row, column)
    #   end
    # end
  end

  def save(name, max_rows, max_cols)
    world = World.create(name: name, max_rows: max_rows, max_columns: max_cols)

    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        Cell.create(world: world, row: row_index, column: cell_index, terrain_id: cell)
      end
    end
  end

  def neighbors(cells, row, col)
    neighboring_cells = []
    max_col = @columns
    max_row = @rows

    if col > 0
      neighboring_cells << cells[row][col - 1]
    end

    if col < max_col - 1
      neighboring_cells << cells[row][col + 1]
    end

    if col < max_col - 1 && row < max_row - 1
      neighboring_cells << cells[row + 1][col + 1]
    end

    if col > 0 && row < max_row - 1
      neighboring_cells << cells[row + 1][col - 1]
    end

    if row < max_row - 1
      neighboring_cells << cells[row + 1][col]
    end

    if row > 0 && col < max_col - 1
      neighboring_cells << cells[row - 1][col + 1]
    end

    if row > 0 && col > 0
      neighboring_cells << cells[row - 1][col - 1]
    end

    if row > 0
      neighboring_cells << cells[row - 1][col]
    end
    neighboring_cells
  end
end
