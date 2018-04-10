namespace :data do
  desc "Clear data 1.years.ago"
  task remove: :environment do
    shainids = Setting.where(turning_data: true).pluck(:社員番号)
    Event.where(社員番号: shainids).where('Date(開始) < ?',Date.today.prev_month(12).beginning_of_month).destroy_all
    Kintai.where(社員番号: shainids).where('Date(日付) < ?',Date.today.prev_month(12).beginning_of_month).destroy_all
    Keihihead.where(社員番号: shainids).where('Date(清算予定日) < ?',Date.today.prev_month(12).beginning_of_month).destroy_all
    Kairan.where(発行者: shainids).where('Date(開始) < ?',Date.today.prev_month(12).beginning_of_month).destroy_all
    Dengon.where('社員番号 in (?) or 入力者 in (?)', shainids, shainids).where('Date(日付) < ?',Date.today.prev_month(12).beginning_of_month).destroy_all
  end
end