class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: [:kakao]

  def kakao
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = '카카오 계정으로 로그인되었습니다.'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.kakao_data'] = request.env['omniauth.auth'].except('extra')
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path, alert: '소셜 로그인에 실패하였습니다.'
  end
end
