class AddDoneToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :done, :integer, :default => 0
  end
end
