class RemoveRememberDigestToUsers < ActiveRecord::Migration
  def change
    remove_column :担当者マスタ, :remember_digest, :string
  end
end
