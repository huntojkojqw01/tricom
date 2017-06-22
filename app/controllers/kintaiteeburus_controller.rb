class KintaiteeburusController < ApplicationController	
	def index
		@kintaiteeburus=Kintaiteeburu.all
	end
	def new
		@kintaiteeburu=Kintaiteeburu.new
	end
	def create
		@kintaiteeburu=Kintaiteeburu.new(kintaiteeburu_params)		
		respond_to do |format|
			if @kintaiteeburu.save				
				format.html {redirect_to kintaiteeburus_path, notice: t('app.flash.new_success')}
				format.js				
			else
				format.html {render 'new'}				
			end
		end
	end
	def edit
		@kintaiteeburu=Kintaiteeburu.find_by(id: params[:id])
		redirect_to root_path unless @kintaiteeburu
	end
	def update
		@kintaiteeburu=Kintaiteeburu.find_by(id: params[:id])		
		if @kintaiteeburu
			if @kintaiteeburu.update(kintaiteeburu_params)												
				flash[:notice] = t 'app.flash.update_success'
				redirect_to kintaiteeburus_path
			else
				render 'edit'
			end
		else
		end
	end
	def ajax
		case params[:focus_field]      
	    	when 'kintaiteeburu_削除する'
		        params[:kintaiteeburus].each {|kintaiteeburu_code|
		          kintaiteeburu=Kintaiteeburu.find(kintaiteeburu_code)
		          kintaiteeburu.destroy if kintaiteeburu
		        }
		        data = {destroy_success: 'success'}
		        respond_to do |format|
		          format.json { render json: data}
		        end
	    	else
	    end
	end
	def import
		if params[:file].nil?
	      flash[:alert] = t 'app.flash.file_nil'
	      redirect_to kintaiteeburus_path
	    elsif File.extname(params[:file].original_filename) != '.csv'
	      flash[:danger] = t 'app.flash.file_format_invalid'
	      redirect_to kintaiteeburus_path
	    else
	      begin
	        Kintaiteeburu.transaction do
	          Kintaiteeburu.delete_all	          
	          Kintaiteeburu.import(params[:file])	          
	          redirect_back fallback_location: kintaiteeburus_path,notice: t('app.flash.import_csv')
	        end
	      rescue => err
	        flash[:danger] = err.to_s
	        redirect_to kintaiteeburus_path
	      end
	    end
	end
	private
	def kintaiteeburu_params
      	params.require(:kintaiteeburu).permit(:勤務タイプ,:出勤時刻,:退社時刻,:昼休憩時間,:夜休憩時間,:深夜休憩時間,:早朝休憩時間,:実労働時間,:早朝残業時間,:残業時間,:深夜残業時間)     	
    end    
end
