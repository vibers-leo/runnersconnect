class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  # GET /registrations
  def index
    @registrations = current_user.registrations.includes(:race, :race_edition)
  end

  # GET /registrations/new?race_edition_id=1
  def new
    @edition = RaceEdition.find(params[:race_edition_id])
    @registration = current_user.registrations.build(race_edition: @edition)
  end

  # POST /registrations
  def create
    @edition = RaceEdition.find(params[:registration][:race_edition_id])
    @registration = current_user.registrations.build(registration_params)
    @registration.race_edition = @edition
    @registration.status = 'paid' # Mocking pay
    @registration.merchant_uid = "WEB_#{Time.now.to_i}_#{SecureRandom.hex(4)}"
    @registration.payment_method = 'web_mock'
    @registration.payment_amount = @edition.price
    @registration.paid_at = Time.current
    
    # Snapshot shipping address
    @registration.shipping_address_snapshot = {
      zipcode: @registration.shipping_zipcode,
      address: @registration.shipping_address,
      detail: @registration.shipping_address_detail,
      phone: @registration.shipping_phone,
      memo: @registration.shipping_memo
    }

    if params[:crew_code].present?
      crew = Crew.find_by(code: params[:crew_code].upcase)
      @registration.crew = crew if crew
    end

    if @registration.save
      redirect_to registration_path(@registration), notice: '신청이 완료되었습니다!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /registrations/:id
  def show
    @registration = current_user.registrations.find(params[:id])
  end

  private

  def registration_params
    params.require(:registration).permit(
      :race_edition_id, 
      :tshirt_size, 
      :emergency_contact,
      :shipping_zipcode,
      :shipping_address,
      :shipping_address_detail,
      :shipping_phone,
      :shipping_memo
    )
  end
end
