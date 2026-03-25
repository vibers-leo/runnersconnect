class Admin::PosterAnalysesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png image/jpg].freeze
  MAX_FILE_SIZE = 5.megabytes

  # POST /admin/poster_analyses
  def create
    validate_params!

    # 임시 파일로 저장
    temp_file = save_temp_file(params[:poster_image])

    # Tesseract 분석
    result = PosterAnalysis::TesseractAnalyzer.new(temp_file.path).analyze

    if result.success?
      render json: {
        success: true,
        data: result.data,
        raw_text: result.raw_text,
        confidence: calculate_confidence(result.data)
      }
    else
      render json: {
        success: false,
        error: result.error
      }, status: :unprocessable_entity
    end
  ensure
    temp_file&.close!
  end

  private

  def validate_params!
    file = params[:poster_image]

    unless file.present?
      render json: { error: '이미지 파일을 업로드해주세요' }, status: :bad_request
      return
    end

    unless ALLOWED_CONTENT_TYPES.include?(file.content_type)
      render json: { error: 'JPEG, PNG 파일만 업로드 가능합니다' }, status: :unprocessable_entity
      return
    end

    if file.size > MAX_FILE_SIZE
      render json: { error: '파일 크기는 5MB 이하여야 합니다' }, status: :unprocessable_entity
      return
    end
  end

  def save_temp_file(uploaded_file)
    temp_file = Tempfile.new(['poster', File.extname(uploaded_file.original_filename)])
    temp_file.binmode
    temp_file.write(uploaded_file.read)
    temp_file.rewind
    temp_file
  end

  def calculate_confidence(data)
    # 필드별 신뢰도 계산
    filled_fields = data[:race].compact.count
    total_fields = data[:race].keys.count

    {
      overall: (filled_fields.to_f / total_fields * 100).round(2),
      fields: {
        title: data[:race][:title].present? ? 90 : 0,
        location: data[:race][:location].present? ? 80 : 0,
        dates: data[:race][:start_at].present? ? 75 : 0,
        editions: data[:race_editions].any? ? 85 : 0
      }
    }
  end

  def check_admin
    unless current_user.admin?
      render json: { error: '관리자 권한이 필요합니다' }, status: :forbidden
    end
  end
end
