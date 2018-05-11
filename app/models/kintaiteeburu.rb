class Kintaiteeburu < ApplicationRecord
  validates :勤務タイプ,:出勤時刻,:退社時刻, presence: true  
  # a class method import, with file passed through as an argument
  def self.import(file)
    # a block that runs through a loop in our CSV data       
    CSV.foreach(file.path, headers: true) do |row|
      hash = row.to_hash
      Kintaiteeburu.create(
                勤務タイプ: "%03d" % hash["勤務タイプ"].to_i,
                出勤時刻: hash["出勤時刻"],
                退社時刻: hash["退社時刻"],
                昼休憩時間: hash["昼休憩時間12:00~13:00"].to_f,
                夜休憩時間: hash["夜休憩時間18:00~19:00"].to_f,
                深夜休憩時間: hash["深夜休憩時間23:00~24:00"].to_f,
                早朝休憩時間: hash["早朝休憩時間4:00~6:00"].to_f,
                実労働時間: hash["実労働時間"].to_f,
                早朝残業時間: hash["早朝残業時間6:00~9:00"].to_f,
                残業時間: hash["残業時間19:00~23:00"].to_f,
                深夜残業時間: hash["深夜残業時間22:00~04:00"].to_f
                )
    end
  end
  def self.kintaitable_update_times
    Kintaiteeburu.all.each do |kintaiteeburu|
      start, finish = kintaiteeburu.出勤時刻.to_time, kintaiteeburu.退社時刻.to_time
      finish += 1.day if start > finish
      results = ApplicationController.helpers.time_calculate(start.strftime("%Y/%m/%d %H:%M"), finish.strftime("%Y/%m/%d %H:%M"), kintaiteeburu.勤務タイプ)
      kintaiteeburu.昼休憩時間 = (results[:hiru_kyukei] / 30).floor * 0.5
      kintaiteeburu.夜休憩時間 = (results[:yoru_kyukei] / 30).floor * 0.5
      kintaiteeburu.深夜休憩時間 = (results[:shinya_kyukei] / 30).floor * 0.5
      kintaiteeburu.早朝休憩時間 = (results[:souchou_kyukei] / 30).floor * 0.5
      kintaiteeburu.実労働時間 = ((results[:real_hours] + results[:fustu_zangyo] + results[:shinya_zangyou]) / 30).floor * 0.5
      kintaiteeburu.残業時間 = (results[:fustu_zangyo] / 30).floor * 0.5
      kintaiteeburu.深夜残業時間 = (results[:shinya_zangyou] / 30).floor * 0.5
      kintaiteeburu.save
    end
  end
end
