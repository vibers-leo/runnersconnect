module Api
  module V1
    class StatusController < Api::BaseController
      def index
        render json: { 
          status: "online", 
          message: "Ruby on Rails 백엔드가 정상적으로 작동 중입니다!",
          time: Time.current 
        }
      end
    end
  end
end
