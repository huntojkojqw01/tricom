class Keihihead < ActiveRecord::Base
  self.table_name = :keihi_heads
  self.primary_key = :申請番号
  include PgSearch
  multisearchable :against => %w{申請番号 日付 社員番号 申請者 交通費合計 日当合計 宿泊費合計
      その他合計 旅費合計 仮払金 合計 支給品 過不足 承認kubun 承認者 清算予定日 清算日 承認済区分}
  has_many :keihibodies, foreign_key: :申請番号, dependent: :destroy
  belongs_to :shainmaster, foreign_key: :社員番号

  accepts_nested_attributes_for :keihibodies,
                                allow_destroy: true,
                                reject_if: :all_blank

  alias_attribute :id, :申請番号

  after_destroy {|record|
    Keihibody.destroy(record.keihibodies.pluck(:id))
  }

  scope :current_member, ->(member) { where( 社員番号: member )}

  delegate :氏名, to: :shainmaster, prefix: :shainmaster, allow_nil: true
  # validates :清算予定日, presence: true, length: {minimum: 1}
  # validates :承認者, presence: true, length: {minimum: 1}
  validate :check_kubun

  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Keihihead.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{申請番号 日付 社員番号 申請者 交通費合計 日当合計 宿泊費合計
      その他合計 旅費合計 仮払金 合計 支給品 過不足 承認kubun 承認者 清算予定日 清算日 承認済区分}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |keihi_head|
        csv << attributes.map{ |attr| keihi_head.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end

  private
  def check_kubun
    if 承認kubun != "0"
      if self.承認者.empty? && self.清算予定日.nil?
        errors.add(:承認者, (I18n.t 'app.model.check_kubun.shoninsha'))
        errors.add(:清算予定日, (I18n.t 'app.model.check_kubun.seisanyoteibi'))
      elsif self.承認者.empty?
         errors.add(:承認者, (I18n.t 'app.model.check_kubun.shoninsha'))
      elsif self.清算予定日.nil?
        errors.add(:清算予定日, (I18n.t 'app.model.check_kubun.seisanyoteibi'))
      end
    end
  end
end