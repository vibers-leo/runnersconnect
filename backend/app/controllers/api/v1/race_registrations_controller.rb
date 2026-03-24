module Api
  module V1
    class RaceRegistrationsController < Api::BaseController
      before_action :authenticate_user!

      # POST /api/v1/registrations
      def create
        edition = RaceEdition.find(params[:race_edition_id])

        # 1. Check Capacity
        if edition.full?
          return render json: { error: 'This race edition is full.' }, status: :unprocessable_entity
        end

        # 2. Check Duplicate
        if Registration.exists?(user: current_user, race_edition: edition)
          return render json: { error: 'You have already registered for this race.' }, status: :conflict
        end

        # 3. Create Registration
        registration = Registration.new(registration_params.except(:crew_code))
        registration.user = current_user
        registration.race_edition = edition
        
        # Crew logic
        if params[:crew_code].present?
          crew = Crew.find_by(code: params[:crew_code].to_s.upcase)
          if crew
            registration.crew = crew
          else
            return render json: { error: 'Invalid crew code.' }, status: :unprocessable_entity
          end
        end

        registration.status = 'pending'
        registration.merchant_uid = "#{Time.now.to_i}_#{SecureRandom.hex(4)}"
        registration.payment_amount = edition.price
        
        # Save Snapshot of Address
        registration.shipping_address_snapshot = {
          zipcode: current_user.address_zipcode,
          basic: current_user.address_basic,
          detail: current_user.address_detail
        }

        if registration.save
          render json: {
            message: 'Registration created successfully.',
            data: RegistrationSerializer.new(registration).serializable_hash
          }, status: :created
        else
          render json: { error: registration.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/registrations
      # List my registrations
      def index
        registrations = current_user.registrations.includes(race_edition: :race).order(created_at: :desc)

        render json: RegistrationSerializer.new(registrations, include: [:race_edition]).serializable_hash
      end

      private

      def registration_params
        params.permit(:race_edition_id, :tshirt_size, :emergency_contact, :crew_code)
      end
    end
  end
end
