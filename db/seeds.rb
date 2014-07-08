


worlds = [
  {
    name: "Genesis",
    rows: 4,
    columns: 4,
    cells: [
      [0, 0, 'water'],
      [0, 1, 'water'],
      [0, 2, 'dirt'],
      [0, 3, 'dirt'],
      [1, 0, 'water'],
      [1, 1, 'dirt'],
      [1, 2, 'dirt'],
      [1, 3, 'tree'],
      [2, 0, 'water'],
      [2, 1, 'dirt'],
      [2, 2, 'tree'],
      [2, 3, 'tree'],
      [3, 0, 'water'],
      [3, 1, 'dirt'],
      [3, 2, 'dirt'],
      [3, 3, 'tree'],
    ]
  }
]

worlds.each do |world_hash|
  world = World.create!(name: world_hash[:name],
    max_rows: world_hash[:rows],
    max_columns: world_hash[:columns])

  world_hash[:cells].each do |row, column, terrain_type|
    terrain = Terrain.where(name: terrain_type).first
    if terrain.nil?
      terrain = Terrain.create!(name: terrain_type)
    end

    Cell.create!(row: row, column: column, terrain: terrain, world: world)
  end
end
