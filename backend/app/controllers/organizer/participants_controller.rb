class Organizer::ParticipantsController < Organizer::BaseController
  before_action :set_race
  before_action :authorize_race_access!

  def index
    @registrations = @race.registrations
                          .includes(:user, :race_edition)
                          .where(status: 'paid')

    # 필터링
    @registrations = @registrations.where(race_edition_id: params[:edition_id]) if params[:edition_id].present?
    @registrations = @registrations.joins(:user).where(users: { gender: params[:gender] }) if params[:gender].present?
    @registrations = @registrations.joins(:user).where(users: { age_group: params[:age_group] }) if params[:age_group].present?

    # 검색
    if params[:query].present?
      @registrations = @registrations.joins(:user).where('users.name LIKE ? OR users.email LIKE ?',
                                                          "%#{params[:query]}%",
                                                          "%#{params[:query]}%")
    end

    # CSV 내보내기
    respond_to do |format|
      format.html do
        @registrations = @registrations.order(:bib_number).page(params[:page]).per(50)
      end
      format.csv do
        export_csv
      end
    end
  end

  def show
    @registration = @race.registrations.find(params[:id])
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

  def export_csv
    require 'csv'

    registrations = @race.registrations
                         .includes(:user, :race_edition)
                         .where(status: 'paid')
                         .order(:bib_number)

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['등번호', '참가자명', '성별', '연령대', '종목', '전화번호', '이메일', '주소', '신청일']

      registrations.each do |reg|
        csv << [
          reg.bib_number,
          reg.user.name,
          reg.user.gender == 'male' ? '남성' : reg.user.gender == 'female' ? '여성' : '',
          reg.user.age_group,
          reg.race_edition.name,
          reg.user.phone,
          reg.user.email,
          reg.shipping_address,
          reg.created_at.strftime('%Y-%m-%d %H:%M')
        ]
      end
    end

    send_data csv_data,
              filename: "#{@race.title}_participants_#{Time.current.to_i}.csv",
              type: 'text/csv; charset=utf-8',
              disposition: 'attachment'
  end
end
