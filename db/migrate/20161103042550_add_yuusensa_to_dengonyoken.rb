class AddYuusensaToDengonyoken < ActiveRecord::Migration
  def change
    add_column :伝言用件マスタ, :優先さ, :integer
  end
end
