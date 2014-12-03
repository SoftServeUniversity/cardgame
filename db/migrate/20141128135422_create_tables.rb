class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.text :table_cards
      t.integer :game_id
      t.integer :cards_count

      t.timestamps
    end
  end
end
