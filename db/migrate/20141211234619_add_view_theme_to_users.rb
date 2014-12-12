class AddViewThemeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :view_theme, :string
  end
end
