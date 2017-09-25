class HelpsController < ApplicationController
  before_action :require_user!

  def index
    if params[:help]&&current_user.admin?	  	
      file_data = params[:help][:file]
      if file_data.respond_to?(:read)
        content = file_data.read
      elsif file_data.respond_to?(:path)
        content = File.read(file_data.path)
      else
        logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
      end
      File.open("app/assets/images/Tricom.pdf","wb"){|f| f.write(content)} if content
    end
  end
  def edit_help

  end
end
