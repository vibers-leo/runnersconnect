class Admin::CrawlSourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_source, only: [:edit, :update, :destroy, :trigger_crawl]

  def index
    @crawl_sources = CrawlSource.order(created_at: :desc)
  end

  def new
    @crawl_source = CrawlSource.new
  end

  def create
    @crawl_source = CrawlSource.new(source_params)
    if @crawl_source.save
      redirect_to admin_crawl_sources_path, notice: "크롤링 소스가 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @source.update(source_params)
      redirect_to admin_crawl_sources_path, notice: "크롤링 소스가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @source.destroy
    redirect_to admin_crawl_sources_path, notice: "크롤링 소스가 삭제되었습니다."
  end

  def trigger_crawl
    CrawlSourceJob.perform_later(@source.id)
    redirect_to admin_crawl_sources_path, notice: "'#{@source.name}' 크롤링이 시작되었습니다."
  end

  private

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: "권한이 없습니다."
    end
  end

  def set_source
    @source = CrawlSource.find(params[:id])
  end

  def source_params
    params.require(:crawl_source).permit(
      :name, :base_url, :crawler_class, :enabled, :crawl_interval_hours
    )
  end
end
