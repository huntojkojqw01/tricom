require 'rails_helper'

RSpec.describe Bashomaster, type: :model do
  subject {
    described_class.new(場所コード: 1122334455,場所名: "test 場所名",場所名カナ: "test 場所名カナ",SUB: "test",場所区分: '1',会社コード: "90000")
  }
  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
    it "is not valid without a 場所コード" do
      subject.場所コード = nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a 場所名" do
      subject.場所名 = nil
      expect(subject).to_not be_valid
    end
    it "is valid without a 場所名カナ" do
      subject.場所名カナ = nil
      expect(subject).to be_valid
    end
    it "is valid without a SUB" do
      subject.SUB = nil
      expect(subject).to be_valid
    end
    it "is valid without a 場所区分" do
      subject.場所区分 = nil
      expect(subject).to be_valid
    end
    it "is valid with 場所区分!= 2 and without a 会社コード " do
      subject.会社コード = nil
      expect(subject).to be_valid
    end
    it "is not valid with 場所区分== 2 and without a 会社コード " do
      subject.場所区分 = '2'
      subject.会社コード = nil
      expect(subject).to_not be_valid
    end
    it "is not valid with 会社コード not inclusion in Kaishamaster " do
      subject.会社コード = "test"
      expect(subject).to_not be_valid
    end
  end
  describe "Associations" do
    it "has many events" do
      assc = described_class.reflect_on_association(:events)
      expect(assc.macro).to eq(:has_many)
    end

    it "has many mybashomaster" do
      should have_many(:mybashomaster)
    end

    it {should belong_to(:kaishamaster)}
    it {should belong_to(:bashokubunmst)}
  end
  describe "#basho_kubun?" do
    it "check 場所区分 is 2" do
      basho = described_class.new(場所コード: 1122334455,場所名: "test 場所名",場所名カナ: "test 場所名カナ",SUB: "test",場所区分: '2',会社コード: "90000")
      expect(subject.basho_kubun?).to eq(false)
      expect(basho.basho_kubun?).to eq(true)

    end
  end

  describe "After Update" do
    it "update Mybashomaster corresponding" do
      basho = described_class.create(場所コード: 1122334455,場所名: "test 場所名",場所名カナ: "test 場所名カナ",SUB: "test",場所区分: '2',会社コード: "90000")
      mybasho = Mybashomaster.create(社員番号: 10029, 場所コード: basho.場所コード,
        場所名: basho.場所名, 場所名カナ: basho.場所名カナ, SUB: basho.SUB,
        場所区分: basho.場所区分, 会社コード: basho.会社コード)
      basho.update(場所名カナ: "MTA")
      mybasho = Mybashomaster.find_by(社員番号: 10029, 場所コード: basho.場所コード)
      expect(mybasho.場所名カナ).to eq("MTA")

    end
  end

end
