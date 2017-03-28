class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  respond_to :html, :js

  def index
    @tasks = Task.all
  end

  def show
    respond_with(@task)
  end

  def new
    @task = Task.new
  end

  def edit
    respond_with(@task, location: task_url)
  end

  def create
    @task = Task.new(task_params)
       respond_to do |format|
      if  @task.save
        format.js { render 'create_task'}
      else
        format.js { render json: @task.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    @task.update(task_params)
    respond_with(@task, location: tasks_url)
  end

  def destroy
    @task.destroy
    respond_with(@task)
  end

  def sort
    params[:order].each do |key,value|
      Task.find(value[:id]).update_attribute(:priority,value[:position])
    end
    render :nothing => true
  end

  def change_status
    @task = Task.find(params[:id])
    if (params[:decision] == "true")
      @task.update(done: 1)
      respond_with(@task, location: tasks_url)
    elsif (params[:decision] == "false")
      @task.update(done: 0)
      respond_with(@task, location: tasks_url)
    end
  end
  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description,:done)
    end
end
