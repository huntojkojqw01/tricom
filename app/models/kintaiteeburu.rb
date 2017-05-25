class Kintaiteeburu < ApplicationRecord
	validates :勤務タイプ,:出勤時刻,:退社時刻, presence: true	
	# a class method import, with file passed through as an argument
	def self.import(file)
	    # a block that runs through a loop in our CSV data	     
	    CSV.foreach(file.path, headers: true) do |row|
	       	hash=row.to_hash
	       	start=hash["出勤時刻"].split(':')
	       	hash["出勤時刻"]=Time.new(2000,1,1,start.first,start.last)
	       	finish=hash["退社時刻"].split(':')
	       	hash["退社時刻"]=Time.new(2000,1,1,finish.first,finish.last)       		       	
	      	Kintaiteeburu.create(
	      						勤務タイプ: hash["勤務タイプ"],
	      						出勤時刻: hash["出勤時刻"],
	      						退社時刻: hash["退社時刻"],
	      						昼休憩時間: hash["昼休憩時間"]=="" ? nil : hash["昼休憩時間"].to_f,
	      						夜休憩時間: hash["夜休憩時間"]=="" ? nil : hash["夜休憩時間"].to_f,
	      						深夜休憩時間: hash["深夜休憩時間"]=="" ? nil : hash["深夜休憩時間"].to_f,
	      						早朝休憩時間: hash["早朝休憩時間"]=="" ? nil : hash["早朝休憩時間"].to_f,
	      						実労働時間: hash["実労働時間"]=="" ? nil : hash["実労働時間"].to_f,
	      						早朝残業時間: hash["早朝残業時間"]=="" ? nil : hash["早朝残業時間"].to_f,
	      						残業時間: hash["残業時間"]=="" ? nil : hash["残業時間"].to_f,
	      						深夜残業時間: hash["深夜残業時間"]=="" ? nil : hash["深夜残業時間"].to_f
	      						)	      	
	    end
	    
	end		
end
