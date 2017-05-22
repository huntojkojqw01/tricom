class Kintaiteeburu < ApplicationRecord
	validates :勤務タイプ,:出勤時刻,:退社時刻, presence: true
	# a class method import, with file passed through as an argument
	def self.import(file)
	    # a block that runs through a loop in our CSV data
	    CSV.foreach(file.path, headers: true) do |row|
	      # creates a user for each row in the CSV file
	      #Kintaiteeburu.create! row.to_hash
	      Kintaiteeburu.create(勤務タイプ: "001", 出勤時刻: "7:00", 退社時刻: "18:00", 昼休憩時間: 1.0, 夜休憩時間: 1.0, 深夜休憩時間: 0, 早朝休憩時間: 0.0, 実労働時間: 6.0, 早朝残業時間: 2, 残業時間: 2.0, 深夜残業時間: 0.0)
	    end
	end
end
