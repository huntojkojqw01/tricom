class Event < ActiveRecord::Base
  self.table_name = :events

  validates :社員番号, :開始, :状態コード, presence: true
  validates :工程コード, :場所コード, :JOB, presence: true, if: Proc.new{|event| event.joutaimaster.try(:状態区分) == '1'}
  validate :check_date_input

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

  def check_date_input
    if 開始.present? && 終了.present? && 開始 >= 終了
      errors.add(:終了, "は開始日以上の値にしてください。")
    end
  end

  def self.to_csv
    attributes = %w{id  社員番号 開始 終了 状態コード 場所コード 所属コード 工程コード 工数 計上 comment}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |event|
        csv << attributes.map{ |attr| event.send(attr) }
      end
    end
  end

end
