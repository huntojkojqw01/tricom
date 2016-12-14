class SetsubiyoyakusController < ApplicationController
  before_action :require_user!
  before_action :set_setsubiyoyaku, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @setsubiyoyaku = Setsubiyoyaku.all
    if params[:head].present?
      @setsubi_param = params[:head][:setsubicode]
    end
    @setsubiyoyaku = Setsubiyoyaku.where(設備コード: @setsubi_param) if @setsubi_param.present?
    respond_with(@setsubiyoyaku)
  end

  def show
    respond_with(@setsubiyoyaku)
  end

  def new
    @kaishamasters = Kaishamaster.all
    @setsubiyoyaku = Setsubiyoyaku.new
    respond_with(@setsubiyoyaku)
  end

  def edit
    @kaishamasters = Kaishamaster.all
  end

  def create
    @kaishamasters = Kaishamaster.all
    @setsubiyoyaku = Setsubiyoyaku.new setsubiyoyaku_params
    @setsubiyoyaku.save
    respond_with @setsubiyoyaku, location: setsubiyoyakus_url
  end

  def update
    # setsubiyoyaku_params['設備コーchanged']=false
    # setsubiyoyaku_params.add('設備コーchanged'=>'false')
    # byebug
    # if @setsubiyoyaku.設備コード == setsubiyoyaku_params.設備コード
        # setsubiyoyaku_params.add('設備コーchanged'=>'true')
        # setsubiyoyaku_params['設備コーchanged']=true
    # end
    if @setsubiyoyaku.update_attributes(setsubiyoyaku_params)
      flash[:notice] = t "app.flash.update_success"
      redirect_to setsubiyoyakus_url
    else
      @kaishamasters = Kaishamaster.all
      render :edit
      # respond_with(@setsubiyoyaku)
    end
  end

  def destroy
    @setsubiyoyaku.destroy
    respond_with(@setsubiyoyaku)
    end

  def ajax
    case params[:focus_field]
      when "setsubiyoyaku_相手先"
        kaisha_name = Kaishamaster.find_by(code: params[:kaisha_code]).try :name
        data = {kaisha_name: kaisha_name}
        respond_to do |format|
          format.json { render json: data}
        end
    end
  end

  private
  def set_setsubiyoyaku
    @setsubiyoyaku = Setsubiyoyaku.find(params[:id])
  end

  def setsubiyoyaku_params
    params.require(:setsubiyoyaku).permit(:設備コード, :予約者, :相手先, :開始, :終了, :用件)
  end
end
