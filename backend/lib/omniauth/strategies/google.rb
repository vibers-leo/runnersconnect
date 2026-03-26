require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Google < OmniAuth::Strategies::OAuth2
      option :name, "google_oauth2"
      option :client_options, {
        site: "https://accounts.google.com",
        authorize_url: "https://accounts.google.com/o/oauth2/auth",
        token_url: "https://oauth2.googleapis.com/token"
      }
      option :authorize_params, { scope: "email profile" }

      uid { raw_info["sub"] }

      info do
        { name: raw_info["name"], email: raw_info["email"], image: raw_info["picture"] }
      end

      def raw_info
        @raw_info ||= access_token.get("https://www.googleapis.com/oauth2/v3/userinfo").parsed
      end

      def callback_url
        full_host + callback_path
      end
    end
  end
end
