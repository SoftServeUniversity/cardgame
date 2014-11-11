class CreateCardGames < ActiveRecord::Migration
  def change
    create_table :card_games do |t|
      t.string :title
      t.text :notes

      t.timestamps
    end
  end
end
