require 'rails_helper'

RSpec.feature "Ekimasters", type: :feature, js: true do
  fixtures :users,:shainmasters,:ekis
  before do
    visit login_path
    fill_in "session_担当者コード", with: users(:one).担当者コード
    fill_in "session_password", with: users(:one).担当者コード
    click_button "ログイン"
    expect(page).to have_link(I18n.t 'title.kinmukanrishisutemu')
    click_link I18n.t 'title.kinmukanrishisutemu'
    expect(page).to have_link(I18n.t 'title.ekimaster')
    click_link I18n.t 'title.ekimaster'
    expect(page).to have_title(I18n.t 'title.eki')

  end   
  
  scenario "Create new eki" do
    expect(page).to have_button("新規")
    click_button "新規"
    expect(page).to have_content(I18n.t 'title.new')
    find("#eki-new-modal #eki_駅コード").set("123")
    find("#eki-new-modal #eki_駅名").set("hung")
    find("#eki-new-modal #eki_駅名カナ").set("fun")
    find("#eki-new-modal .btn").click
    expect(page).to have_content("123")
    expect(page).to have_content("hung")
    expect(page).to have_content("fun")
    expect(page).not_to have_content("1234")
  end
  scenario "Create new eki with not have 駅コード" do
    expect(page).to have_button("新規")
    click_button "新規"
    expect(page).to have_content(I18n.t 'title.new')
    find("#eki-new-modal #eki_駅コード").set(nil)
    find("#eki-new-modal #eki_駅名").set("hung")
    find("#eki-new-modal #eki_駅名カナ").set("fun")
    find("#eki-new-modal .btn").click
    expect(page).to have_content("駅コード を入力してください。")
  end
  scenario "Create new eki with not have 駅名" do
    expect(page).to have_button("新規")
    click_button "新規"
    expect(page).to have_content(I18n.t 'title.new')
    find("#eki-new-modal #eki_駅コード").set("123")
    find("#eki-new-modal #eki_駅名").set(nil)
    find("#eki-new-modal #eki_駅名カナ").set("fun")
    find("#eki-new-modal .btn").click
    expect(page).to have_content("駅名 を入力してください。")
  end
  scenario "Create new eki with duplicate 駅コード" do
    expect(page).to have_button("新規")
    click_button "新規"
    expect(page).to have_content(I18n.t 'title.new')
    find("#eki-new-modal #eki_駅コード").set(ekis(:one).駅コード)
    find("#eki-new-modal #eki_駅名").set("hung")
    find("#eki-new-modal #eki_駅名カナ").set("fun")
    find("#eki-new-modal .btn").click
    expect(page).to have_content("駅コード はすでに存在します。")
  end
  scenario "Edit eki" do
    expect(page).not_to have_button("編集")
    expect(page).to have_content(ekis(:one).駅コード)
    find(".ekitable tr",text: ekis(:one).駅コード).click
    expect(page).to have_button("編集")
    expect(page).to have_selector("#eki-edit-modal",visible: false)
    click_button "編集"
    expect(page).to have_selector("#eki-edit-modal",visible: true)
    modal=find("#eki-edit-modal")
    modal.find("#eki_駅名").set("hung")
    modal.find("#eki_駅名カナ").set("fun")
    modal.find(".btn").click
    expect(page).to have_content("hung")
    expect(page).not_to have_content(ekis(:one).駅名)
  end 
  scenario "Delete eki" do
    expect(page).not_to have_button("削除")
    expect(page).to have_content(ekis(:one).駅コード)
    find(".ekitable tr",text: ekis(:one).駅コード).click    
    expect(page).to have_button("削除")
    click_button "削除"
    

    # find(".btn",text: "OK")    
    # expect(page).to have_content("OK")
    # expect(page).to have_selector(".show-swal2",count: 1)
    # find(".swal2-modal .swal2-confirm").click
    # expect(page).not_to have_content(ekis(:one).駅コード)
  end
end
