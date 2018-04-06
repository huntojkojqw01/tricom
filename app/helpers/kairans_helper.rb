module KairansHelper
  def updateKairanDetail(kairan_id, shain)
    Kairanshosai.where(回覧コード: kairan_id).destroy_all
    arrShain = shain.split(',') if shain
    return if arrShain.nil?
    arrShain.each do |shainNo|
      Kairanshosai.create(回覧コード: kairan_id, 対象者: shainNo, 状態: 0)
      notify_to(nil, shainNo)
      counter = Kairanshosai.where(対象者: shainNo, 状態: 0).count
      Shainmaster.find(shainNo).update(回覧件数: counter)
    end
  end

  def update_kairanshosai_counter(shain)
    counter = Kairanshosai.where(対象者: shain, 状態: 0).count
    Shainmaster.find(shain).update(回覧件数: counter)
  end
  # delete all old kairan before 1 month
  def old_kairan_process
    kairans = Kairan.where('created_at < :end_date', end_date: 30.days.ago)
    kairans.each do |kairan|
      Kairanshosai.where(回覧コード: kairan.id).destroy_all
    end
    kairans.destroy_all
  end
end
