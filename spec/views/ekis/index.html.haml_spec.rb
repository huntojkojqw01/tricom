require 'rails_helper'
include SessionsHelper
RSpec.describe "ekis/index", type: :view do
  fixtures :ekis
  before(:each) do
    @eki=Eki.new    
    assign(:ekis, Eki.all)    
  end  
  it "renders a list of ekis" do
    render
    assert_select "tr", count: 6   
    assert_select "tr>td", :text => ekis(:one).駅コード, :count => 1
    assert_select "tr>td", :text => "ｹﾝﾁｮｳﾏｴ", :count => 2

    assert_select "button#new_eki", :text => "新規", :count=> 1
    assert_select "button#edit_eki", :text => "編集", :count=> 1
    assert_select "button#destroy_eki", :text => "削除", :count=> 1
    
    assert_select "#eki_new_modal", :count=> 0
    assert_select "#edit_new_modal", :count=> 0
  end
end
