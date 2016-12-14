class Joutaimaster < ActiveRecord::Base
  self.table_name = :状態マスタ
  self.primary_key = :状態コード

  scope :web_use, -> { where( WEB使用区分:'1')}

  validates :状態コード, :状態名, presence: true
  validates :状態コード, uniqueness: true

  has_many :event, foreign_key: :状態コード
  has_many :kintais, foreign_key: :状態1

  alias_attribute :id, :状態コード
  alias_attribute :name, :状態名
  alias_attribute :color, :色
  alias_attribute :text_color, :文字色

  scope :active, ->(kubunlist) { where(勤怠使用区分: '1', 状態区分:kubunlist) }

# scope :active, ->(wday,holiday) {
#     case wday
#       when '5','6'
#         where(勤怠使用区分: '1', 状態区分:[1,5])
#       when '0'..'4'
#         if holiday == '1'
#           where(勤怠使用区分: '1', 状態区分:[1,5])
#         else
#           where(勤怠使用区分: '1', 状態区分:[1,2,6])
#         end
#     end
#   }

  def events
    super || build_events
  end

  # a class method import, with file passed through as an argument
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      Joutaimaster.create! row.to_hash
    end
  end

  def self.to_csv
    attributes = %w{状態コード 状態名 状態区分 勤怠状態名 マーク 色 文字色 WEB使用区分 勤怠使用区分}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |joutaimaster|
        csv << attributes.map{ |attr| joutaimaster.send(attr) }
      end
    end
  end
end
