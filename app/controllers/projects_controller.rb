class ProjectsController < ApplicationController

  before_action :find_project, only: [:show, :edit, :update, :destroy]
  before_action :member_must_be_owner, only: [:edit, :update, :destroy]
  before_action :restrict_project_access, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.is_admin?
      @projects = Project.all
    else
      @projects = current_user.projects
    end
    tracker_api = TrackerAPI.new
    if current_user.token
      if tracker_api.projects(current_user.token).class == Array
        @tracker_projects = tracker_api.projects(current_user.token)
      else
        flash[:error] = "Your token is invalid. Please enter a valid tracker token."
        @tracker_projects = {}
      end
    end
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      @project.memberships.create(project_id: @project.id, user_id: current_user.id, role_id: 1)
      redirect_to project_tasks_path(@project), notice: "Project was successfully created"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to project_path(@project), notice: "Project was successfully updated"
    else
      render :edit
    end
  end

  def destroy
    Project.destroy(params[:id])
    redirect_to projects_path, notice: "Project was successfully deleted"
  end


  private

  def project_params
    params.require(:project).permit(:name)
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def member_must_be_owner
    unless current_user.is_owner?(@project) #unless this is true
      flash[:error] = 'You do not have access'
      redirect_to project_path(@project)
    end
  end

  def restrict_project_access
    unless @project.memberships.include?(current_user.memberships.find_by(project_id: @project.id)) || current_user.is_admin?
      flash[:error] = "You do not have access to this project"
      redirect_to projects_path
    end
  end

end
