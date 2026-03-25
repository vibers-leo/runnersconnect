class CommunitiesController < ApplicationController
  def index
    @crews = Crew.visible.includes(:leader, :crew_contact_points)

    # 검색
    @crews = @crews.search_by_name(params[:q]) if params[:q].present?

    # 지역 필터
    @crews = @crews.by_region(params[:region]) if params[:region].present?

    # 정렬
    @crews = case params[:sort]
    when "popular"
      @crews.popular
    when "featured"
      @crews.featured.order(published_at: :desc)
    else
      @crews.recent
    end

    @featured_crews = Crew.featured.includes(:leader).limit(3) if params[:sort] != "featured"
    @regions = %w[서울 부산 대구 인천 광주 대전 울산 세종 경기 강원 충북 충남 전북 전남 경북 경남 제주]
  end

  def show
    @crew = Crew.visible.includes(:crew_contact_points, :leader).find_by!(slug: params[:id])
    @crew.increment_views!
    @members = @crew.members.distinct
    @recent_activities = Registration.where(crew: @crew).includes(:user, race_edition: :race).order(created_at: :desc).limit(10)
    @top_members = @members.order(total_distance: :desc).limit(3)
  end
end
