class WorldBuilder

  TERRAINS = [0, 1, 2]

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

    # (0..rows).each do |row|
    #   (0..columns).each do |column|
    #     neighboring_cells = neighbors(cells, row, column)
    #   end
    # end
  end

  def neighbors(cells, row, col)
    neighboring_cells = []

    if col > 0
      neighboring_cells << cells[row][col - 1]
    end

    if col < max_col - 1
      neighboring_cells << cells[row][col + 1]
    end


    neighboring_cells << cells[row + 1][col + 1]
    neighboring_cells << cells[row + 1][col - 1]
    neighboring_cells << cells[row + 1][col]

    neighboring_cells << cells[row - 1][col + 1]
    neighboring_cells << cells[row - 1][col - 1]
    neighboring_cells << cells[row - 1][col]

    neighboring_cells
  end
end
