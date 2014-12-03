class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :state_name
      t.integer :attacker
      t.integer :defender
      t.integer :mover
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
