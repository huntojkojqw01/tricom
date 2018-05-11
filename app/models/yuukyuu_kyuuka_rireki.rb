class YuukyuuKyuukaRireki < ActiveRecord::Base
  self.table_name = :有給休暇履歴
  self.primary_key = :社員番号, :年月
  include PgSearch
  multisearchable :against => %w{社員番号 年月 }
  validates :年月,:社員番号, presence: true
  belongs_to :shainmaster, foreign_key: :社員番号
  after_save :update_getshozan_of_next_month

  def update_getshozan_of_next_month
    date = 年月.to_date
    return if date.month == 12
    next_month = (date + 1.month).strftime("%Y/%m")
    # tim ra ykkk cua cac thang sau:
    ykkk = YuukyuuKyuukaRireki.find_by(社員番号: 社員番号, 年月: next_month)
    if ykkk
      kyuukei_times = ykkk.月初有給残.to_f - ykkk.月末有給残.to_f
      kyuukei_times = 0.0 if kyuukei_times < 0.0
      ykkk.月初有給残 = 月末有給残
      ykkk.月末有給残 = ykkk.月初有給残 - kyuukei_times
      ykkk.save
    end
  end

  def calculate_getshozan
    return if 月初有給残.present?
    date = 年月.to_date
    first_month = date.beginning_of_year.strftime("%Y/%m")
    prev_month = (date - 1.month).strftime("%Y/%m")
    # tim ra nhung ykkk cua cac thang truoc:
    ykkks = YuukyuuKyuukaRireki.where(社員番号: 社員番号, 年月: first_month..prev_month)
    last_month_has_getmatsuzan = ykkks.map { |ykkk| { month: ykkk.年月.to_date.month, getmatsuzan: ykkk.月末有給残 } }
                    .sort_by { |i| - i[:month] }
                    .find {|i| i[:getmatsuzan].present? && i[:getmatsuzan].to_f >= 0}
    self.月初有給残 = last_month_has_getmatsuzan ? last_month_has_getmatsuzan[:getmatsuzan] : 12.0
  end

  def calculate_getmatsuzan(kintais = [])
    date = 年月.to_date
    kintais = Kintai.where(社員番号: 社員番号, 日付: date.beginning_of_month..date.end_of_month).order(:日付) if kintais.any?
    yuukyu = 0
    kintais.each do |kintai|
      case kintai.状態1
      when "30" then yuukyu += 1
      when "31", "32" then yuukyu += 0.5
      end
    end
    calculate_getshozan if 月初有給残.blank?
    self.月末有給残 = (月初有給残.to_f - yuukyu).to_f
    self.月末有給残 = 0.0 if self.月末有給残 < 0.0
  end

  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      YuukyuuKyuukaRireki.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{社員番号 年月 月初有給残 月末有給残}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |yuukyuu_kyuuka|
        csv << attributes.map{ |attr| yuukyuu_kyuuka.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
