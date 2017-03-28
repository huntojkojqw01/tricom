class Task < ApplicationRecord
	validates_presence_of :title, :description

 	default_scope { order("priority ASC") }
end
