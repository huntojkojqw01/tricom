class AddTimelineKubunInShainmaster < ActiveRecord::Migration
  def change
    add_column :社員マスタ, :タイムライン区分, :boolean, default: false
  end
end
