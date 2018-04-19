class Event < ActiveRecord::Base
  include VerificationAssociations
  self.table_name = :events
  include PgSearch
  multisearchable :against => %w{開始 終了 joutai_状態名 basho_name job_job名 koutei_工程名 計上}

  after_update :doUpdateKintai
  after_create :doUpdateKintai
  after_destroy :doUpdateKintai
  before_update :doCaculateKousu
  before_create :doCaculateKousu
  validates :社員番号, :開始, :状態コード, presence: true
  validates :工程コード, :場所コード, :JOB, presence: true, if: Proc.new{|event| (event.joutaimaster.try(:状態区分) == '1' || event.joutaimaster.try(:状態区分) == '5' ) && !(event.joutaimaster.try(:状態コード) == '60' && Time.parse(event.開始).hour >= 9)}
  validate :check_date_input
  validates_numericality_of :工数, message: I18n.t('errors.messages.not_a_number'), :allow_blank => true
  validates :状態コード, inclusion: {in: proc{Joutaimaster.pluck(:状態コード)}}, allow_blank: true
  validates :場所コード, inclusion: {in: proc{Bashomaster.pluck(:場所コード)}}, allow_blank: true
  validates :JOB, inclusion: {in: proc{Jobmaster.pluck(:job番号)}}, allow_blank: true
  belongs_to :shainmaster, foreign_key: :社員番号
  belongs_to :joutaimaster, foreign_key: :状態コード
  belongs_to :bashomaster, foreign_key: :場所コード
  belongs_to :kouteimaster, foreign_key: [:工程コード,:所属コード]
  belongs_to :shozokumaster, foreign_key: :所属コード
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


  def doCaculateKousu
    if self.開始 != '' && self.終了 != ''
      kousu = ApplicationController.helpers.caculate_koushuu(self.開始, self.終了)
      self.工数 = kousu.to_f.round(2)
    end

  end
  def doUpdateKintai
    ApplicationController.helpers.check_kintai_at_day_by_user(self.社員番号, self.開始.to_date)
    kintai = Kintai.where("Date(日付) = Date(?)",self.開始).where(社員番号: self.社員番号).first
    old_joutai = kintai.状態1
    if !kintai.nil?
      kinmu_type = Shainmaster.find(self.社員番号).勤務タイプ
      events = Event.where("Date(開始) = Date(?)",self.開始).where(社員番号: self.社員番号).joins(:joutaimaster).where("状態マスタ.状態区分 = ? or 状態マスタ.状態区分 = ?","1","5")
      .where.not(開始: '').where.not(終了: '')
      joutaiEvents = Event.where("Date(開始) = Date(?)",self.開始).where(社員番号: self.社員番号).joins(:joutaimaster).where(状態マスタ: {勤怠使用区分: "1"}).where.not(開始: '').where.not(終了: '')
      joutai_first = ''
      if joutaiEvents.count > 0
        joutai_first = joutaiEvents.order(開始: :asc).first.状態コード
      end
      if events.count > 0
        time_start = events.order(開始: :asc).first.開始
        time_end = events.order(終了: :desc).first.終了
        # joutai_first = events.order(開始: :asc).first.状態コード
        hh_mm = time_start[11,15]
        if hh_mm <= "07:00"
          kinmu_type = "001"
        elsif hh_mm > "07:00" && hh_mm <= "07:30"
          kinmu_type = "002"
        elsif hh_mm > "07:30" && hh_mm <= "08:00"
          kinmu_type = "003"
        elsif hh_mm > "08:00" && hh_mm <= "08:30"
          kinmu_type = "004"
        elsif hh_mm > "08:30" && hh_mm <= "09:00"
          kinmu_type = "005"
        elsif hh_mm > "09:00" && hh_mm <= "09:30"
          kinmu_type = "006"
        elsif hh_mm > "09:30" && hh_mm <= "10:00"
          kinmu_type = "007"
        elsif hh_mm > "10:00" && hh_mm <= "10:30"
          kinmu_type = "008"
        elsif hh_mm > "10:30"
          kinmu_type = "009"
        end
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

        zangyou_kubun = Shainmaster.find(self.社員番号).残業区分
        if zangyou_kubun == "1"
          Kintai.find(kintai.id).update(勤務タイプ: kinmu_type, 出勤時刻: time_start,
          退社時刻: time_end, 実労働時間: real_hours_total, 普通残業時間: fustu_zangyo_total,
          深夜残業時間: shinya_zangyou_total, 状態1: joutai_first)
        else
          Kintai.find(kintai.id).update(勤務タイプ: kinmu_type, 出勤時刻: time_start,
          退社時刻: time_end, 実労働時間: real_hours_total,普通残業時間: '',
          深夜残業時間: '', 状態1: joutai_first)
        end
      else
        kintai.update(勤務タイプ: '', 出勤時刻: '', 退社時刻: '',
        実労働時間: '', 遅刻時間: '', 早退時間: '', 普通残業時間: '', 深夜残業時間: '', 状態1: joutai_first)
      end
      # tinh toan su kien di muon ve som
      chikoku_soutai_events = Event.where("Date(開始) = Date(?)",self.開始).where(社員番号: self.社員番号).joins(:joutaimaster).where("状態マスタ.状態区分 = ?","3")
      .where.not(開始: '').where.not(終了: '')
      if chikoku_soutai_events.count > 0
        chikoku_total = 0
        chikoku_soutai_events.each do |event|
          chikoku = get_time_diff(event.開始,event.終了)
          chikoku_total += chikoku
        end
        kintai.update(遅刻時間: chikoku_total)
      else
        kintai.update(遅刻時間: '')
      end

      @kintai = Kintai.find(kintai.id)
      if old_joutai != joutai_first
        if @kintai.代休相手日付 != ''
          daikyu_aite_hidzuke = Kintai.current_user(self.社員番号).find_by(日付: @kintai.代休相手日付)
          if daikyu_aite_hidzuke
            if daikyu_aite_hidzuke.代休取得区分 == '1'
              daikyu_aite_hidzuke.update(代休取得区分: '0', 代休相手日付: '', 備考: '')
            end
            if daikyu_aite_hidzuke.代休取得区分 == ''
              daikyu_aite_hidzuke.update(状態1: '', 代休相手日付: '', 備考: '')
            end
          end
        end
        if joutai_first.in?(['103','107','111']) #振出
          @kintai.update(代休取得区分: '0', 代休相手日付: '', 備考: '')
        elsif !joutai_first.nil?
          @kintai.update(代休取得区分: '', 代休相手日付: '', 備考: '')
        end
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
    if 開始.present? && 終了.present?
      if 開始 >= 終了
        errors.add(:終了, (I18n.t 'app.model.check_data_input'))
      else
        day = 開始.to_date
        if day.beginning_of_day < 開始.to_time && 終了.to_time < day.end_of_day && (day.saturday? || day.sunday?) && 状態コード == '30'
          errors.add(:状態コード, '休日で全日休の指定はできない')        
        end
      end
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
