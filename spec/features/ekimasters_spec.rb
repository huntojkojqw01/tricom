require 'rails_helper'
# type: :feature có nghĩa là đây là một file test tổng hợp
# cụ thể là file này viết một vài kịch bản test trên giao diện eki master.
RSpec.feature "Ekimasters", type: :feature, js: true do
  # dòng fixtures ... này sẽ tạo mới dữ liệu trong các bảng được liệt kê sau đó
  # nguồn dữ liệu chính là từ các file yml tương ứng
  fixtures :users,:shainmasters,:ekis
  before do
    # đầu tiên ta phải đăng nhập vào trang web, dưới đây mô phỏng việc đăng nhập:
    visit login_path
    # ở đây users(:user_35) chính là bản ghi user_35 trong file users.yml nhé.
    fill_in "session_担当者コード", with: users(:user_35).担当者コード
    fill_in "session_password", with: users(:user_35).担当者コード
    click_button "ログイン"    
    sleep 10# vì sau khi click nút login thì cần sleep cho trang load xong.
    # đăng nhập xong thì click vào nút trang chủ nào:
    expect(page).to have_link(I18n.t 'title.kinmukanrishisutemu')
    click_link I18n.t 'title.kinmukanrishisutemu'
    sleep 5
    # sau đó, ta lại tiếp tục kiểm tra xem có link ekimaster ko, nếu có thì click vào link:
    expect(page).to have_link(I18n.t 'title.ekimaster')
    click_link I18n.t 'title.ekimaster'
    sleep 5
    # điều ta mong muốn là trang Ekimaster sẽ hiển thị ra, tức là có tiêu đề như thế này:
    expect(page).to have_title(I18n.t 'title.eki')
  end   
  
  scenario "Create new eki" do
    expect(page).to have_button("新規")
    click_button "新規"
    expect(page).to have_content(I18n.t 'title.new')
    # dưới đây là cách nhập liệu vào form:
    find("#eki-new-modal #eki_駅コード").set("123")# tức là nhập 123 vào ô 駅コード.
    find("#eki-new-modal #eki_駅名").set("hung")
    find("#eki-new-modal #eki_駅名カナ").set("fun")
    # sau khi nhập liệu vào 3 ô input trên, ta click vào nút đăng kí như sau:
    find("#eki-new-modal .btn").click
    # sau khi click nút đăng kí, ta trông chờ trang web sẽ có các nội dung mới:
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
    find("#eki-new-modal #eki_駅コード").set(ekis(:eki_0).駅コード)
    find("#eki-new-modal #eki_駅名").set("hung")
    find("#eki-new-modal #eki_駅名カナ").set("fun")
    find("#eki-new-modal .btn").click
    expect(page).to have_content("駅コード はすでに存在します。")
  end
  scenario "Edit eki" do
    expect(page).not_to have_button("編集")
    expect(page).to have_content(ekis(:eki_0).駅コード)
    find(".ekitable tr",text: ekis(:eki_0).駅コード).click
    expect(page).to have_button("編集")
    expect(page).to have_selector("#eki-edit-modal",visible: false)
    click_button "編集"
    expect(page).to have_selector("#eki-edit-modal",visible: true)
    modal=find("#eki-edit-modal")
    modal.find("#eki_駅名").set("hung")
    modal.find("#eki_駅名カナ").set("fun")
    modal.find(".btn").click
    expect(page).to have_content("hung")
    expect(page).not_to have_content(ekis(:eki_0).駅名)
  end 
  scenario "Delete eki" do
    expect(page).not_to have_button("削除")
    expect(page).to have_content(ekis(:eki_0).駅コード)
    find(".ekitable tr",text: ekis(:eki_0).駅コード).click    
    expect(page).to have_button("削除")   
    click_button "削除"
  end
end
