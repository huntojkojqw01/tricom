class AddIndexToShoninshamst < ActiveRecord::Migration
  def change
    add_index :承認者マスタ, [:承認者, :申請者]
  end
end
