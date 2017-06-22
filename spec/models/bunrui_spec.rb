require 'rails_helper'

RSpec.describe Bunrui, type: :model do
  before do
    @bunrui = Bunrui.new(分類コード: "01", 分類名: "AA") #tạo biến để kiểm thử
  end

  subject { @bunrui}
  # kiểm tra có nhận được respone cho thuộc tính
  # it "should respond to '分類コード'" do
  #   expect(@bunrui).to respond_to(:分類コード)
  # end
  it { should respond_to(:分類コード)} #thay thế cho đoạn code trên ta có thể sử dụng dòng lệnh sau
  it { should respond_to(:分類名)}
  it { should respond_to(:jobmaster)} # has_one :jobmaster, foreign_key: :分類コード, dependent: :nullify

  it { should be_valid} #kiểm tra xem biến có tồn tại hay không

  describe "when 分類コード is not presend" do # kiểm tra nếu 分類コード rỗng biến có tồn tại hay không, tương đương với dòng presence: true trong model
    before { @bunrui.分類コード = " "}
    it { should_not be_valid}
  end

  describe "when 分類名 is not presend" do # kiểm tra nếu 分類名 rỗng biến có tồn tại hay không, tương đương với dòng presence: true trong model
    before { @bunrui.分類名 = " "}
    it { should_not be_valid}
  end

  describe "when 分類コード is duplication" do # kiểm tra nếu 分類名 rỗng biến có tồn tại hay không, tương đương với dòng validates :分類コード, uniqueness: true trong model
    before do
      bunrui_same_code = @bunrui.dup
      bunrui_same_code.分類コード = @bunrui.分類コード
      bunrui_same_code.save
    end

    it { should_not be_valid}
  end

  describe "to_csv" do
    it "to_csv" do
      @bunrui.save
      expect(Bunrui.to_csv()).to eq "分類コード,分類名\n01,AA\n"
    end
  end

  # describe "rebuild_pg_search_documents" do
  #   it "rebuild_pg_search_documents" do
  #     @bunrui.save
  #     expect(Bunrui.rebuild_pg_search_documents()).to eq nil
  #   end
  # end
end
