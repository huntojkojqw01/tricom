class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user, :foreign_key => :user, class_name: 'User'

  validates_presence_of :body, :conversation_id, :user
  scope :unread, ->{ where(read_at: nil) }
  scope :recent, ->{ order(created_at: :desc).limit(5) }
end
