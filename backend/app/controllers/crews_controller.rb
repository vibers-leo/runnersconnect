class CrewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  # GET /crews/new
  def new
    @crew = Crew.new
  end

  # POST /crews
  def create
    @crew = current_user.led_crews.build(crew_params)
    if @crew.save
      redirect_to crews_path, notice: "크루가 성공적으로 생성되었습니다. 코드: #{@crew.code}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /crews
  def index
    @crews = Crew.includes(:leader).all
    if user_signed_in?
      @led_crews = current_user.led_crews
      @joined_crews = Crew.joins(:registrations).where(registrations: { user_id: current_user.id }).distinct
    end
  end

  # GET /crews/:id
  def show
    @crew = Crew.find(params[:id])
    # Members distinct user_id
    @members = @crew.members.distinct
    # Recent Activities: Registrations made under this crew code
    @recent_activities = Registration.where(crew: @crew).includes(:user, :race).order(created_at: :desc).limit(10)
    @top_members = @members.order(total_distance: :desc).limit(3)
  end

  private

  def crew_params
    params.require(:crew).permit(:name, :description)
  end
end
