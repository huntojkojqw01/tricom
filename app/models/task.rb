class Task < ApplicationRecord
	validates :title, presence: true

 	default_scope { order("priority ASC") }
end
