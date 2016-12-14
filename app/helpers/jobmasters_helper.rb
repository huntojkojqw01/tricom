module JobmastersHelper
  def check_existing?(hash_param)
    ret1 = Shainmaster.exists?(hash_param[:入力社員番号])
    ret2 = Jobmaster.exists?(hash_param[:関連Job番号])
    ret = ret1 && ret2
  end
end
