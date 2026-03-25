class Organizer::SouvenirsController < Organizer::BaseController
  before_action :set_race
  before_action :authorize_race_access!

  def index
    @registrations = @race.registrations.where(status: 'paid').order(:bib_number)

    # 필터
    case params[:filter]
    when 'souvenir_received'
      @registrations = @registrations.souvenir_received
    when 'souvenir_pending'
      @registrations = @registrations.souvenir_pending
    when 'medal_received'
      @registrations = @registrations.medal_received
    when 'medal_pending'
      @registrations = @registrations.medal_pending
    end

    @registrations = @registrations.page(params[:page]).per(50)

    # 통계
    @total_count = @race.registrations.where(status: 'paid').count
    @souvenir_received_count = @race.registrations.where(status: 'paid').souvenir_received.count
    @medal_received_count = @race.registrations.where(status: 'paid').medal_received.count
  end

  def mark_received
    registration = @race.registrations.find(params[:id])
    type = params[:type]  # 'souvenir' or 'medal'
    staff_name = params[:staff_name] || current_user.name

    if type == 'souvenir'
      registration.mark_souvenir_received!(staff_name)
      message = '기념품 수령이 체크되었습니다.'
    elsif type == 'medal'
      registration.mark_medal_received!(staff_name)
      message = '메달 수령이 체크되었습니다.'
    else
      render json: { success: false, error: '잘못된 타입입니다.' }, status: :unprocessable_entity
      return
    end

    render json: { success: true, message: message }
  end

  private

  def set_race
    @race = current_organizer_profile.races.find(params[:race_id])
  end

  def authorize_race_access!
    return if current_user.admin?
    return if @race.organizer.user_id == current_user.id

    redirect_to organizer_root_path, alert: '접근 권한이 없습니다.'
  end
end
