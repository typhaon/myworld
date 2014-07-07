class CreateTerrains < ActiveRecord::Migration
  def change
    create_table :terrains do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
