class ChangeKubunInShainmaster < ActiveRecord::Migration
  def change
    remove_column :社員マスタ, :区分, :boolean, default: true
    add_column :社員マスタ, :区分, :boolean, default: false
  end
end
