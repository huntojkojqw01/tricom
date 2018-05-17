class Event < ActiveRecord::Base
  attr_accessor :kintai_daikyu_date
  include VerificationAssociations
  self.table_name = :events
  include PgSearch
  multisearchable :against => %w{開始 終了 joutai_状態名 basho_name job_job名 koutei_工程名 計上}
  
  before_update :doCaculateKousu
  before_create :doCaculateKousu
  after_save :doUpdateKintai, :updateMyBasho, :updateMyJob
  after_destroy :doUpdateKintai
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
    self.工数 = ApplicationController.helpers.caculate_koushuu(開始, 終了) if 開始.present? && 終了.present?
  end

  def estimate_kinmu_type(start_time)
    time = start_time.try(:to_datetime).to_i % (1.day.to_i) / 60.0
    Kintai::KINMU_TYPE.each { |type, value| puts value[:s] * 60; return type if value[:s] * 60 >= time }
    return nil
  end

  def doUpdateKintai
    ApplicationController.helpers.check_kintai_at_day_by_user(社員番号, 開始.to_date)
    shain = Shainmaster.find_by(社員番号: 社員番号)
    kintai = Kintai.find_by("Date(日付) = Date(?) AND 社員番号 = ?", 開始, 社員番号)
    if kintai
      # tim nhung su kien trong ngay hom do (開始),ma co trang thai khong phai la nghi:
      events = Event.joins(:joutaimaster).where("Date(開始) = Date(?)", 開始)
                                         .where(社員番号: 社員番号, 状態マスタ: { 状態区分: ['1', '5'] } )
                                         .where.not(開始: '', 終了: '')
      # tim ra joutai se thiet lap cho kintai , joutai chinh la cai dau tien trong cac event:
      joutai_first =  Event.joins(:joutaimaster)
                          .where("Date(開始) = Date(?)", 開始)
                          .where(社員番号: 社員番号, 状態マスタ: { 勤怠使用区分: '1' } )
                          .where.not(開始: '', 終了: '')
                          .order(開始: :asc).first.try(:状態コード) || ''

      if events.any?
        time_start, time_end = events.minimum(:開始), events.maximum(:終了)
        kinmu_type = estimate_kinmu_type(time_start) || shain.try(:勤務タイプ)
        times = ApplicationController.helpers.time_calculate(time_start, time_end, kinmu_type, events)
        real_hours = times[:real_hours] / 15 * 0.25
        futsu_zangyou = times[:fustu_zangyo] / 15 * 0.25
        shinya_zangyou = times[:shinya_zangyou] / 15 * 0.25
        chikoku_soutai = times[:chikoku_soutai] / 15 * 0.25
        kintai.update(勤務タイプ: kinmu_type, 出勤時刻: time_start,
          退社時刻: time_end, 実労働時間: real_hours, 普通残業時間: futsu_zangyou,
          深夜残業時間: shinya_zangyou, 遅刻時間: chikoku_soutai, 状態1: joutai_first)
      else
        kintai.update(勤務タイプ: '', 出勤時刻: '', 退社時刻: '',
        実労働時間: '', 遅刻時間: '', 早退時間: '', 普通残業時間: '', 深夜残業時間: '', 状態1: joutai_first)
      end # if events.any?

      # # tinh toan su kien di muon ve som
      # chikoku_total = Event.joins(:joutaimaster)
      #                     .where("Date(開始) = Date(?) AND 状態マスタ.状態区分 = ? AND 社員番号 = ?", 開始, "3", 社員番号)
      #                     .where.not(開始: '', 終了: '')
      #                     .inject { |sum, event| sum += get_time_diff(event.開始,event.終了) }
      # kintai.update(遅刻時間: chikoku_total || 0.0)

      # huy bo lien he giua 2 kintai ve van de nghi bu lam bu:
      if kintai.代休相手日付.present?
        daikyu_aite_hidzuke = Kintai.find_by(社員番号: 社員番号, 日付: kintai.代休相手日付)
        if daikyu_aite_hidzuke
          if daikyu_aite_hidzuke.代休取得区分 == '1' # '1' tuc la da nghi bu, thi chuyen thanh '0' tuc la chua dc nghi bu.
            daikyu_aite_hidzuke.update(代休取得区分: '0', 代休相手日付: '', 備考: '')
          elsif daikyu_aite_hidzuke.代休取得区分 == ''
            daikyu_aite_hidzuke.update(状態1: '', 代休相手日付: '', 備考: '')
          end
        end
      end

      # tao lien he giua 2 kintai ve van de nghi bu lam bu moi:
      if 状態コード.in?(['105', '109', '113']) # 振替休暇, 午前振休, 午後振休
        if kintai_daikyu_date.present?
          furikyuus = {
            '105' => ['の振休', 'の振出'],
            '109' => ['の午前振休', 'の午前振出'],
            '113' => ['の午後振休', 'の午後振出']
          }
          daikyu_aite_hidzuke = Kintai.find_by(日付: kintai_daikyu_date.to_date, 社員番号: 社員番号)
          if daikyu_aite_hidzuke
            bikou1 = "#{ kintai_daikyu_date.to_date.to_s }#{ furikyuus[状態コード][0] }"
            bikou2 = "#{ 開始.to_date.to_s}#{ furikyuus[状態コード][1] }"
            kintai.update(代休相手日付: kintai_daikyu_date.to_date.strftime("%Y/%m/%d"), 代休取得区分: '', 備考: bikou1)
            daikyu_aite_hidzuke.update(代休相手日付: 開始.to_date.strftime("%Y/%m/%d"), 代休取得区分: '1', 備考: bikou2)
          end # of if daikyu_aite_hidzuke
        end # of if kintai_daikyu_date.present?
      elsif 状態コード.in?(['103', '107', '111'])
        kintai.update(代休取得区分: '0', 代休相手日付: '', 備考: '')
      else
        kintai.update(代休取得区分: '', 代休相手日付: '', 備考: '')
      end
    end # if kintai
  end

  def get_time_diff(start_time, end_time)  
    ((end_time.to_time - start_time.to_time).to_i / 900) * 0.25
  rescue
    0
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

  def updateMyBasho
    mybasho = Mybashomaster.find_by(社員番号: 社員番号, 場所コード: 場所コード)
    if mybasho
      mybasho.update(updated_at: Time.now)               
    else
      basho = Bashomaster.find_by(場所コード: 場所コード)
      if basho
        mybasho = Mybashomaster.new(basho.slice(:場所コード, :場所名, :場所名カナ, :SUB, :場所区分, :会社コード)
                                           .merge(社員番号: 社員番号))
        mybasho.save
      end
    end
  end

  def updateMyJob
    myjob = Myjobmaster.find_by(社員番号: 社員番号, job番号: self.JOB)
    if myjob
      myjob.update(updated_at: Time.now)               
    else
      job = Jobmaster.find_by(job番号: self.JOB)
      if job
        myjob = Myjobmaster.new(job.slice(:job番号, :job名, :開始日, :終了日, :ユーザ番号, :ユーザ名, :入力社員番号, :分類コード, :分類名, :関連Job番号, :備考)
                                    .merge(社員番号: 社員番号))
        myjob.save        
      end
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
