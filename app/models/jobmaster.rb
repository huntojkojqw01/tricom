class Jobmaster < ActiveRecord::Base
  self.table_name = :JOBマスタ
  self.primary_key = :job番号

  validates :job番号, uniqueness: true
  validates :job番号, :job名, presence: true
  validates :入力社員番号, numericality: { only_integer: true }, inclusion: {in: Shainmaster.pluck(:社員番号)}, allow_blank: true
  validates :関連Job番号, numericality: { only_integer: true }, inclusion: {in: Jobmaster.pluck(:job番号)}, allow_blank: true
  validates :ユーザ番号, inclusion: {in: Kaishamaster.pluck(:会社コード)}, allow_blank: true
  validates :分類コード, inclusion: {in: Bunrui.pluck(:分類コード)}, allow_blank: true
  validate :check_input

  has_one :event, foreign_key: :JOB
  belongs_to :kaishamaster, class_name: :Kaishamaster, foreign_key: :ユーザ番号
  belongs_to :bunrui,foreign_key: :分類コード

  alias_attribute :id, :job番号
  alias_attribute :job_name, :job名
  delegate :分類名, to: :bunrui, prefix: :bunrui, allow_nil: true

  # a class method import, with file passed through as an argument
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Jobmaster.create! row.to_hash
    end
  end

  # def to_param
  #   id.parameterize
  # end
  #
  def self.to_csv
    attributes = %w{job番号 job名 開始日 終了日 ユーザ番号 ユーザ名 入力社員番号 分類コード 分類名 関連Job番号 備考}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |job|
        csv << attributes.map{ |attr| job.send(attr) }
      end
    end
  end

  def check_input
    errors.add(:終了日, "は開始日以上の値にしてください。") if 開始日.present? && 終了日.present? && 開始日 > 終了日
  end
end
