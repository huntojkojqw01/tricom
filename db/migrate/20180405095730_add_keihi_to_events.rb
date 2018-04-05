class AddKeihiToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :経費精算, :boolean
  end
end
