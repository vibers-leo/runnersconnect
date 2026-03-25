class Organizer::BibNumbersController < Organizer::BaseController
  before_action :set_race
  before_action :authorize_race_access!

  def index
    @editions = @race.race_editions.includes(:registrations)
  end

  def bulk_reassign
    edition = @race.race_editions.find(params[:edition_id])
    Registration.bulk_reassign_bib_numbers(edition.id)

    flash[:success] = "#{edition.name} 등번호를 재할당했습니다."
    redirect_to organizer_race_bib_numbers_path(@race)
  end

  def update
    registration = @race.registrations.find(params[:id])

    if registration.can_change_bib_number?
      if registration.update(bib_number: params[:bib_number])
        render json: { success: true, message: '등번호가 변경되었습니다.' }
      else
        render json: { success: false, error: registration.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: '등번호를 변경할 수 없습니다.' }, status: :forbidden
    end
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
