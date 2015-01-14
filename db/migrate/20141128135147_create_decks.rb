class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.integer :game_id
      t.text :deck_cards
      t.integer :cursor
      t.string :trump

      t.timestamps
    end
  end
end
