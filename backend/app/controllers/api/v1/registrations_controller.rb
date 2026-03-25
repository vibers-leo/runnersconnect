class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save
    render_resource(resource)
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :phone_number, :birth_date, :gender, :address_zipcode, :address_basic, :address_detail, :preferred_size)
  end

  def render_resource(resource)
    if resource.persisted?
      render json: {
        status: {code: 200, message: 'Signed up successfully.'},
        data: ::UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: {message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end
