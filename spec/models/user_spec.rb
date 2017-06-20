require 'rails_helper'

RSpec.describe User, type: :model do 
  fixtures :users
	# thiết lập cho biến user nhận giá trị này: 
  let(:user) { User.new(email: "nguyendinhhung") }

  describe "has wrong_format_email" do

  	it "is not valid_user" do
  		# mong đợi biến user đó là ko hợp lệ
  		expect(user).to be_invalid  		
  	end

  	it "with email_errors" do
  		expect(user).not_to be_valid
  		# mong đợi một trong các nguyên nhân làm user đó không hợp lệ là do email ko đúng định dạng:
  		expect(user.errors[:email].join('')).to eq(I18n.t('errors.messages.wrong_mail_form'))
  	end

    it "with no email_errors" do
      user.email="nguyendinhhung@gmail.com"
      expect(user).not_to be_valid
      # mong đợi là sau khi thay đổi email đúng format, lỗi sẽ ko còn chứa email nữa:
      expect(user.errors[:email].join('')).to eq("")      
    end
    it "dem user" do
      total=User.count
      expect(total).to eq(36)  
      x=users(:user_33)
      expect(x.email).to eq(User.find_by(担当者コード: "10002").email)    
    end
  end
end
