module DengonsHelper
  def update_dengon_counter dengon_params
    counter = Dengon.where(社員番号: dengon_params[:社員番号], 確認: false).count
    Shainmaster.find(dengon_params[:社員番号]).update(伝言件数: counter)
  end

  def update_dengon_counter_with_id shainbango
    if !shainbango.nil? && shainbango!=''
      counter = Dengon.where(社員番号: shainbango, 確認: false).count
      Shainmaster.find(shainbango).update(伝言件数: counter)
    end
  end

  def send_mail(to_mail, subject_mail, body_mail)
    Mail.deliver do
      to to_mail
      from 'hminhduc@gmail.com'
      subject subject_mail
      body body_mail
    end
  end
end
