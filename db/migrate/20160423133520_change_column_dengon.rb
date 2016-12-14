class ChangeColumnDengon < ActiveRecord::Migration
  def up
    remove_column :伝言, :to, :string
    add_column :伝言, :社員番号, :string
  end

  def down

  end
end
