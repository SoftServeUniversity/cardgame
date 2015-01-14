class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :user_id
      t.integer :game_id
      t.text :player_cards
      t.integer :cards_count

      t.timestamps
    end
  end
end
