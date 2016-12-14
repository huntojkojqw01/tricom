class AddUmuToEvent < ActiveRecord::Migration
  def change
  	add_column :events, :有無, :string
  end
end
