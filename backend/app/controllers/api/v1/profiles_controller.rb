module Api
  module V1
    class ProfilesController < Api::BaseController
      before_action :authenticate_user!

      # GET /api/v1/profile
      def show
        render json: {
          data: ::UserSerializer.new(current_user).serializable_hash[:data][:attributes]
        }
      end

      # PATCH/PUT /api/v1/profile
      def update
        if current_user.update(profile_params)
          render json: {
            message: 'Profile updated successfully.',
            data: ::UserSerializer.new(current_user).serializable_hash[:data][:attributes]
          }
        else
          render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def profile_params
        params.require(:user).permit(
          :name, :phone_number, :birth_date, :gender,
          :address_zipcode, :address_basic, :address_detail,
          :preferred_size, :emergency_contact
        )
      end
    end
  end
end
