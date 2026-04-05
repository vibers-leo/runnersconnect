class Api::VibersAdminController < ApplicationController
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :verify_authenticity_token, raise: false

  before_action :verify_admin_secret

  def index
    stats = {
      totalUsers: User.count,
      contentCount: Race.count,
      mau: 0,
      recentSignups: User.where("created_at > ?", 7.days.ago).count,
      totalOrders: Order.count
    }

    recent_activity = User.order(created_at: :desc).limit(5).map do |u|
      { id: u.id.to_s, type: "signup", label: u.email, timestamp: u.created_at }
    end

    render json: {
      projectId: "runnersconnect",
      projectName: "러너스커넥트",
      stats: stats,
      recentActivity: recent_activity,
      health: "healthy"
    }
  end

  def resource
    case params[:resource]
    when "races"
      data = Race.order(created_at: :desc).limit(50).map do |r|
        { id: r.id.to_s, name: r.name, status: r.status, registrationCount: r.registrations.count, createdAt: r.created_at }
      end
      render json: data
    when "crews"
      data = Crew.order(created_at: :desc).limit(50).map do |c|
        { id: c.id.to_s, name: c.name, memberCount: c.members.count, createdAt: c.created_at }
      end
      render json: data
    when "orders"
      data = Order.order(created_at: :desc).limit(50).map do |o|
        { id: o.id.to_s, status: o.status, total: o.total_price, createdAt: o.created_at }
      end
      render json: data
    else
      render json: [], status: :ok
    end
  end

  private

  def verify_admin_secret
    unless request.headers["X-Vibers-Admin-Secret"] == ENV["VIBERS_ADMIN_SECRET"]
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
