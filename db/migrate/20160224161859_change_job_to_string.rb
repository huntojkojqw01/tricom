class ChangeJobToString < ActiveRecord::Migration
  def change
    change_column :JOBマスタ, :job番号, :string
    change_column :JOBマスタ, :ユーザ番号, :string
    change_column :JOBマスタ, :分類コード, :string
  end
end
