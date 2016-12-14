class CreateBashokubunmsts < ActiveRecord::Migration
  def change
    create_table :場所区分マスタ, id: false do |t|
      t.string :場所区分コード, null: false
      t.string :場所区分名

      t.timestamps null: false
    end

    add_index :場所区分マスタ, :場所区分コード, unique: true

  end
end
