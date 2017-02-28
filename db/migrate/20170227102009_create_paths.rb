class CreatePaths < ActiveRecord::Migration[5.0]
  def change
    create_table :paths do |t|
      t.string :title_jp
      t.string :title_en
      t.string :model_name
      t.string :path_url

      t.timestamps
    end
  end
end
