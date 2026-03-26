class NativeController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /native/config
  def config
    render json: {
      app_name: "RunnersConnect",
      version: "1.0.0",
      tabs: [
        { title: "홈", path: "/", icon: "house" },
        { title: "대회", path: "/races", icon: "flag" },
        { title: "크루", path: "/communities", icon: "person.3" },
        { title: "내 정보", path: "/profile", icon: "person" }
      ],
      auth: {
        login_path: "/users/sign_in",
        signup_path: "/users/sign_up",
        logout_path: "/users/sign_out"
      },
      settings: {
        pull_to_refresh: true,
        show_toolbar: false,
        safe_area: true
      }
    }
  end
end
