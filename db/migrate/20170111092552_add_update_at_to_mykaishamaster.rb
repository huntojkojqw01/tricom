class AddUpdateAtToMykaishamaster < ActiveRecord::Migration[5.0]
  def change
    add_column :MY会社マスタ, :created_at, :datetime, null: false
    add_column :MY会社マスタ, :updated_at, :datetime, null: false
  end
end
