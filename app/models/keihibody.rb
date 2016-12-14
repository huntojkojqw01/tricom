class Keihibody < ActiveRecord::Base
  self.table_name = :keihi_bodies
  # self.primary_keys = [:申請番号,:行番号]
  # self.primary_key = :申請番号

  belongs_to :keihihead, foreign_key: :申請番号
  scope :current_member, ->(member) { where( 社員番号: member )}

  validate :check_all_attribute

  def self.to_csv
    attributes = %w{id 申請番号 日付 社員番号 相手先 機関名 発 着 発着kubun 交通費 日当
      宿泊費 その他 JOB 備考 領収書kubun}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |keihibodies|
        csv << attributes.map{ |attr| keihibodies.send(attr) }
      end
    end
  end


  private
  def check_all_attribute
    if self.attributes['相手先'].empty? && self.attributes['機関名'].empty? && self.attributes['発'].empty? && self.attributes['着'].empty? && self.attributes['交通費'].empty? && self.attributes['日当'].empty? && self.attributes['宿泊費'].empty? && self.attributes['その他'].empty? && self.attributes['JOB'].empty? && self.attributes['備考'].empty?
      errors.add(:相手先, "asasa")
    end
  end
end
