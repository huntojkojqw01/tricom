class AddColumnToJob < ActiveRecord::Migration
  def up
    change_column :JOBマスタ, :job番号, 'integer USING CAST(job番号 AS integer)'
    add_column :JOBマスタ, :入力社員番号, :string
    add_column :JOBマスタ, :分類コード, :integer
    add_column :JOBマスタ, :分類名, :string
    add_column :JOBマスタ, :関連Job番号, :string
    add_column :JOBマスタ, :備考, :string
  end

  def down
    remove_column :JOBマスタ, :入力社員番号, :string
    remove_column :JOBマスタ, :分類コード, :integer
    remove_column :JOBマスタ, :分類名, :string
    remove_column :JOBマスタ, :関連Job番号, :string
    remove_column :JOBマスタ, :備考, :string
  end
end
