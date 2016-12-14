class AddYuusensaToKairanyokenmst < ActiveRecord::Migration
  def change
    add_column :回覧用件マスタ, :優先さ, :integer
  end
end
