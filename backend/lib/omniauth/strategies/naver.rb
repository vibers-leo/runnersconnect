require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Naver < OmniAuth::Strategies::OAuth2
      option :name, "naver"
      option :client_options, {
        site: "https://nid.naver.com",
        authorize_url: "https://nid.naver.com/oauth2.0/authorize",
        token_url: "https://nid.naver.com/oauth2.0/token"
      }

      uid { raw_info.dig("response", "id") }

      info do
        response = raw_info["response"] || {}
        {
          name: response["name"] || response["nickname"],
          email: response["email"],
          image: response["profile_image"],
          nickname: response["nickname"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get("https://openapi.naver.com/v1/nid/me").parsed
      end

      def callback_url
        full_host + callback_path
      end
    end
  end
end
