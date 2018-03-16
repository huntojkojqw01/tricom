class DengonsController < ApplicationController
  before_action :require_user!
  before_action :set_dengon, only: [:show, :edit, :update, :destroy]

  respond_to :html
  include DengonsHelper

  def index
    vars = request.query_parameters
    @dengons = Dengon.all
    if params[:head].present?
      @shain_param = params[:head][:shainbango]
    else
      @shain_param = session[:user]
    end
    @yoken = params[:head][:youken] if params[:head].present?
    @kaitou = params[:head][:kaitou] if params[:head].present?
    @nyuuryokusha = params[:head][:nyuuryokusha] if params[:head].present?

    @dengons = @dengons.where('社員番号 = ?', @shain_param) if @shain_param.present? && vars['search'].nil?
    if !vars['search'].nil?
      @shain_param = ''
    end
    @dengons = @dengons.where(用件: @yoken) if @yoken.present?
    @dengons = @dengons.where(回答: @kaitou) if @kaitou.present?
    @dengons = @dengons.where(入力者: @nyuuryokusha) if @nyuuryokusha.present?
    respond_with(@dengons)
  end

  def show
    respond_with(@dengon)
  end

  def new
    @dengon = Dengon.new
    @dengon.input_user = Shainmaster.find session[:user]
    respond_with(@dengon)
  end

  def edit
  end

  def create
    @dengon = Dengon.new(dengon_params)
    nyuuryokusha = Shainmaster.find_by(社員番号: dengon_params[:入力者])
    shain = User.find_by(担当者コード: dengon_params[:社員番号])
    if @dengon.save
      mail_to = Tsushinseigyou.find_by(社員番号: shain.担当者コード)
      mail_body = ''
      unless @dengon.try(:日付).nil?
        mail_body = "#{@dengon.try(:日付).strftime('%F %H:%M')} \r\n"
      end
      mail_body << "\r\n"
      mail_body << "#{@dengon.try(:from1)} #{@dengon.try(:from2)} \r\n"
      mail_body << "\r\n"
      mail_body << "#{@dengon.dengonyouken.try(:種類名)} #{@dengon.dengonkaitou.try(:種類名)} \r\n"
      mail_body << "\r\n"
      mail_body << "#{@dengon.try(:伝言内容)} \r\n"
      mail_body << "\r\n"
      mail_body << "\r\n"
      mail_body << "[#{nyuuryokusha.try(:氏名)}]"
      mail_body.gsub('\r\n','<br />')
      Mail.deliver do
        to mail_to.メール.to_s
        from 'skyfordtricom@gmail.com'
        subject 'From Web_TRICOM'
        body mail_body.to_s
      end
    end
    # respond_with(@dengon)
    update_dengon_counter dengon_params
    # mail_to = Tsushinseigyou.find_by!(社員番号: dengon_params[:社員番号]).メール;
    # send_mail(mail_to, dengon_params[:回答], dengon_params[:伝言内容])

  rescue ActiveRecord::RecordNotFound
    flash[:notice] = t 'app.flash.mail_to'
  rescue Net::SMTPFatalError
    flash[:notice] = t 'app.flash.mail_send_field'
  ensure
    redirect_to dengons_url
  end

  def update
    @dengon.update(dengon_params)
    # respond_with(@dengon)
    update_dengon_counter dengon_params
    # mail_to = Tsushinseigyou.find_by!(社員番号: dengon_params[:社員番号]).メール;
    # send_mail(mail_to, dengon_params[:回答], dengon_params[:伝言内容])

  rescue ActiveRecord::RecordNotFound
    flash[:notice] = t 'app.flash.mail_to'
  rescue Net::SMTPFatalError
    flash[:notice] = t 'app.flash.mail_send_field'
  ensure
    redirect_to dengons_url
  end

  def destroy
    shainbango = Dengon.find(params[:id]).社員番号
    @dengon.destroy()
    update_dengon_counter_with_id shainbango
    respond_with(@dengon)
  end

  def export_csv
    @dengons = Dengon.all

    respond_to do |format|
      format.html
      format.csv { send_data @dengons.to_csv, filename: '伝言.csv' }
    end
  end

  private
    def set_dengon
      @dengon = Dengon.find(params[:id])
    end

    def dengon_params
      params.require(:dengon).permit(:from1, :from2, :日付, :入力者, :社員番号, :用件, :回答, :伝言内容, :確認, :送信)
    end
end
