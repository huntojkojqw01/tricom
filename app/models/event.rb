class Event < ActiveRecord::Base
  include VerificationAssociations
  self.table_name = :events
  include PgSearch
  multisearchable :against => %w{開始 終了 joutai_状態名 basho_name job_job名 koutei_工程名 計上}

  after_update :doUpdateKintai
  after_create :doUpdateKintai
  after_destroy :doUpdateKintai
  validates :社員番号, :開始, :状態コード, presence: true
  validates :工程コード, :場所コード, :JOB, presence: true, if: Proc.new{|event| event.joutaimaster.try(:状態区分) == '1' && !(event.joutaimaster.try(:状態コード) == '60' && Time.parse(event.開始).hour >= 9)}
  validate :check_date_input
  validates_numericality_of :工数, message: I18n.t('errors.messages.not_a_number'), :allow_blank => true
  validates :状態コード, inclusion: {in: proc{Joutaimaster.pluck(:状態コード)}}, allow_blank: true
  validates :場所コード, inclusion: {in: proc{Bashomaster.pluck(:場所コード)}}, allow_blank: true
  validates :JOB, inclusion: {in: proc{Jobmaster.pluck(:job番号)}}, allow_blank: true
  belongs_to :shainmaster, foreign_key: :社員番号
  belongs_to :joutaimaster, foreign_key: :状態コード
  belongs_to :bashomaster, foreign_key: :場所コード
  belongs_to :kouteimaster, foreign_key: [:所属コード,:工程コード]
  # belongs_to :shozai
  belongs_to :jobmaster, foreign_key: :JOB

  delegate :job名, to: :jobmaster, prefix: :job, allow_nil: true
  delegate :状態名, to: :joutaimaster, prefix: :joutai, allow_nil: true
  delegate :工程名, to: :kouteimaster, prefix: :koutei, allow_nil: true

  alias_attribute :shain_no, :社員番号
  alias_attribute :start_time, :開始
  alias_attribute :end_time, :終了
  alias_attribute :joutai_code, :状態コード
  alias_attribute :basho_code, :場所コード
  alias_attribute :kisha, :帰社区分
  alias_attribute :koutei_code, :工程コード
  alias_attribute :shozoku_code, :所属コード
  alias_attribute :kousuu, :工数
  alias_attribute :shozai_code, :所在コード

  def doUpdateKintai
    ApplicationController.helpers.check_kintai_at_day_by_user(self.社員番号, self.開始.to_date)
    kintai = Kintai.where("Date(日付) = Date(?)",self.開始).where(社員番号: self.社員番号).first
    if !kintai.nil?
      kinmu_type = Shainmaster.find(self.社員番号).勤務タイプ
      events = Event.where("Date(開始) = Date(?)",self.開始).where(社員番号: self.社員番号).joins(:joutaimaster).where(状態マスタ: {状態区分: "1"})
      if events.count > 0
        time_start = events.order(開始: :asc).first.開始
        time_end = events.order(終了: :desc).first.終了
        real_hours_total = 0
        fustu_zangyo_total = 0
        shinya_zangyou_total = 0
        events.each do |event|
          real_hours = 0
          fustu_zangyo = 0
          shinya_zangyou = 0

          start_time_date = event.開始[0, 10]
          end_time_date = event.終了[0,10]

          nextDay = start_time_date.to_date.next
          next_time_date = nextDay.to_s


          hiru_kyukei_start =     start_time_date + ' 12:00'
          hiru_kyukei_end =       start_time_date + ' 13:00'
          yoru_kyukei_start =     start_time_date + ' 18:00'
          yoru_kyukei_end =       start_time_date + ' 19:00'
          shinya_kyukei_start =   start_time_date + ' 23:00'
          shinya_kyukei_end =     next_time_date + ' 00:00'
          souchou_kyukei_start =  next_time_date + ' 04:00'
          souchou_kyukei_end =    next_time_date + ' 07:00'

          if get_time_diff(event.開始,hiru_kyukei_start) > 0
            hiru_diff_1 = get_time_diff(hiru_kyukei_start,event.終了)
            hiru_diff_2 = get_time_diff(hiru_kyukei_end,event.終了)
            hiru_kyukei = hiru_diff_1 - hiru_diff_2
          elsif get_time_diff(event.開始,hiru_kyukei_end) > 0
            hiru_diff_1 = get_time_diff(event.開始,event.終了)
            hiru_diff_2 = get_time_diff(hiru_kyukei_end,event.終了)
            hiru_kyukei = hiru_diff_1 - hiru_diff_2
          else
            hiru_kyukei = 0
          end

          if get_time_diff(event.開始,yoru_kyukei_start) > 0
            yoru_diff_1 = get_time_diff(yoru_kyukei_start,event.終了)
            yoru_diff_2 = get_time_diff(yoru_kyukei_end,event.終了)
            yoru_kyukei = yoru_diff_1 - yoru_diff_2
          elsif get_time_diff(event.開始,yoru_kyukei_end) > 0
            yoru_diff_1 = get_time_diff(event.開始,event.終了)
            yoru_diff_2 = get_time_diff(yoru_kyukei_end,event.終了)
            yoru_kyukei = yoru_diff_1 - yoru_diff_2
          else
            yoru_kyukei = 0
          end

          if get_time_diff(event.開始,shinya_kyukei_start) > 0
            shinya_diff_1 = get_time_diff(shinya_kyukei_start,event.終了)
            shinya_diff_2 = get_time_diff(shinya_kyukei_end,event.終了)
            shinya_kyukei = shinya_diff_1 - shinya_diff_2
          elsif get_time_diff(event.開始,shinya_kyukei_end) > 0
            shinya_diff_1 = get_time_diff(event.開始,event.終了)
            shinya_diff_2 = get_time_diff(shinya_kyukei_end,event.終了)
            shinya_kyukei = shinya_diff_1 - shinya_diff_2
          else
            shinya_kyukei = 0
          end

          if get_time_diff(event.開始,souchou_kyukei_start) > 0
            souchou_diff_1 = get_time_diff(souchou_kyukei_start,event.終了)
            souchou_diff_2 = get_time_diff(souchou_kyukei_end,event.終了)
            souchou_kyukei = souchou_diff_1 - souchou_diff_2
          elsif get_time_diff(event.開始,souchou_kyukei_end) > 0
            souchou_diff_1 = get_time_diff(event.開始,event.終了)
            souchou_diff_2 = get_time_diff(souchou_kyukei_end,event.終了)
            souchou_kyukei = souchou_diff_1 - souchou_diff_2
          else
            souchou_kyukei = 0
          end

          real_hours = get_time_diff(event.開始,event.終了)
          real_hours = real_hours - hiru_kyukei - yoru_kyukei - shinya_kyukei - souchou_kyukei

          if shinya_kyukei > 0
            fustu_zangyo = get_time_diff(event.開始,shinya_kyukei_start)
            fustu_zangyo = fustu_zangyo - hiru_kyukei - yoru_kyukei
          else
            fustu_zangyo = real_hours
          end
          if fustu_zangyo < 0
            fustu_zangyo = 0
          end

          if souchou_kyukei > 0
            shinya_zangyou = get_time_diff(shinya_kyukei_end,souchou_kyukei_start)
          else
            shinya_zangyou = get_time_diff(shinya_kyukei_end,event.終了)
          end
          if shinya_zangyou < 0
            shinya_zangyou = 0
          end
          real_hours_total += real_hours
          fustu_zangyo_total += fustu_zangyo
          shinya_zangyou_total += shinya_zangyou
        end
        fustu_zangyo_total = fustu_zangyo_total - 8
        if fustu_zangyo_total < 0
          fustu_zangyo_total = 0
        end
        start_time_default = time_start[0,10]
        end_time_default = time_start[0,10]
        case kinmu_type
          when '001'
            start_time_default += ' 07:00'
            end_time_default += ' 16:00'
          when '002'
            start_time_default += ' 07:30'
            end_time_default += ' 16:30'
          when '003'
            start_time_default += ' 08:00'
            end_time_default += ' 17:00'
          when '004'
            start_time_default += ' 08:30'
            end_time_default += ' 17:30'
          when '005'
            start_time_default += ' 09:00'
            end_time_default += ' 18:00'
          when '006'
            start_time_default += ' 09:30'
            end_time_default += ' 18:30'
          when '007'
            start_time_default += ' 10:00'
            end_time_default += ' 19:00'
          when '008'
            start_time_default += ' 10:30'
            end_time_default += ' 19:30'
          when '009'
            start_time_default += ' 11:00'
            end_time_default += ' 20:00'
        end
        if kinmu_type != ''
          chikoku = get_time_diff(start_time_default, time_start)
          soutai = get_time_diff(time_end,end_time_default)
          chikoku_soutai = soutai + chikoku
        else
          chikoku_soutai = 0
        end
        Kintai.find(kintai.id).update(勤務タイプ: kinmu_type, 出勤時刻: time_start,
        退社時刻: time_end, 実労働時間: real_hours_total, 遅刻時間: chikoku, 早退時間: soutai,
        普通残業時間: fustu_zangyo_total, 深夜残業時間: shinya_zangyou_total)
      else
        kintai.update(勤務タイプ: kinmu_type, 出勤時刻: '', 退社時刻: '',
        実労働時間: '', 遅刻時間: '', 早退時間: '', 普通残業時間: '', 深夜残業時間: '')
      end
    end

  end

  def get_time_diff(start_time, end_time)
    date_1 = start_time.to_datetime
    date_2 = end_time.to_datetime
    koushuu = ((date_2 - date_1)*24)
    if koushuu < 0
      return 0
    else
      kousu = []
      countup = 0
      until countup > 1000 do
        kousu.push(countup)
        countup += 0.5
      end
      for num in kousu do
        if num > koushuu && num > 0
          return (num-0.5)
        end
      end
      return koushuu
    end
  end


  def check_date_input
    if 開始.present? && 終了.present? && 開始 >= 終了
      errors.add(:終了, (I18n.t 'app.model.check_data_input'))
    end
  end
  def basho_name
    basho = Bashomaster.find_by(場所コード: self.場所コード)
    if basho.try(:場所区分) == '2'
      basho.try(:kaisha_name)
    else
      basho.try(:name)
    end
  end
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Event.create! row.to_hash
    end
  end
  def self.to_csv
    attributes = %w{社員番号 開始 終了 状態コード 場所コード JOB 所属コード 工程コード 工数 計上 comment}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |event|
        csv << attributes.map{ |attr| event.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
