class AddColToJobmaster < ActiveRecord::Migration[5.0]
  def change
    add_column :JOBマスタ, :受注金額, :integer
    add_column :JOBマスタ, :納期, :date
  end
end
