class HomeController < ApplicationController
  def index
    @user_count = User.count
    @race_count = Race.count
    @crew_count = Crew.count
  end
end
