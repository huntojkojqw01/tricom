class Shainmaster < ActiveRecord::Base
  self.table_name = :社員マスタ
  self.primary_key = :社員番号
  before_save :strip_shainmaster_code
  include PgSearch
  multisearchable :against => %w{序列 社員番号 連携用社員番号 氏名 shozoku_name roru_ロール名 yakushoku_役職名 内線電話番号 有給残数 }
  # default_scope { where("社員番号 is not '#{ENV['admin_user']}'")}
  default_scope { order(序列: :asc, 社員番号: :asc) }
  validates :社員番号,:氏名, :連携用社員番号, presence: true
  validates :社員番号, uniqueness: true

  has_many :events, dependent: :destroy, foreign_key: :社員番号
  has_one :user, dependent: :destroy, foreign_key: :担当者コード
  has_many :kairan, dependent: :destroy, foreign_key: :発行者
  has_many :kairanshosai, dependent: :destroy, foreign_key: :対象者
  has_one :keihihead, dependent: :destroy, foreign_key: :社員番号
  has_many :kintais, dependent: :destroy, foreign_key: :社員番号
  has_many :setsubiyoyaku, dependent: :destroy, foreign_key: :予約者
  has_many :mybashomaster, dependent: :destroy, foreign_key: :社員番号
  has_many :myjobmaster, dependent: :destroy, foreign_key: :社員番号
  has_many :mykaishamaster, dependent: :destroy, foreign_key: :社員番号
  has_many :jobmaster, dependent: :nullify, foreign_key: :入力社員番号
  has_many :shouninsha, class_name: Shoninshamst.name, foreign_key: :承認者, dependent: :destroy
  has_many :shinseisha, class_name: Shoninshamst.name, foreign_key: :申請者, dependent: :destroy

  has_many :send_dengon, class_name: Dengon.name, foreign_key: :入力者, dependent: :destroy
  has_many :receive_dengon, class_name: Dengon.name, foreign_key: :社員番号, dependent: :destroy
  has_many :send_dengons, through: :send_dengon, source: :input_user
  has_many :receive_dengons, through: :receive_dengon, source: :to_user
  has_many :rorumenbas, dependent: :destroy, foreign_key: :社員番号
  has_many :yuukyuu_kyuuka_rireki, dependent: :destroy, foreign_key: :社員番号
  has_one :setting, dependent: :destroy, foreign_key: :社員番号
  has_one :tsushinseigyou, dependent: :destroy, foreign_key: :社員番号, class_name: Tsushinseigyou.name
  belongs_to :shozai, foreign_key: :所在コード
  belongs_to :shozokumaster, foreign_key: :所属コード
  belongs_to :yakushokumaster, foreign_key: :役職コード
  belongs_to :rorumaster, foreign_key: :デフォルトロール
  alias_attribute :title, :氏名
  alias_attribute :id, :社員番号

  scope :has_not_tantousha, -> { where '社員番号 not in (select 担当者コード from 担当者マスタ)' }
  scope :get_kubun, -> { where(区分: false) }
  delegate :所在名, to: :shozai, prefix: :shozai, allow_nil: true
  delegate :name, to: :shozokumaster, prefix: :shozoku, allow_nil: true
  delegate :ロール名, to: :rorumaster, prefix: :roru, allow_nil: true
  delegate :役職名, to: :yakushokumaster, prefix: :yakushoku, allow_nil: true
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Shainmaster.create! row.to_hash
    end
  end

  def events
    super || build_events
  end

  def user
    super || build_user
  end

  def self.to_csv
    attributes = %w{序列 社員番号 連携用社員番号 氏名 所属コード デフォルトロール 直間区分 役職コード 内線電話番号 伝言件数 回覧件数 所在コード 有給残数 残業区分 勤務タイプ }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |shainmaster|
        csv << attributes.map{ |attr| shainmaster.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
  def strip_shainmaster_code
    self.社員番号.strip!
  end  
end
