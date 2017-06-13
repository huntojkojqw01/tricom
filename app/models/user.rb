class User < ActiveRecord::Base
  self.table_name = :担当者マスタ
  self.primary_key = :担当者コード
  include PgSearch
  multisearchable :against => %w{担当者コード 担当者名称}
  attr_accessor :current_password
  attr_accessor :flag_reset_password
  attr_accessor :remember_token
  # validates :email, confirmation: true
  # validates :email_confirmation, presence: true
  # has_attached_file :avatar, styles: { medium: "300x300>", thumb: "50x50>" }, default_url: "images/:style/missing.png"
  has_attached_file :avatar,  default_url: "/assets/:style/missing.png",
  :storage => :cloudinary, :path => 'tricom/:id/:filename',styles: {original: "50x50#"}
  belongs_to :shainmaster, foreign_key: :担当者コード
  has_many :conversations, :foreign_key => :sender_id
  alias_attribute :id, :担当者コード
  alias_attribute :name, :担当者名称
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates :password, length: {minimum: 4}, allow_blank: true
  # validates :担当者コード, uniqueness: true, presence: true
  validate :check_taken, on: :create
  validates :担当者名称, presence: true
  validates :担当者コード, presence: true
  validates_format_of :email, :with => /(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z)|(^$)/i, message: I18n.t('errors.messages.wrong_mail_form')
  validate :current_password_is_correct, on: :update
  has_secure_password

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def check_taken
    if 担当者コード.present? && 担当者コード.in?(User.pluck(:担当者コード))
      errors.add(:担当者コード, (I18n.t 'errors.messages.taken'))
    elsif 担当者コード.present? && !担当者コード.in?(Shainmaster.pluck(:連携用社員番号))
      errors.add(:担当者コード, (I18n.t 'errors.messages.invalid'))
    elsif !担当者コード.present?
      errors.add(:担当者コード, '')
    end
  end

  def self.to_csv
    attributes = %w{担当者コード 担当者名称 admin email supervisor}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
      # creates a user for each row in the CSV file
      @user_info = row.to_hash
      @user_info["password"] = @user_info["担当者コード"]
      @user_info["password_confirmation"] = @user_info["担当者コード"]
      User.create @user_info
    end
  end
  # Check if the inputted current password is correct when the user tries to update his/her password
  def current_password_is_correct
    # Check if the user tried changing his/her password
    if !password.blank?
      # Get a reference to the user since the "authenticate" method always returns false when calling on itself (for some reason)
      user = User.find_by_id(id)

      # Check if the user CANNOT be authenticated with the entered current password
      if (user.authenticate(current_password) == false) && flag_reset_password != true
        # Add an error stating that the current password is incorrect
        errors.add(:current_password, I18n.t('errors.messages.current_password_incorrect'))
      end
    end
  end
  # Naive approach
  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end
end
