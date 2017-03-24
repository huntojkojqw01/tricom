class Myjobmaster < ActiveRecord::Base
  self.table_name = :MYJOBマスタ
  self.primary_key = :job番号, :社員番号

  validates :job番号, uniqueness: {scope: :社員番号}
  validates :job番号, :job名, :社員番号, presence: true
  validates :入力社員番号, numericality: { only_integer: true }, inclusion: {in: proc{Shainmaster.pluck(:社員番号)}}, allow_blank: true
  validates :関連Job番号, numericality: { only_integer: true }, inclusion: {in: proc{Jobmaster.pluck(:job番号)}}, allow_blank: true
  validates :ユーザ番号, inclusion: {in: proc{Kaishamaster.pluck(:会社コード)}}, allow_blank: true
  validates :分類コード, inclusion: {in: proc{Bunrui.pluck(:分類コード)}}, allow_blank: true
  validate :check_input

  has_one :event, foreign_key: :JOB
  belongs_to :kaishamaster, class_name: :Kaishamaster, foreign_key: :ユーザ番号
  belongs_to :bunrui,foreign_key: :分類コード
  belongs_to :shainmaster, foreign_key: :社員番号
  belongs_to :jobmaster, foreign_key: :job番号
  # alias_attribute :id, :job番号
  # alias_attribute :job_name, :job名
  delegate :分類名, to: :bunrui, prefix: :bunrui, allow_nil: true

  # a class method import, with file passed through as an argument
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Myjobmaster.create! row.to_hash
    end
  end

  # def to_param
  #   id.parameterize
  # end
  #
  def self.to_csv
    attributes = %w{社員番号 job番号 job名 開始日 終了日 ユーザ番号 ユーザ名 入力社員番号 分類コード 分類名 関連Job番号 備考 updated_at}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |myjob|
        csv << attributes.map{ |attr| myjob.send(attr) }
      end
    end
  end

  def check_input
    errors.add(:終了日, (I18n.t 'app.model.check_data_input')) if 開始日.present? && 終了日.present? && 開始日 > 終了日
  end
end
