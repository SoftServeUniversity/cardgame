class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :state
      t.string :winner
      t.string :loser
      t.string :attacker
      t.string :defender
      t.string :mover
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
