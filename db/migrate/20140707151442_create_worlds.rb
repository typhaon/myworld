class CreateWorlds < ActiveRecord::Migration
  def change
    create_table :worlds do |t|
      t.string :name, null: false
      t.integer :max_rows, null: false
      t.integer :max_columns, null: false
      t.string :cells, array: true, default: '{0}'

      t.timestamps
    end
  end
end
