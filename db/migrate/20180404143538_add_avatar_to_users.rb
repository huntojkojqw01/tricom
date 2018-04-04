class AddAvatarToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :担当者マスタ, :avatar, :string
    remove_column :担当者マスタ, :avatar_file_name
    remove_column :担当者マスタ, :avatar_content_type
    remove_column :担当者マスタ, :avatar_file_size
    remove_column :担当者マスタ, :avatar_updated_at
  end
end
