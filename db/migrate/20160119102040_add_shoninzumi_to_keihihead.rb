class AddShoninzumiToKeihihead < ActiveRecord::Migration
  def up
    add_column :keihi_heads, :承認済区分, :string
  end

  def down
    remove_column :keihi_heads, :承認済区分
  end
end