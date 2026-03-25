class Organizer::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_organizer_role
  layout 'organizer'

  private

  def require_organizer_role
    unless current_user.organizer? || current_user.admin?
      redirect_to root_path, alert: '주최자 권한이 필요합니다.'
    end
  end

  def current_organizer_profile
    @current_organizer_profile ||= current_user.organizer_profile
  end
  helper_method :current_organizer_profile
end
