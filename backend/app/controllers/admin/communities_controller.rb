class Admin::CommunitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_crew, only: [:show, :approve, :suspend, :feature]

  def index
    @crews = Crew.includes(:leader, :crew_contact_points).order(created_at: :desc)

    if params[:status].present?
      @crews = @crews.where(status: params[:status])
    end
  end

  def show
    @members = @crew.members.distinct
    @contact_points = @crew.crew_contact_points
  end

  def approve
    @crew.publish!
    redirect_to admin_communities_path, notice: "'#{@crew.name}' 커뮤니티가 승인되었습니다."
  end

  def suspend
    @crew.suspend!
    redirect_to admin_communities_path, notice: "'#{@crew.name}' 커뮤니티가 정지되었습니다."
  end

  def feature
    @crew.update!(featured: !@crew.featured)
    msg = @crew.featured? ? "추천 커뮤니티로 설정되었습니다." : "추천 설정이 해제되었습니다."
    redirect_to admin_communities_path, notice: msg
  end

  private

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: "권한이 없습니다."
    end
  end

  def set_crew
    @crew = Crew.find(params[:id])
  end
end
