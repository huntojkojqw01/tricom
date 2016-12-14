class AddRowToEki < ActiveRecord::Migration
  def up
    add_column :駅マスタ, :駅名カナ, :string
    add_column :駅マスタ, :選択回数, :integer
  end
  def down
    remove_column :駅マスタ, :駅名カナ
    remove_column :駅マスタ, :選択回数
  end
end
