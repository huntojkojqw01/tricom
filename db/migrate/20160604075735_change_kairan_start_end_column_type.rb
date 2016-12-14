class ChangeKairanStartEndColumnType < ActiveRecord::Migration
  def up
    change_column :回覧, :開始, :string
    change_column :回覧, :終了, :string
  end

  def down

  end
end
