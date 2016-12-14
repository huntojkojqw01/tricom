class Setsubi < ActiveRecord::Base
	self.table_name = :設備マスタ
 	self.primary_key = :設備コード
  validates :設備コード, :設備名, presence: true
  validates :設備コード, uniqueness: true
  has_many :setsubiyoyaku, dependent: :destroy, foreign_key: :設備コード

 	def self.import(file)transaction
    	CSV.foreach(file.path, headers: true) do |row|
      		Setsubi.create! row.to_hash
    	end
  	end

  	def self.to_csv
    	attributes = %w{設備コード 設備名 備考}

    	CSV.generate(headers: true) do |csv|
      		csv << attributes

      		all.each do |setsubi|
        		csv << attributes.map{ |attr| setsubi.send(attr) }
      		end
    	end
  	end
end
