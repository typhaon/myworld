class CreateCells < ActiveRecord::Migration
  def change
    create_table :cells do |t|
      t.integer :row, null: false
      t.integer :column, null: false
      t.integer :terrain_id, null: false
      t.integer :world_id, null: false

      t.timestamps
    end
  end
end
