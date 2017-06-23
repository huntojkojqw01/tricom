require 'rails_helper'

RSpec.describe "ekis/show", type: :view do
  before(:each) do
    @eki = assign(:eki, Eki.create!(
      駅コード: "12345", 駅名: "県庁前", 駅名カナ: "ｹﾝﾁｮｳﾏｴ"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to have_content("12345")
    expect(rendered).to have_content("県庁前")
  end
end
