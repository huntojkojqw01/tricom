class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    drop_table :messages
    drop_table :conversations
    create_table :conversations do |t|
      t.string :sender_id
      t.string :recipient_id

      t.timestamps
    end

    add_index :conversations, :sender_id
    add_index :conversations, :recipient_id
  end
end
