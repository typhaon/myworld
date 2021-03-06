


worlds = [
  {
    name: "Genesis",
    rows: 1,
    columns: 3,
    cells: [
      [0, 0, 'water'],
      [0, 1, 'tree'],
      [0, 2, 'dirt']
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
