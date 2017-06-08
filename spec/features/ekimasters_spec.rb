require 'rails_helper'

RSpec.feature "Ekimasters", type: :feature do
  fixtures :users,:shains
  before do
  	visit login_path
    fill_in "session_担当者コード", with: users(:one).担当者コード
    fill_in "session_password", with: users(:one).担当者コード
    click_button "ログイン"
    expect(page).to have_text("駅マスタ") 
  end   
  
  scenario "User click new_eki_button" do
    # visit ekis_path
    # #fill_in "Name", :with => "My Widget"
    # expect(page).to have_text("駅マスタ")    
    #assert_selector "button#new_eki", :text => "新規", :count=> 1
    # click_button "新規"
    # expect(page).to have_text("駅名")
  end  
end
