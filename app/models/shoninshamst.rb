class Shoninshamst < ActiveRecord::Base
  self.table_name = :承認者マスタ
  include PgSearch
  multisearchable :against => %w{shinseisha_氏名 shouninsha_氏名 順番}
  scope :current_user, ->(member) {where( 承認者: member)}
  belongs_to :shouninsha, foreign_key: :承認者, class_name: 'Shainmaster'
  belongs_to :shinseisha, foreign_key: :申請者, class_name: 'Shainmaster'
  delegate :氏名, to: :shainmaster, prefix: :shainmaster, allow_nil: true

  validates :申請者, :承認者, presence: true

  delegate :title, to: :shouninsha, prefix: :shonin, allow_nil: true
  delegate :氏名, to: :shinseisha, prefix: :shinseisha, allow_nil: true
  delegate :氏名, to: :shouninsha, prefix: :shouninsha, allow_nil: true
  validate :check_shainmaster_equal
  validates :申請者, uniqueness: { scope: :承認者}
  validates :承認者, uniqueness: { scope: :申請者}
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Shoninshamst.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{申請者 承認者 順番}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |shoninshamst|
        csv << attributes.map{ |attr| shoninshamst.send(attr) }
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
  private
  def check_shainmaster_equal
    if self.申請者 == self.承認者
      errors.add(:申請者, (I18n.t 'app.model.check_shainmaster_equal'))
      errors.add(:承認者, (I18n.t 'app.model.check_shainmaster_equal'))
    end
  end
end
