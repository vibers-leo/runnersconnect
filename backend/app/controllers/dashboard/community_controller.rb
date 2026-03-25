class Dashboard::CommunityController < ApplicationController
  before_action :authenticate_user!
  before_action :set_crew
  before_action :authorize_leader!

  def show
    @contact_points = @crew.crew_contact_points
    @members_count = @crew.members.distinct.count
  end

  def edit
    @crew.crew_contact_points.build if @crew.crew_contact_points.empty?
  end

  def update
    if @crew.update(crew_params)
      redirect_to dashboard_community_path, notice: "커뮤니티 정보가 업데이트되었습니다."
    else
      flash.now[:error] = @crew.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def submit_for_review
    @crew.update!(status: :pending_review)
    redirect_to dashboard_community_path, notice: "검토 요청이 제출되었습니다. 관리자 승인 후 공개됩니다."
  end

  def remove_photo
    attachment = @crew.activity_photos.find(params[:photo_id])
    attachment.purge
    redirect_to edit_dashboard_community_path, notice: "사진이 삭제되었습니다."
  end

  private

  def set_crew
    @crew = current_user.led_crews.first
    unless @crew
      redirect_to new_crew_path, alert: "먼저 크루를 생성해주세요."
    end
  end

  def authorize_leader!
    unless @crew&.leader_id == current_user.id
      redirect_to root_path, alert: "접근 권한이 없습니다."
    end
  end

  def crew_params
    params.require(:crew).permit(
      :name, :short_description, :description, :region,
      :founded_year, :member_count_estimate, :activity_schedule,
      :activity_location, :website_url, :logo, :cover_image,
      activity_photos: [],
      crew_contact_points_attributes: [:id, :platform, :url, :label, :primary, :_destroy]
    )
  end
end
