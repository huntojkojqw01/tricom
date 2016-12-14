class AddJunbanToShonin < ActiveRecord::Migration
  def up
    add_column :承認者マスタ, :順番, :integer
  end

  def down
    remove_column :承認者マスタ, :順番
  end
end
