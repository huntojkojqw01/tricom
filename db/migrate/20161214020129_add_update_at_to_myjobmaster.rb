class AddUpdateAtToMyjobmaster < ActiveRecord::Migration
  def change
    add_column :MYJOBマスタ, :created_at, :datetime, null: false
    add_column :MYJOBマスタ, :updated_at, :datetime, null: false
  end
end
