class ChangeEventStartEndColumnType < ActiveRecord::Migration
  def up
    change_column :events, :開始, :string
    change_column :events, :終了, :string
  end

  def down

  end
end
