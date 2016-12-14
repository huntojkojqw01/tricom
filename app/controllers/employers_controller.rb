class EmployersController < ApplicationController
  before_action :require_user!
  skip_before_action :verify_authenticity_token
  before_action :set_employer, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    # get all record
    @employers = Employer.all
    @employer = Employer.new

  end

  def edit
  end

  def show
  end

  def create
    if params[:add]
      if  !params[:clicked_index].empty?
        # Update
        id = params[:employer][:id]
        @employer = Employer.find(id)
        respond_to do |format|
          if @employer.update(employer_params)
            format.js {render 'update'}
          else
            # format.js {render 'empty'}
            format.js { render json: @employer.errors, status: :unprocessable_entity }
          end
        end

      else
        # New
        @employer = Employer.new(employer_params)

        respond_to do |format|
            if @employer.save
              format.html { redirect_to @employer, notice: '新規成功出来ました。' }
              format.json { render action: 'show', status: :created, location: @employer }
              # format.js { render 'index', status: :created, location: @employer }
              format.js {}
            else
              format.html { render action: 'new' }
              format.json { render json: @employer.errors, status: :unprocessable_entity }
              format.js { render json: @employer.errors, status: :unprocessable_entity }
              # format.js { render 'show' }
            end
        end
      end
    # delete
    elsif !params[:delete].nil?
      		params[:delete].each do |id,value|
      			Employer.find(id.to_i).destroy
      		end
      		respond_to do |format|
      			format.html{}
      			format.json{}
      			format.js{render 'destroy'}
      		end
    else
      respond_to do |format|
        format.js {render 'empty'}
      end
    end
  end

  def update
    respond_to do |format|
      if @employer.update(employer_params)
        format.html { redirect_to @employer, notice: '更新成功できました。' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_employer
    @employer = Employer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employer_params
    params.require(:employer).permit(:first_name, :position, :office, :age, :start_date, :salary, :id)
  end

end
