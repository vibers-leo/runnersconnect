class Api::V1::CommunitiesController < Api::BaseController
  def index
    crews = Crew.visible.includes(:leader, :crew_contact_points)
    crews = crews.search_by_name(params[:q]) if params[:q].present?
    crews = crews.by_region(params[:region]) if params[:region].present?

    crews = case params[:sort]
    when "popular" then crews.popular
    when "featured" then crews.featured.order(published_at: :desc)
    else crews.recent
    end

    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 12).to_i
    offset = (page - 1) * per_page

    total = crews.count
    crews = crews.offset(offset).limit(per_page)

    render json: {
      communities: crews.map { |c| serialize_crew(c) },
      meta: { total: total, page: page, per_page: per_page, total_pages: (total.to_f / per_page).ceil }
    }
  end

  def show
    crew = Crew.visible.includes(:crew_contact_points, :leader).find_by!(slug: params[:id])

    render json: {
      community: serialize_crew_detail(crew)
    }
  end

  private

  def serialize_crew(crew)
    {
      id: crew.id,
      name: crew.name,
      slug: crew.slug,
      short_description: crew.short_description,
      region: crew.region,
      member_count_estimate: crew.member_count_estimate,
      featured: crew.featured,
      leader_name: crew.leader.display_name,
      logo_url: crew.logo.attached? ? url_for(crew.logo) : nil,
      cover_image_url: crew.cover_image.attached? ? url_for(crew.cover_image) : nil,
      contact_points: crew.crew_contact_points.map { |cp| serialize_contact_point(cp) }
    }
  end

  def serialize_crew_detail(crew)
    serialize_crew(crew).merge(
      description: crew.description,
      founded_year: crew.founded_year,
      activity_schedule: crew.activity_schedule,
      activity_location: crew.activity_location,
      website_url: crew.website_url,
      views_count: crew.views_count,
      published_at: crew.published_at,
      activity_photos: crew.activity_photos.map { |p| url_for(p) }
    )
  end

  def serialize_contact_point(cp)
    {
      id: cp.id,
      platform: cp.platform,
      platform_display: cp.platform_display_name,
      url: cp.url,
      label: cp.label,
      primary: cp.primary
    }
  end
end
