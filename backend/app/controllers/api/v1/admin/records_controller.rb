module Api
  module V1
    module Admin
      class RecordsController < Api::BaseController
        before_action :authenticate_user!
        before_action :ensure_admin!

        # POST /api/v1/admin/records/upload (Sample mock for bulk upload)
        def upload
          # In a real app, we'd process a CSV or JSON payload
          # For now, let's just create a single record for a registration
          registration = Registration.find(params[:registration_id])
          
          record = Record.find_or_initialize_by(
            user: registration.user,
            race_edition: registration.race_edition
          )

          record.assign_attributes(record_params)
          record.registration = registration
          
          if record.save
            render json: { message: 'Record uploaded successfully.', data: record }
          else
            render json: { error: record.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def ensure_admin!
          unless current_user.admin?
            render json: { error: 'Forbidden' }, status: :forbidden
          end
        end

        def record_params
          params.permit(:net_time, :gun_time, :rank_overall, :rank_gender, :rank_age, :is_verified)
        end
      end
    end
  end
end
