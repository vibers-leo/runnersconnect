class CreateCrews < ActiveRecord::Migration[8.1]
  def change
    create_table :crews do |t|
      t.string :name
      t.string :code
      t.references :leader, null: false, foreign_key: { to_table: :users }
      t.text :description

      t.timestamps
    end
    add_index :crews, :code
  end
end
