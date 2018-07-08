class Kintai < ActiveRecord::Base
  # scope :current_month, ->(member) { where( 社員番号: member, 日付: Date.today.beginning_of_month..Date.today.end_of_month )}
  include PgSearch
  multisearchable :against => %w{日付 曜日 勤務タイプ joutai_状態名 備考 社員番号}

  scope :selected_month, ->(member,month) { where( 社員番号:  member, 日付: month.beginning_of_month..month.end_of_month ) }
  scope :selected_tocurrent, ->(member,month) { where( 社員番号:  member, 日付: Date.today.beginning_of_year..month.prev_month.end_of_month ) }
  scope :current_user, ->(member) { where( 社員番号: member)}
  scope :get_by_mounth, ->(date) { where(日付: date.beginning_of_month..date.end_of_month)}
  scope :get_by_mounth_hoshukeitai, ->(date) { where(日付: date.beginning_of_month..date.end_of_month, 曜日: "2")}
  scope :day_off,->{where(状態1: 30)}
  scope :morning_off,->{where(状態1: 31)}
  scope :afternoon_off,->{where(状態1: 32)}
  scope :business_trip,->{where(状態1: 12)}
  scope :transfer_holiday,->{where(状態1: 35)}
  scope :half_day_off_before,->{where(状態1: 36)}
  scope :half_day_off_after,->{where(状態1: 37)}
  scope :holiday_work,->{where(状態1: 14)}
  scope :night_work,->{where(状態1: 15)}

  belongs_to :joutaimaster, foreign_key: :状態1
  belongs_to :shainmaster, foreign_key: :社員番号
  enum 曜日: {日: "0", 月: "1", 火: "2", 水: "3", 木: "4", 金: "5", 土: "6"}

  KINMU_TYPE = {
    '001' => { s: 7, e: 16, stext: '07:00', etext: '16:00' },
    '002' => { s: 7.5, e: 16.5, stext: '07:30', etext: '16:30' },
    '003' => { s: 8, e: 17, stext: '07:00', etext: '16:00' },
    '004' => { s: 8.5, e: 17.5, stext: '08:30', etext: '17:30' },
    '005' => { s: 9, e: 18, stext: '09:00', etext: '18:00' },
    '006' => { s: 9.5, e: 19.5, stext: '09:30', etext: '19:30' },
    '007' => { s: 10, e: 20, stext: '10:00', etext: '20:00' },
    '008' => { s: 10.5, e: 20.5, stext: '10:30', etext: '20:30' },
    '009' => { s: 11, e: 21, stext: '11:00', etext: '21:00' },
    '010' => { s: 9, e: 14, stext: '09:00', etext: '14:00' },
    '011' => { s: 14, e: 18, stext: '14:00', etext: '18:00' }
  }
  
  validate :check_joutai1
  validate :check_date_input
  validates :実労働時間, numericality: { greater_than_or_equal_to: 0}, allow_nil: true
  validates :遅刻時間, numericality: { greater_than_or_equal_to: 0}, allow_nil: true
  validates :普通残業時間, numericality: { greater_than_or_equal_to: 0}, allow_nil: true
  validates :深夜残業時間, numericality: { greater_than_or_equal_to: 0}, allow_nil: true
  validates :普通保守時間, numericality: { greater_than_or_equal_to: 0}, allow_nil: true
  validates :深夜保守時間, numericality: { greater_than_or_equal_to: 0}, allow_nil: true
  delegate :状態名, to: :joutaimaster, prefix: :joutai, allow_nil: true

  before_update :check_joutai_to_update_kinmutype

  def check_joutai_to_update_kinmutype
    if 状態1.present?
      joutaikubun = Joutaimaster.find_by(状態コード: 状態1).try(:状態区分)
      if joutaikubun == '2' || joutaikubun == '6'
        self.勤務タイプ = ''
      end
    end

  end
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Kintai.create! row.to_hash
    end
  end
  def self.to_csv
    attributes = %w{日付 曜日 勤務タイプ 実労働時間 普通残業時間 深夜残業時間 普通保守時間
      深夜保守時間 保守携帯回数 状態1 状態2 状態3 備考 社員番号 入力済 holiday 代休相手日付 代休取得区分
      出勤時刻 退社時刻 遅刻時間 早退時間}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |kintai|
        csv << attributes.map{ |attr| kintai.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end

  # def shain_logined?
  #   社員番号 == Thread.current[:session][:user] if !Thread.current[:session].nil?
  # end
  private
  def check_date_input
    if 出勤時刻.present? && 退社時刻.present?
      if 出勤時刻 > 退社時刻
        errors.add(:退社時刻, (I18n.t 'app.model.check_time_attendance'))
      end
      if ((退社時刻 - 出勤時刻)/1.hour).to_i > 22
        errors.add(:退社時刻, (I18n.t 'app.model.check_time'))
      end
    end
  end

  def check_joutai1
    if 状態1.present?
      @joutaimaster = Joutaimaster.find_by 状態コード: 状態1
      if @joutaimaster.nil?
        errors.add(:状態1,  (I18n.t 'app.model.check_joutai1'))
      end
    end
  end
end
