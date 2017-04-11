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
    @users = User.all

    @messages = Message.all.where(conversation_id: (Conversation.involving(current_user).map(&:id)),read_at: nil)
    .joins(:user).where("担当者マスタ.担当者コード!= ?",current_user.id).order(created_at: :desc)
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
    @event = Event.all.where(id: (PgSearch::Document.where('content LIKE ?','%'+@search+'%').where(searchable_type: "Event")).map(&:searchable_id)).where("Date(開始) >= ?",(Date.today - 1.month).to_s(:db))
    @kintai = Kintai.all.where(id: (PgSearch::Document.where('content LIKE ?','%'+@search+'%').where(searchable_type: "Kintai")).map(&:searchable_id)).where(社員番号: session[:user])
    if @event.first.nil?
      @paths = @paths.where.not(title_jp: (t 'title.event')).where.not(model_name_field: ['Event'])
    end
    if @kintai.first.nil?
      @paths = @paths.where.not(model_name_field: ['Kintai'])
    end
    respond_to do |format|
      format.html
      if(I18n.locale.to_s == 'ja')
        format.json { render json: @masters.map(&:title_jp)+@paths.map(&:title_jp)}
      else
        format.json { render json: @masters.map(&:title_en)+@paths.map(&:title_en)}
      end
    end
  end
  def ajax
    case params[:id]
      when 'check_title'
        title = params[:title]
        @masters = Path.where(title_jp: title)
                        .or(Path.where(title_en: title))
        @masters.update_all(updated_at: Time.now)
        @all_paths = Path.all.order(updated_at: :desc).limit(5)
        if(I18n.locale.to_s == 'ja')
          data = {include: "true", source: @all_paths.map(&:title_jp)}
        else
          data = {include: "true", source: @all_paths.map(&:title_en)}
        end
        respond_to do |format|
          format.json { render json: data}
        end
    end
  end
end
