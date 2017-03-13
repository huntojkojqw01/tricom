class MainController < ApplicationController
  before_action :require_user!

  def index
    @kairanCount = Kairanshosai.where(対象者: session[:user], 状態: 0).count
    shain = Shainmaster.find_by id: session[:user]
    shain.update_attributes 回覧件数: @kairanCount

    @dengonCount = Dengon.where(社員番号: session[:user], 確認: false).count
    shain = Shainmaster.find_by id: session[:user]
    shain.update_attributes 伝言件数: @dengonCount

    @kairans = Kairanshosai.where(対象者: session[:user], 状態: 0)
    @dengons = Dengon.where(社員番号: session[:user], 確認: false)

  end
  def search
    vars = request.query_parameters
    @search = ''
    if vars['search']!= '' && !vars['search'].nil?
      @search = vars['search']
    end
    @searchs = PgSearch::Document.where('content LIKE ?','%'+@search+'%').select(:searchable_type).distinct
    @paths = Path.all.where(model_name_field: (@searchs.map(&:searchable_type))).where.not(title_jp: (t 'title.time_line_view'))
    @masters = Path.where('title_jp LIKE ?','%'+@search+'%')
    .or(Path.where('title_en LIKE ?','%'+@search+'%'))
    .or(Path.where('model_name_field LIKE ?','%'+@search+'%'))
    @masters = @masters.where.not(model_name_field: (@paths.map(&:model_name_field)))
  end
end
